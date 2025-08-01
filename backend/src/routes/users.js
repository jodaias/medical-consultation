const express = require('express');
const { body, validationResult, query } = require('express-validator');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken, requireDoctor, requirePatient } = require('../middleware/auth');
const multer = require('multer');
const path = require('path');

const router = express.Router();
const prisma = new PrismaClient();

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 5 * 1024 * 1024 // 5MB
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed'));
    }
  }
});

// Get user profile
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: {
        doctorProfile: true,
        patientProfile: true
      }
    });

    const { password, ...userWithoutPassword } = user;
    res.json({ user: userWithoutPassword });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Failed to get profile' });
  }
});

// Update user profile
router.put('/profile', authenticateToken, [
  body('name').optional().trim().isLength({ min: 2 }),
  body('phone').optional().isMobilePhone(),
  body('dateOfBirth').optional().isISO8601(),
  body('gender').optional().isIn(['MALE', 'FEMALE', 'OTHER'])
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, phone, dateOfBirth, gender } = req.body;

    const updatedUser = await prisma.user.update({
      where: { id: req.user.id },
      data: {
        name: name || undefined,
        phone: phone || undefined,
        dateOfBirth: dateOfBirth ? new Date(dateOfBirth) : undefined,
        gender: gender || undefined
      },
      include: {
        doctorProfile: true,
        patientProfile: true
      }
    });

    const { password, ...userWithoutPassword } = updatedUser;
    res.json({
      message: 'Profile updated successfully',
      user: userWithoutPassword
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

// Upload profile image
router.post('/profile/image', authenticateToken, upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No image file provided' });
    }

    const imageUrl = `/uploads/${req.file.filename}`;

    await prisma.user.update({
      where: { id: req.user.id },
      data: { profileImage: imageUrl }
    });

    res.json({
      message: 'Profile image uploaded successfully',
      imageUrl
    });
  } catch (error) {
    console.error('Upload image error:', error);
    res.status(500).json({ error: 'Failed to upload image' });
  }
});

// Create/Update doctor profile
router.post('/doctor-profile', authenticateToken, requireDoctor, [
  body('crm').notEmpty().withMessage('CRM is required'),
  body('specialty').notEmpty().withMessage('Specialty is required'),
  body('experience').isInt({ min: 0 }).withMessage('Experience must be a positive number'),
  body('consultationFee').isFloat({ min: 0 }).withMessage('Consultation fee must be positive'),
  body('bio').optional().isLength({ max: 1000 }),
  body('education').isArray().withMessage('Education must be an array'),
  body('certifications').isArray().withMessage('Certifications must be an array')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { crm, specialty, experience, consultationFee, bio, education, certifications, availability } = req.body;

    // Check if CRM already exists
    const existingDoctor = await prisma.doctorProfile.findUnique({
      where: { crm }
    });

    if (existingDoctor && existingDoctor.userId !== req.user.id) {
      return res.status(400).json({ error: 'CRM already registered' });
    }

    const doctorProfile = await prisma.doctorProfile.upsert({
      where: { userId: req.user.id },
      update: {
        crm,
        specialty,
        experience: parseInt(experience),
        consultationFee: parseFloat(consultationFee),
        bio,
        education,
        certifications,
        availability: availability || {}
      },
      create: {
        userId: req.user.id,
        crm,
        specialty,
        experience: parseInt(experience),
        consultationFee: parseFloat(consultationFee),
        bio,
        education,
        certifications,
        availability: availability || {}
      }
    });

    res.json({
      message: 'Doctor profile updated successfully',
      doctorProfile
    });
  } catch (error) {
    console.error('Doctor profile error:', error);
    res.status(500).json({ error: 'Failed to update doctor profile' });
  }
});

// Create/Update patient profile
router.post('/patient-profile', authenticateToken, requirePatient, [
  body('emergencyContact').optional().isMobilePhone(),
  body('allergies').isArray().withMessage('Allergies must be an array'),
  body('currentMedications').isArray().withMessage('Current medications must be an array')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { emergencyContact, allergies, currentMedications, medicalHistory, insurance } = req.body;

    const patientProfile = await prisma.patientProfile.upsert({
      where: { userId: req.user.id },
      update: {
        emergencyContact,
        allergies,
        currentMedications,
        medicalHistory,
        insurance
      },
      create: {
        userId: req.user.id,
        emergencyContact,
        allergies,
        currentMedications,
        medicalHistory,
        insurance
      }
    });

    res.json({
      message: 'Patient profile updated successfully',
      patientProfile
    });
  } catch (error) {
    console.error('Patient profile error:', error);
    res.status(500).json({ error: 'Failed to update patient profile' });
  }
});

// Search doctors
router.get('/doctors', [
  query('specialty').optional().isString(),
  query('name').optional().isString(),
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 50 })
], async (req, res) => {
  try {
    const { specialty, name, page = 1, limit = 10 } = req.query;
    const skip = (page - 1) * limit;

    const where = {
      userType: 'DOCTOR',
      isActive: true,
      isVerified: true,
      doctorProfile: {
        isAvailable: true
      }
    };

    if (specialty) {
      where.doctorProfile.specialty = {
        contains: specialty,
        mode: 'insensitive'
      };
    }

    if (name) {
      where.name = {
        contains: name,
        mode: 'insensitive'
      };
    }

    const [doctors, total] = await Promise.all([
      prisma.user.findMany({
        where,
        include: {
          doctorProfile: {
            select: {
              specialty: true,
              experience: true,
              consultationFee: true,
              bio: true,
              isAvailable: true
            }
          },
          ratings: {
            select: {
              rating: true
            }
          }
        },
        skip,
        take: parseInt(limit),
        orderBy: {
          name: 'asc'
        }
      }),
      prisma.user.count({ where })
    ]);

    // Calculate average rating for each doctor
    const doctorsWithRating = doctors.map(doctor => {
      const avgRating = doctor.ratings.length > 0
        ? doctor.ratings.reduce((sum, r) => sum + r.rating, 0) / doctor.ratings.length
        : 0;

      const { ratings, ...doctorWithoutRatings } = doctor;
      return {
        ...doctorWithoutRatings,
        averageRating: Math.round(avgRating * 10) / 10
      };
    });

    res.json({
      doctors: doctorsWithRating,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Search doctors error:', error);
    res.status(500).json({ error: 'Failed to search doctors' });
  }
});

// Get doctor details
router.get('/doctors/:doctorId', async (req, res) => {
  try {
    const { doctorId } = req.params;

    const doctor = await prisma.user.findFirst({
      where: {
        id: doctorId,
        userType: 'DOCTOR',
        isActive: true,
        isVerified: true
      },
      include: {
        doctorProfile: true,
        ratings: {
          include: {
            patient: {
              select: {
                name: true,
                profileImage: true
              }
            }
          },
          orderBy: {
            createdAt: 'desc'
          },
          take: 10
        }
      }
    });

    if (!doctor) {
      return res.status(404).json({ error: 'Doctor not found' });
    }

    // Calculate average rating
    const avgRating = doctor.ratings.length > 0
      ? doctor.ratings.reduce((sum, r) => sum + r.rating, 0) / doctor.ratings.length
      : 0;

    const { password, ...doctorWithoutPassword } = doctor;

    res.json({
      doctor: {
        ...doctorWithoutPassword,
        averageRating: Math.round(avgRating * 10) / 10
      }
    });
  } catch (error) {
    console.error('Get doctor details error:', error);
    res.status(500).json({ error: 'Failed to get doctor details' });
  }
});

// Get doctor schedule
router.get('/doctors/:doctorId/schedule', async (req, res) => {
  try {
    const { doctorId } = req.params;

    const schedules = await prisma.schedule.findMany({
      where: {
        doctorId,
        isAvailable: true
      },
      orderBy: [
        { dayOfWeek: 'asc' },
        { startTime: 'asc' }
      ]
    });

    res.json({ schedules });
  } catch (error) {
    console.error('Get doctor schedule error:', error);
    res.status(500).json({ error: 'Failed to get doctor schedule' });
  }
});

module.exports = router;