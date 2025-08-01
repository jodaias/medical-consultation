const express = require('express');
const { body, validationResult, query } = require('express-validator');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken, requireDoctor, requirePatient } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// Create new consultation (Patient only)
router.post('/', authenticateToken, requirePatient, [
  body('doctorId').notEmpty().withMessage('Doctor ID is required'),
  body('scheduledAt').isISO8601().withMessage('Valid scheduled date is required'),
  body('notes').optional().isLength({ max: 1000 })
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { doctorId, scheduledAt, notes } = req.body;

    // Check if doctor exists and is available
    const doctor = await prisma.user.findFirst({
      where: {
        id: doctorId,
        userType: 'DOCTOR',
        isActive: true,
        isVerified: true
      },
      include: {
        doctorProfile: true
      }
    });

    if (!doctor) {
      return res.status(404).json({ error: 'Doctor not found' });
    }

    if (!doctor.doctorProfile?.isAvailable) {
      return res.status(400).json({ error: 'Doctor is not available' });
    }

    // Check if the time slot is available
    const scheduledDate = new Date(scheduledAt);
    const dayOfWeek = scheduledDate.getDay();
    const timeString = scheduledDate.toTimeString().slice(0, 5);

    const schedule = await prisma.schedule.findFirst({
      where: {
        doctorId,
        dayOfWeek,
        startTime: { lte: timeString },
        endTime: { gte: timeString },
        isAvailable: true
      }
    });

    if (!schedule) {
      return res.status(400).json({ error: 'Selected time slot is not available' });
    }

    // Check if there's already a consultation at this time
    const existingConsultation = await prisma.consultation.findFirst({
      where: {
        doctorId,
        scheduledAt: scheduledDate,
        status: {
          in: ['SCHEDULED', 'IN_PROGRESS']
        }
      }
    });

    if (existingConsultation) {
      return res.status(400).json({ error: 'Time slot already booked' });
    }

    // Create consultation
    const consultation = await prisma.consultation.create({
      data: {
        patientId: req.user.id,
        doctorId,
        scheduledAt: scheduledDate,
        notes,
        status: 'SCHEDULED'
      },
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
            profileImage: true,
            doctorProfile: {
              select: {
                specialty: true,
                consultationFee: true
              }
            }
          }
        }
      }
    });

    res.status(201).json({
      message: 'Consultation scheduled successfully',
      consultation
    });
  } catch (error) {
    console.error('Create consultation error:', error);
    res.status(500).json({ error: 'Failed to schedule consultation' });
  }
});

// Get user consultations
router.get('/', authenticateToken, [
  query('status').optional().isIn(['SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW']),
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 50 })
], async (req, res) => {
  try {
    const { status, page = 1, limit = 10 } = req.query;
    const skip = (page - 1) * limit;

    const where = {
      OR: [
        { patientId: req.user.id },
        { doctorId: req.user.id }
      ]
    };

    if (status) {
      where.status = status;
    }

    const [consultations, total] = await Promise.all([
      prisma.consultation.findMany({
        where,
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
              profileImage: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  consultationFee: true
                }
              }
            }
          },
          messages: {
            orderBy: {
              createdAt: 'desc'
            },
            take: 1
          }
        },
        orderBy: {
          scheduledAt: 'desc'
        },
        skip,
        take: parseInt(limit)
      }),
      prisma.consultation.count({ where })
    ]);

    res.json({
      consultations,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get consultations error:', error);
    res.status(500).json({ error: 'Failed to get consultations' });
  }
});

// Get consultation details
router.get('/:consultationId', authenticateToken, async (req, res) => {
  try {
    const { consultationId } = req.params;

    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        OR: [
          { patientId: req.user.id },
          { doctorId: req.user.id }
        ]
      },
      include: {
        patient: {
          select: {
            id: true,
            name: true,
            profileImage: true,
            patientProfile: {
              select: {
                allergies: true,
                currentMedications: true,
                medicalHistory: true
              }
            }
          }
        },
        doctor: {
          select: {
            id: true,
            name: true,
            profileImage: true,
            doctorProfile: {
              select: {
                specialty: true,
                consultationFee: true,
                bio: true
              }
            }
          }
        },
        messages: {
          orderBy: {
            createdAt: 'asc'
          }
        },
        prescriptions: {
          orderBy: {
            createdAt: 'desc'
          }
        }
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found' });
    }

    res.json({ consultation });
  } catch (error) {
    console.error('Get consultation details error:', error);
    res.status(500).json({ error: 'Failed to get consultation details' });
  }
});

// Update consultation status
router.patch('/:consultationId/status', authenticateToken, [
  body('status').isIn(['SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW'])
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { consultationId } = req.params;
    const { status } = req.body;

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

    // Only doctor can start/complete consultation
    if (['IN_PROGRESS', 'COMPLETED'].includes(status) && consultation.doctorId !== req.user.id) {
      return res.status(403).json({ error: 'Only doctor can update consultation status' });
    }

    const updateData = { status };

    if (status === 'IN_PROGRESS' && !consultation.startedAt) {
      updateData.startedAt = new Date();
    } else if (status === 'COMPLETED' && !consultation.endedAt) {
      updateData.endedAt = new Date();
    }

    const updatedConsultation = await prisma.consultation.update({
      where: { id: consultationId },
      data: updateData,
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
    });

    res.json({
      message: 'Consultation status updated successfully',
      consultation: updatedConsultation
    });
  } catch (error) {
    console.error('Update consultation status error:', error);
    res.status(500).json({ error: 'Failed to update consultation status' });
  }
});

// Add consultation notes (Doctor only)
router.patch('/:consultationId/notes', authenticateToken, requireDoctor, [
  body('notes').notEmpty().withMessage('Notes are required'),
  body('diagnosis').optional(),
  body('prescription').optional()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { consultationId } = req.params;
    const { notes, diagnosis, prescription } = req.body;

    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        doctorId: req.user.id
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found' });
    }

    const updatedConsultation = await prisma.consultation.update({
      where: { id: consultationId },
      data: {
        notes,
        diagnosis,
        prescription
      },
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
    });

    res.json({
      message: 'Consultation notes updated successfully',
      consultation: updatedConsultation
    });
  } catch (error) {
    console.error('Update consultation notes error:', error);
    res.status(500).json({ error: 'Failed to update consultation notes' });
  }
});

// Cancel consultation
router.delete('/:consultationId', authenticateToken, async (req, res) => {
  try {
    const { consultationId } = req.params;

    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        OR: [
          { patientId: req.user.id },
          { doctorId: req.user.id }
        ],
        status: {
          in: ['SCHEDULED', 'IN_PROGRESS']
        }
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found or cannot be cancelled' });
    }

    await prisma.consultation.update({
      where: { id: consultationId },
      data: { status: 'CANCELLED' }
    });

    res.json({ message: 'Consultation cancelled successfully' });
  } catch (error) {
    console.error('Cancel consultation error:', error);
    res.status(500).json({ error: 'Failed to cancel consultation' });
  }
});

// Get consultation statistics (for dashboard)
router.get('/stats/dashboard', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const userType = req.user.userType;

    const where = userType === 'DOCTOR'
      ? { doctorId: userId }
      : { patientId: userId };

    const [
      totalConsultations,
      completedConsultations,
      scheduledConsultations,
      inProgressConsultations,
      cancelledConsultations
    ] = await Promise.all([
      prisma.consultation.count({ where }),
      prisma.consultation.count({ where: { ...where, status: 'COMPLETED' } }),
      prisma.consultation.count({ where: { ...where, status: 'SCHEDULED' } }),
      prisma.consultation.count({ where: { ...where, status: 'IN_PROGRESS' } }),
      prisma.consultation.count({ where: { ...where, status: 'CANCELLED' } })
    ]);

    // Get recent consultations
    const recentConsultations = await prisma.consultation.findMany({
      where,
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
      },
      orderBy: {
        scheduledAt: 'desc'
      },
      take: 5
    });

    res.json({
      stats: {
        total: totalConsultations,
        completed: completedConsultations,
        scheduled: scheduledConsultations,
        inProgress: inProgressConsultations,
        cancelled: cancelledConsultations
      },
      recentConsultations
    });
  } catch (error) {
    console.error('Get consultation stats error:', error);
    res.status(500).json({ error: 'Failed to get consultation statistics' });
  }
});

module.exports = router;