const express = require('express');
const { body, validationResult } = require('express-validator');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken, requireDoctor } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// Get doctor's schedule
router.get('/', authenticateToken, requireDoctor, async (req, res) => {
  try {
    const schedules = await prisma.schedule.findMany({
      where: { doctorId: req.user.id },
      orderBy: [
        { dayOfWeek: 'asc' },
        { startTime: 'asc' }
      ]
    });

    res.json({ schedules });
  } catch (error) {
    console.error('Get schedule error:', error);
    res.status(500).json({ error: 'Failed to get schedule' });
  }
});

// Create/Update schedule slot
router.post('/', authenticateToken, requireDoctor, [
  body('dayOfWeek').isInt({ min: 0, max: 6 }).withMessage('Day of week must be 0-6'),
  body('startTime').matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/).withMessage('Start time must be in HH:MM format'),
  body('endTime').matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/).withMessage('End time must be in HH:MM format'),
  body('isAvailable').isBoolean().withMessage('isAvailable must be boolean')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { dayOfWeek, startTime, endTime, isAvailable } = req.body;

    // Validate time range
    if (startTime >= endTime) {
      return res.status(400).json({ error: 'Start time must be before end time' });
    }

    // Check for overlapping schedules
    const overlappingSchedule = await prisma.schedule.findFirst({
      where: {
        doctorId: req.user.id,
        dayOfWeek: parseInt(dayOfWeek),
        OR: [
          {
            startTime: { lte: startTime },
            endTime: { gt: startTime }
          },
          {
            startTime: { lt: endTime },
            endTime: { gte: endTime }
          },
          {
            startTime: { gte: startTime },
            endTime: { lte: endTime }
          }
        ]
      }
    });

    if (overlappingSchedule) {
      return res.status(400).json({ error: 'Time slot overlaps with existing schedule' });
    }

    const schedule = await prisma.schedule.create({
      data: {
        doctorId: req.user.id,
        dayOfWeek: parseInt(dayOfWeek),
        startTime,
        endTime,
        isAvailable
      }
    });

    res.status(201).json({
      message: 'Schedule slot created successfully',
      schedule
    });
  } catch (error) {
    console.error('Create schedule error:', error);
    res.status(500).json({ error: 'Failed to create schedule slot' });
  }
});

// Update schedule slot
router.put('/:scheduleId', authenticateToken, requireDoctor, [
  body('startTime').optional().matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/),
  body('endTime').optional().matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/),
  body('isAvailable').optional().isBoolean()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { scheduleId } = req.params;
    const { startTime, endTime, isAvailable } = req.body;

    // Verify schedule belongs to doctor
    const existingSchedule = await prisma.schedule.findFirst({
      where: {
        id: scheduleId,
        doctorId: req.user.id
      }
    });

    if (!existingSchedule) {
      return res.status(404).json({ error: 'Schedule not found' });
    }

    // Validate time range if both times are provided
    if (startTime && endTime && startTime >= endTime) {
      return res.status(400).json({ error: 'Start time must be before end time' });
    }

    // Check for overlapping schedules if times are being changed
    if (startTime || endTime) {
      const finalStartTime = startTime || existingSchedule.startTime;
      const finalEndTime = endTime || existingSchedule.endTime;

      const overlappingSchedule = await prisma.schedule.findFirst({
        where: {
          doctorId: req.user.id,
          dayOfWeek: existingSchedule.dayOfWeek,
          id: { not: scheduleId },
          OR: [
            {
              startTime: { lte: finalStartTime },
              endTime: { gt: finalStartTime }
            },
            {
              startTime: { lt: finalEndTime },
              endTime: { gte: finalEndTime }
            },
            {
              startTime: { gte: finalStartTime },
              endTime: { lte: finalEndTime }
            }
          ]
        }
      });

      if (overlappingSchedule) {
        return res.status(400).json({ error: 'Time slot overlaps with existing schedule' });
      }
    }

    const updatedSchedule = await prisma.schedule.update({
      where: { id: scheduleId },
      data: {
        startTime: startTime || undefined,
        endTime: endTime || undefined,
        isAvailable: isAvailable !== undefined ? isAvailable : undefined
      }
    });

    res.json({
      message: 'Schedule updated successfully',
      schedule: updatedSchedule
    });
  } catch (error) {
    console.error('Update schedule error:', error);
    res.status(500).json({ error: 'Failed to update schedule' });
  }
});

// Delete schedule slot
router.delete('/:scheduleId', authenticateToken, requireDoctor, async (req, res) => {
  try {
    const { scheduleId } = req.params;

    // Verify schedule belongs to doctor
    const schedule = await prisma.schedule.findFirst({
      where: {
        id: scheduleId,
        doctorId: req.user.id
      }
    });

    if (!schedule) {
      return res.status(404).json({ error: 'Schedule not found' });
    }

    await prisma.schedule.delete({
      where: { id: scheduleId }
    });

    res.json({ message: 'Schedule deleted successfully' });
  } catch (error) {
    console.error('Delete schedule error:', error);
    res.status(500).json({ error: 'Failed to delete schedule' });
  }
});

// Bulk update schedules
router.post('/bulk', authenticateToken, requireDoctor, [
  body('schedules').isArray().withMessage('Schedules must be an array'),
  body('schedules.*.dayOfWeek').isInt({ min: 0, max: 6 }),
  body('schedules.*.startTime').matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/),
  body('schedules.*.endTime').matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/),
  body('schedules.*.isAvailable').isBoolean()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { schedules } = req.body;

    // Validate all time ranges
    for (const schedule of schedules) {
      if (schedule.startTime >= schedule.endTime) {
        return res.status(400).json({
          error: `Invalid time range for day ${schedule.dayOfWeek}: start time must be before end time`
        });
      }
    }

    // Delete existing schedules for this doctor
    await prisma.schedule.deleteMany({
      where: { doctorId: req.user.id }
    });

    // Create new schedules
    const createdSchedules = await prisma.schedule.createMany({
      data: schedules.map(schedule => ({
        doctorId: req.user.id,
        dayOfWeek: parseInt(schedule.dayOfWeek),
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        isAvailable: schedule.isAvailable
      }))
    });

    res.json({
      message: 'Schedules updated successfully',
      count: createdSchedules.count
    });
  } catch (error) {
    console.error('Bulk update schedules error:', error);
    res.status(500).json({ error: 'Failed to update schedules' });
  }
});

// Get available time slots for a specific date
router.get('/available/:date', async (req, res) => {
  try {
    const { date } = req.params;
    const { doctorId } = req.query;

    if (!doctorId) {
      return res.status(400).json({ error: 'Doctor ID is required' });
    }

    const targetDate = new Date(date);
    const dayOfWeek = targetDate.getDay();

    // Get doctor's schedule for this day
    const schedules = await prisma.schedule.findMany({
      where: {
        doctorId,
        dayOfWeek,
        isAvailable: true
      },
      orderBy: { startTime: 'asc' }
    });

    // Get booked consultations for this date
    const bookedConsultations = await prisma.consultation.findMany({
      where: {
        doctorId,
        scheduledAt: {
          gte: new Date(targetDate.setHours(0, 0, 0, 0)),
          lt: new Date(targetDate.setHours(23, 59, 59, 999))
        },
        status: {
          in: ['SCHEDULED', 'IN_PROGRESS']
        }
      },
      select: {
        scheduledAt: true
      }
    });

    // Generate available time slots
    const availableSlots = [];
    const bookedTimes = bookedConsultations.map(c =>
      c.scheduledAt.toTimeString().slice(0, 5)
    );

    schedules.forEach(schedule => {
      const startTime = new Date(`2000-01-01T${schedule.startTime}:00`);
      const endTime = new Date(`2000-01-01T${schedule.endTime}:00`);

      // Generate 30-minute slots
      for (let time = startTime; time < endTime; time.setMinutes(time.getMinutes() + 30)) {
        const timeString = time.toTimeString().slice(0, 5);

        if (!bookedTimes.includes(timeString)) {
          availableSlots.push({
            time: timeString,
            date: date
          });
        }
      }
    });

    res.json({ availableSlots });
  } catch (error) {
    console.error('Get available slots error:', error);
    res.status(500).json({ error: 'Failed to get available time slots' });
  }
});

module.exports = router;