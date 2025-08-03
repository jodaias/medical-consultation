const { PrismaClient } = require('@prisma/client');
const { NotFoundException, ConflictException } = require('../exceptions/app-exception');

/**
 * ScheduleRepository - Implementa o padrão Repository
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ScheduleRepository {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async create(scheduleData) {
    try {
      const schedule = await this.prisma.schedule.create({
        data: scheduleData,
        include: {
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              }
            }
          }
        }
      });
      return schedule;
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Schedule already exists for this doctor and day');
      }
      throw error;
    }
  }

  async findById(id) {
    const schedule = await this.prisma.schedule.findUnique({
      where: { id },
      include: {
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: {
                specialty: true,
                crm: true
              }
            },
          }
        }
      }
    });

    if (!schedule) {
      throw new NotFoundException('Schedule not found');
    }

    return schedule;
  }

  async findAll(filters = {}) {
    const {
      doctorId,
      dayOfWeek,
      isAvailable,
      page = 1,
      limit = 10,
      orderBy = 'dayOfWeek',
      order = 'asc'
    } = filters;

    const skip = (page - 1) * limit;
    const where = {};

    if (doctorId) {
      where.doctorId = doctorId;
    }

    if (dayOfWeek !== undefined) {
      where.dayOfWeek = dayOfWeek;
    }

    if (isAvailable !== undefined) {
      where.isAvailable = isAvailable;
    }

    const [schedules, total] = await Promise.all([
      this.prisma.schedule.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [orderBy]: order },
        include: {
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              },
            }
          }
        }
      }),
      this.prisma.schedule.count({ where })
    ]);

    return {
      schedules,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async update(id, data) {
    try {
      const schedule = await this.prisma.schedule.update({
        where: { id },
        data,
        include: {
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              },
            }
          }
        }
      });
      return schedule;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Schedule not found');
      }
      throw error;
    }
  }

  async delete(id) {
    try {
      await this.prisma.schedule.delete({
        where: { id }
      });
      return true;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Schedule not found');
      }
      throw error;
    }
  }

  async exists(id) {
    const schedule = await this.prisma.schedule.findUnique({
      where: { id },
      select: { id: true }
    });
    return !!schedule;
  }

  async findByDoctor(doctorId, filters = {}) {
    const {
      dayOfWeek,
      isAvailable,
      page = 1,
      limit = 10
    } = filters;

    const skip = (page - 1) * limit;
    const where = { doctorId };

    if (dayOfWeek !== undefined) {
      where.dayOfWeek = dayOfWeek;
    }

    if (isAvailable !== undefined) {
      where.isAvailable = isAvailable;
    }

    const [schedules, total] = await Promise.all([
      this.prisma.schedule.findMany({
        where,
        skip,
        take: limit,
        orderBy: { dayOfWeek: 'asc' },
        include: {
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              },
            }
          }
        }
      }),
      this.prisma.schedule.count({ where })
    ]);

    return {
      schedules,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async findAvailableSlots(doctorId, date) {
    const dayOfWeek = date.getDay();

    const schedule = await this.prisma.schedule.findFirst({
      where: {
        doctorId,
        dayOfWeek,
        isAvailable: true
      }
    });

    if (!schedule) {
      return [];
    }

    // Gerar slots de tempo baseados na duração da consulta
    const slots = [];
    const startTime = new Date(`2000-01-01T${schedule.startTime}:00`);
    const endTime = new Date(`2000-01-01T${schedule.endTime}:00`);
    const duration = schedule.consultationDuration * 60 * 1000; // em milissegundos

    let currentTime = new Date(startTime);

    while (currentTime < endTime) {
      const slotStart = new Date(date);
      slotStart.setHours(currentTime.getHours(), currentTime.getMinutes(), 0, 0);

      const slotEnd = new Date(slotStart);
      slotEnd.setMinutes(slotEnd.getMinutes() + schedule.consultationDuration);

      slots.push({
        startTime: slotStart,
        endTime: slotEnd,
        duration: schedule.consultationDuration
      });

      currentTime.setTime(currentTime.getTime() + duration);
    }

    return slots;
  }

  async checkAvailability(doctorId, startTime, endTime) {
    const dayOfWeek = startTime.getDay();
    const timeString = startTime.toTimeString().slice(0, 5);

    const schedule = await this.prisma.schedule.findFirst({
      where: {
        doctorId,
        dayOfWeek,
        startTime: { lte: timeString },
        endTime: { gte: timeString },
        isAvailable: true
      }
    });

    if (!schedule) {
      return false;
    }

    // Verificar se há consultas conflitantes
    const conflictingConsultation = await this.prisma.consultation.findFirst({
      where: {
        doctorId,
        scheduledAt: {
          gte: startTime,
          lt: endTime
        },
        status: {
          in: ['SCHEDULED', 'IN_PROGRESS']
        }
      }
    });

    return !conflictingConsultation;
  }

  async getScheduleStats(doctorId) {
    const [
      totalSchedules,
      availableSchedules,
      totalHours,
      averageDuration
    ] = await Promise.all([
      this.prisma.schedule.count({ where: { doctorId } }),
      this.prisma.schedule.count({ where: { doctorId, isAvailable: true } }),
      this.prisma.schedule.aggregate({
        where: { doctorId },
        _sum: {
          consultationDuration: true
        }
      }),
      this.prisma.schedule.aggregate({
        where: { doctorId },
        _avg: {
          consultationDuration: true
        }
      })
    ]);

    return {
      totalSchedules,
      availableSchedules,
      totalHours: totalHours._sum.consultationDuration || 0,
      averageDuration: Math.round(averageDuration._avg.consultationDuration || 0),
      availabilityRate: totalSchedules > 0 ? (availableSchedules / totalSchedules) * 100 : 0
    };
  }

  async getWeeklySchedule(doctorId) {
    const schedules = await this.prisma.schedule.findMany({
      where: { doctorId },
      orderBy: { dayOfWeek: 'asc' },
      include: {
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: {
                specialty: true,
                crm: true
              }
            },
          }
        }
      }
    });

    // Organizar por dia da semana
    const weeklySchedule = {};
    for (let i = 0; i < 7; i++) {
      weeklySchedule[i] = schedules.find(s => s.dayOfWeek === i) || null;
    }

    return weeklySchedule;
  }

  async bulkUpdate(doctorId, schedules) {
    // Deletar horários existentes
    await this.prisma.schedule.deleteMany({
      where: { doctorId }
    });

    // Criar novos horários
    const createdSchedules = await Promise.all(
      schedules.map(schedule =>
        this.prisma.schedule.create({
          data: { ...schedule, doctorId },
          include: {
            doctor: {
              select: {
                id: true,
                name: true,
                email: true,
                doctorProfile: {
                  select: {
                    specialty: true,
                    crm: true
                  }
                },
              }
            }
          }
        })
      )
    );

    return createdSchedules;
  }

  async confirmSchedule(id) {
    const schedule = await this.prisma.schedule.update({
      where: { id },
      data: { isConfirmed: true },
      include: {
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: {
                specialty: true,
                crm: true
              }
            },
          }
        }
      }
    });

    return schedule;
  }
}

module.exports = ScheduleRepository;