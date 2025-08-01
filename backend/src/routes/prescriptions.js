const express = require('express');
const { body, validationResult, query } = require('express-validator');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken, requireDoctor } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// Create prescription (Doctor only)
router.post('/', authenticateToken, requireDoctor, [
  body('consultationId').notEmpty().withMessage('Consultation ID is required'),
  body('patientId').notEmpty().withMessage('Patient ID is required'),
  body('medications').isArray().withMessage('Medications must be an array'),
  body('instructions').notEmpty().withMessage('Instructions are required'),
  body('dosage').notEmpty().withMessage('Dosage is required'),
  body('duration').notEmpty().withMessage('Duration is required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { consultationId, patientId, medications, instructions, dosage, duration } = req.body;

    // Verify consultation exists and doctor has access
    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        doctorId: req.user.id,
        patientId
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found' });
    }

    // Create prescription
    const prescription = await prisma.prescription.create({
      data: {
        consultationId,
        doctorId: req.user.id,
        patientId,
        medications,
        instructions,
        dosage,
        duration
      },
      include: {
        consultation: {
          include: {
            patient: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            },
            doctor: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            }
          }
        }
      }
    });

    res.status(201).json({
      message: 'Prescription created successfully',
      prescription
    });
  } catch (error) {
    console.error('Create prescription error:', error);
    res.status(500).json({ error: 'Failed to create prescription' });
  }
});

// Get prescriptions for a consultation
router.get('/consultation/:consultationId', authenticateToken, async (req, res) => {
  try {
    const { consultationId } = req.params;

    // Verify consultation exists and user has access
    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        OR: [
          { patientId: req.user.id },
          { doctorId: req.user.id }
        ]
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found' });
    }

    const prescriptions = await prisma.prescription.findMany({
      where: { consultationId },
      include: {
        doctor: {
          select: {
            id: true,
            name: true,
            profileImage: true
          }
        },
        patient: {
          select: {
            id: true,
            name: true,
            profileImage: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    res.json({ prescriptions });
  } catch (error) {
    console.error('Get prescriptions error:', error);
    res.status(500).json({ error: 'Failed to get prescriptions' });
  }
});

// Get user's prescriptions
router.get('/my-prescriptions', authenticateToken, [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 50 })
], async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query;
    const skip = (page - 1) * limit;

    const where = req.user.userType === 'DOCTOR'
      ? { doctorId: req.user.id }
      : { patientId: req.user.id };

    const [prescriptions, total] = await Promise.all([
      prisma.prescription.findMany({
        where,
        include: {
          consultation: {
            include: {
              patient: {
                select: {
                  id: true,
                  name: true,
                  profileImage: true
                }
              },
              doctor: {
                select: {
                  id: true,
                  name: true,
                  profileImage: true
                }
              }
            }
          }
        },
        orderBy: {
          createdAt: 'desc'
        },
        skip,
        take: parseInt(limit)
      }),
      prisma.prescription.count({ where })
    ]);

    res.json({
      prescriptions,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get my prescriptions error:', error);
    res.status(500).json({ error: 'Failed to get prescriptions' });
  }
});

// Get prescription details
router.get('/:prescriptionId', authenticateToken, async (req, res) => {
  try {
    const { prescriptionId } = req.params;

    const prescription = await prisma.prescription.findFirst({
      where: {
        id: prescriptionId,
        OR: [
          { doctorId: req.user.id },
          { patientId: req.user.id }
        ]
      },
      include: {
        consultation: {
          include: {
            patient: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            },
            doctor: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            }
          }
        }
      }
    });

    if (!prescription) {
      return res.status(404).json({ error: 'Prescription not found' });
    }

    res.json({ prescription });
  } catch (error) {
    console.error('Get prescription details error:', error);
    res.status(500).json({ error: 'Failed to get prescription details' });
  }
});

// Update prescription (Doctor only)
router.put('/:prescriptionId', authenticateToken, requireDoctor, [
  body('medications').optional().isArray(),
  body('instructions').optional().notEmpty(),
  body('dosage').optional().notEmpty(),
  body('duration').optional().notEmpty()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { prescriptionId } = req.params;
    const { medications, instructions, dosage, duration } = req.body;

    // Verify prescription exists and belongs to doctor
    const prescription = await prisma.prescription.findFirst({
      where: {
        id: prescriptionId,
        doctorId: req.user.id
      }
    });

    if (!prescription) {
      return res.status(404).json({ error: 'Prescription not found' });
    }

    const updatedPrescription = await prisma.prescription.update({
      where: { id: prescriptionId },
      data: {
        medications: medications || undefined,
        instructions: instructions || undefined,
        dosage: dosage || undefined,
        duration: duration || undefined
      },
      include: {
        consultation: {
          include: {
            patient: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            },
            doctor: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            }
          }
        }
      }
    });

    res.json({
      message: 'Prescription updated successfully',
      prescription: updatedPrescription
    });
  } catch (error) {
    console.error('Update prescription error:', error);
    res.status(500).json({ error: 'Failed to update prescription' });
  }
});

// Delete prescription (Doctor only)
router.delete('/:prescriptionId', authenticateToken, requireDoctor, async (req, res) => {
  try {
    const { prescriptionId } = req.params;

    // Verify prescription exists and belongs to doctor
    const prescription = await prisma.prescription.findFirst({
      where: {
        id: prescriptionId,
        doctorId: req.user.id
      }
    });

    if (!prescription) {
      return res.status(404).json({ error: 'Prescription not found' });
    }

    await prisma.prescription.delete({
      where: { id: prescriptionId }
    });

    res.json({ message: 'Prescription deleted successfully' });
  } catch (error) {
    console.error('Delete prescription error:', error);
    res.status(500).json({ error: 'Failed to delete prescription' });
  }
});

// Get prescription statistics (for dashboard)
router.get('/stats/dashboard', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const userType = req.user.userType;

    const where = userType === 'DOCTOR'
      ? { doctorId: userId }
      : { patientId: userId };

    const [
      totalPrescriptions,
      thisMonthPrescriptions,
      thisYearPrescriptions
    ] = await Promise.all([
      prisma.prescription.count({ where }),
      prisma.prescription.count({
        where: {
          ...where,
          createdAt: {
            gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
          }
        }
      }),
      prisma.prescription.count({
        where: {
          ...where,
          createdAt: {
            gte: new Date(new Date().getFullYear(), 0, 1)
          }
        }
      })
    ]);

    // Get recent prescriptions
    const recentPrescriptions = await prisma.prescription.findMany({
      where,
      include: {
        consultation: {
          include: {
            patient: {
              select: {
                name: true,
                profileImage: true
              }
            },
            doctor: {
              select: {
                name: true,
                profileImage: true
              }
            }
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      },
      take: 5
    });

    res.json({
      stats: {
        total: totalPrescriptions,
        thisMonth: thisMonthPrescriptions,
        thisYear: thisYearPrescriptions
      },
      recentPrescriptions
    });
  } catch (error) {
    console.error('Get prescription stats error:', error);
    res.status(500).json({ error: 'Failed to get prescription statistics' });
  }
});

module.exports = router;