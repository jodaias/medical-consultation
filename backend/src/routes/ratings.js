const express = require('express');
const { body, validationResult, query } = require('express-validator');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken, requirePatient } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// Create rating (Patient only)
router.post('/', authenticateToken, requirePatient, [
  body('doctorId').notEmpty().withMessage('Doctor ID is required'),
  body('rating').isInt({ min: 1, max: 5 }).withMessage('Rating must be between 1 and 5'),
  body('comment').optional().isLength({ max: 500 }).withMessage('Comment must be less than 500 characters'),
  body('consultationId').optional().notEmpty().withMessage('Consultation ID is required if provided')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { doctorId, rating, comment, consultationId } = req.body;

    // Verify doctor exists
    const doctor = await prisma.user.findFirst({
      where: {
        id: doctorId,
        userType: 'DOCTOR',
        isActive: true
      }
    });

    if (!doctor) {
      return res.status(404).json({ error: 'Doctor not found' });
    }

    // Check if patient has already rated this doctor
    const existingRating = await prisma.rating.findFirst({
      where: {
        patientId: req.user.id,
        doctorId
      }
    });

    if (existingRating) {
      return res.status(400).json({ error: 'You have already rated this doctor' });
    }

    // Verify consultation exists and belongs to patient if provided
    if (consultationId) {
      const consultation = await prisma.consultation.findFirst({
        where: {
          id: consultationId,
          patientId: req.user.id,
          doctorId
        }
      });

      if (!consultation) {
        return res.status(404).json({ error: 'Consultation not found' });
      }
    }

    // Create rating
    const newRating = await prisma.rating.create({
      data: {
        patientId: req.user.id,
        doctorId,
        rating,
        comment,
        consultationId
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

    res.status(201).json({
      message: 'Rating submitted successfully',
      rating: newRating
    });
  } catch (error) {
    console.error('Create rating error:', error);
    res.status(500).json({ error: 'Failed to submit rating' });
  }
});

// Get doctor ratings
router.get('/doctor/:doctorId', [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 50 })
], async (req, res) => {
  try {
    const { doctorId } = req.params;
    const { page = 1, limit = 10 } = req.query;
    const skip = (page - 1) * limit;

    // Verify doctor exists
    const doctor = await prisma.user.findFirst({
      where: {
        id: doctorId,
        userType: 'DOCTOR',
        isActive: true
      }
    });

    if (!doctor) {
      return res.status(404).json({ error: 'Doctor not found' });
    }

    const [ratings, total] = await Promise.all([
      prisma.rating.findMany({
        where: { doctorId },
        include: {
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
        },
        skip,
        take: parseInt(limit)
      }),
      prisma.rating.count({ where: { doctorId } })
    ]);

    // Calculate average rating
    const averageRating = ratings.length > 0
      ? ratings.reduce((sum, r) => sum + r.rating, 0) / ratings.length
      : 0;

    // Calculate rating distribution
    const ratingDistribution = {
      1: 0, 2: 0, 3: 0, 4: 0, 5: 0
    };

    ratings.forEach(rating => {
      ratingDistribution[rating.rating]++;
    });

    res.json({
      ratings,
      averageRating: Math.round(averageRating * 10) / 10,
      ratingDistribution,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get doctor ratings error:', error);
    res.status(500).json({ error: 'Failed to get doctor ratings' });
  }
});

// Get user's ratings
router.get('/my-ratings', authenticateToken, [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 50 })
], async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query;
    const skip = (page - 1) * limit;

    const where = req.user.userType === 'DOCTOR'
      ? { doctorId: req.user.id }
      : { patientId: req.user.id };

    const [ratings, total] = await Promise.all([
      prisma.rating.findMany({
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
              profileImage: true
            }
          }
        },
        orderBy: {
          createdAt: 'desc'
        },
        skip,
        take: parseInt(limit)
      }),
      prisma.rating.count({ where })
    ]);

    res.json({
      ratings,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get my ratings error:', error);
    res.status(500).json({ error: 'Failed to get ratings' });
  }
});

// Update rating (Patient only)
router.put('/:ratingId', authenticateToken, requirePatient, [
  body('rating').isInt({ min: 1, max: 5 }).withMessage('Rating must be between 1 and 5'),
  body('comment').optional().isLength({ max: 500 }).withMessage('Comment must be less than 500 characters')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { ratingId } = req.params;
    const { rating, comment } = req.body;

    // Verify rating exists and belongs to patient
    const existingRating = await prisma.rating.findFirst({
      where: {
        id: ratingId,
        patientId: req.user.id
      }
    });

    if (!existingRating) {
      return res.status(404).json({ error: 'Rating not found' });
    }

    const updatedRating = await prisma.rating.update({
      where: { id: ratingId },
      data: {
        rating,
        comment
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
      message: 'Rating updated successfully',
      rating: updatedRating
    });
  } catch (error) {
    console.error('Update rating error:', error);
    res.status(500).json({ error: 'Failed to update rating' });
  }
});

// Delete rating (Patient only)
router.delete('/:ratingId', authenticateToken, requirePatient, async (req, res) => {
  try {
    const { ratingId } = req.params;

    // Verify rating exists and belongs to patient
    const rating = await prisma.rating.findFirst({
      where: {
        id: ratingId,
        patientId: req.user.id
      }
    });

    if (!rating) {
      return res.status(404).json({ error: 'Rating not found' });
    }

    await prisma.rating.delete({
      where: { id: ratingId }
    });

    res.json({ message: 'Rating deleted successfully' });
  } catch (error) {
    console.error('Delete rating error:', error);
    res.status(500).json({ error: 'Failed to delete rating' });
  }
});

// Get rating statistics for a doctor
router.get('/doctor/:doctorId/stats', async (req, res) => {
  try {
    const { doctorId } = req.params;

    // Verify doctor exists
    const doctor = await prisma.user.findFirst({
      where: {
        id: doctorId,
        userType: 'DOCTOR',
        isActive: true
      }
    });

    if (!doctor) {
      return res.status(404).json({ error: 'Doctor not found' });
    }

    const [
      totalRatings,
      averageRating,
      ratingDistribution
    ] = await Promise.all([
      prisma.rating.count({ where: { doctorId } }),
      prisma.rating.aggregate({
        where: { doctorId },
        _avg: { rating: true }
      }),
      prisma.rating.groupBy({
        by: ['rating'],
        where: { doctorId },
        _count: { rating: true }
      })
    ]);

    // Format rating distribution
    const distribution = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
    ratingDistribution.forEach(item => {
      distribution[item.rating] = item._count.rating;
    });

    res.json({
      stats: {
        totalRatings,
        averageRating: averageRating._avg.rating || 0,
        ratingDistribution: distribution
      }
    });
  } catch (error) {
    console.error('Get rating stats error:', error);
    res.status(500).json({ error: 'Failed to get rating statistics' });
  }
});

// Check if user has rated a doctor
router.get('/check/:doctorId', authenticateToken, requirePatient, async (req, res) => {
  try {
    const { doctorId } = req.params;

    const rating = await prisma.rating.findFirst({
      where: {
        patientId: req.user.id,
        doctorId
      }
    });

    res.json({
      hasRated: !!rating,
      rating: rating || null
    });
  } catch (error) {
    console.error('Check rating error:', error);
    res.status(500).json({ error: 'Failed to check rating' });
  }
});

module.exports = router;