const ScheduleService = require("../services/schedule-service");
const BaseController = require("../interfaces/base-controller");

class ScheduleController extends BaseController {
  constructor() {
    const scheduleService = new ScheduleService();
    super(scheduleService);
    this.scheduleService = scheduleService;
  }

  create = this.handleAsync(async (req, res) => {
    try {
      const scheduleData = req.body;
      const userId = req.user.id;
      const schedule = await this.scheduleService.create(scheduleData, userId);
      return this.sendSuccess(
        res,
        schedule,
        "Schedule created successfully",
        201
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findById = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;
      const schedule = await this.scheduleService.findById(
        id,
        userId,
        userType
      );
      return this.sendSuccess(res, schedule, "Schedule found successfully");
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findAll = this.handleAsync(async (req, res) => {
    try {
      const filters = {
        doctorId: req.query.doctorId,
        dayOfWeek:
          req.query.dayOfWeek !== undefined
            ? parseInt(req.query.dayOfWeek)
            : undefined,
        isAvailable:
          req.query.isAvailable !== undefined
            ? req.query.isAvailable === "true"
            : undefined,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10,
      };
      const userId = req.user.id;
      const userType = req.user.userType;
      const result = await this.scheduleService.findAll(
        filters,
        userId,
        userType
      );
      return this.sendSuccess(res, result, "Schedules retrieved successfully");
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  update = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;
      const schedule = await this.scheduleService.update(
        id,
        updateData,
        userId,
        userType
      );
      return this.sendSuccess(res, schedule, "Schedule updated successfully");
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  delete = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;
      await this.scheduleService.delete(id, userId, userType);
      return this.sendSuccess(res, null, "Schedule deleted successfully");
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findByDoctor = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const filters = {
        dayOfWeek:
          req.query.dayOfWeek !== undefined
            ? parseInt(req.query.dayOfWeek)
            : undefined,
        isAvailable:
          req.query.isAvailable !== undefined
            ? req.query.isAvailable === "true"
            : undefined,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10,
      };
      const userId = req.user.id;
      const userType = req.user.userType;
      const result = await this.scheduleService.findByDoctor(
        doctorId,
        filters,
        userId,
        userType
      );
      return this.sendSuccess(
        res,
        result,
        "Doctor schedules retrieved successfully"
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findAvailableSlots = this.handleAsync(async (req, res) => {
    try {
      const { doctorId, date } = req.query;
      const userId = req.user.id;
      const userType = req.user.userType;
      if (!doctorId) {
        return this.sendError(
          res,
          new Error("DoctorId parameter is required"),
          400
        );
      }
      if (!date) {
        return this.sendError(
          res,
          new Error("Date parameter is required"),
          400
        );
      }
      const slots = await this.scheduleService.findAvailableSlots(
        doctorId,
        new Date(date),
        userId,
        userType
      );
      return this.sendSuccess(
        res,
        slots,
        "Available slots retrieved successfully"
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  checkAvailability = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const { startTime, endTime } = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;
      if (!startTime || !endTime) {
        return this.sendError(
          res,
          new Error("Start time and end time are required"),
          400
        );
      }
      const isAvailable = await this.scheduleService.checkAvailability(
        doctorId,
        new Date(startTime),
        new Date(endTime),
        userId,
        userType
      );
      return this.sendSuccess(
        res,
        { isAvailable },
        "Availability checked successfully"
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  getStats = this.handleAsync(async (req, res) => {
    try {
      const userId = req.user.id;
      const userType = req.user.userType;
      const stats = await this.scheduleService.getScheduleStats(
        userId,
        userType
      );
      return this.sendSuccess(
        res,
        stats,
        "Schedule statistics retrieved successfully"
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  getWeeklySchedule = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;
      const weeklySchedule = await this.scheduleService.getWeeklySchedule(
        doctorId,
        userId,
        userType
      );
      return this.sendSuccess(
        res,
        weeklySchedule,
        "Weekly schedule retrieved successfully"
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  bulkUpdate = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const schedules = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;
      if (!Array.isArray(schedules)) {
        return this.sendError(
          res,
          new Error("Schedules must be an array"),
          400
        );
      }
      const updatedSchedules = await this.scheduleService.bulkUpdate(
        doctorId,
        schedules,
        userId,
        userType
      );
      return this.sendSuccess(
        res,
        updatedSchedules,
        "Schedules updated successfully"
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  validate = this.handleAsync(async (req, res) => {
    try {
      const scheduleData = req.body;
      const errors = await this.scheduleService.validate(scheduleData);
      if (errors.length > 0) {
        return this.sendError(res, new Error(errors.join(", ")), 400);
      }
      return this.sendSuccess(res, { valid: true }, "Schedule data is valid");
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  confirmSchedule = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;
      const schedule = await this.scheduleService.confirmSchedule(
        id,
        userId,
        userType
      );
      return this.sendSuccess(
        res,
        schedule,
        "Schedule confirmed successfully"
      );
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });
}

module.exports = ScheduleController;