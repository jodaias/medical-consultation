const { PrismaClient } = require('@prisma/client');
const { NotFoundException, ConflictException } = require('../exceptions/app-exception');

class RatingRepository {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async create(data) {
    try {
      return await this.prisma.rating.create({
        data: {
          consultationId: data.consultationId,
          patientId: data.patientId,
          doctorId: data.doctorId,
          rating: data.rating,
          comment: data.comment,
          ratingType: data.ratingType,
          isAnonymous: data.isAnonymous
        },
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        }
      });
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Rating already exists for this consultation');
      }
      if (error.code === 'P2003') {
        throw new ConflictException('Invalid consultation ID');
      }
      throw error;
    }
  }

  async findById(id) {
    try {
      const rating = await this.prisma.rating.findUnique({
        where: { id },
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        }
      });

      if (!rating) {
        throw new NotFoundException('Rating not found');
      }

      return rating;
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new Error('Error finding rating');
    }
  }

  async findAll(filters = {}) {
    try {
      const where = {};

      if (filters.doctorId) {
        where.doctorId = filters.doctorId;
      }

      if (filters.patientId) {
        where.patientId = filters.patientId;
      }

      if (filters.consultationId) {
        where.consultationId = filters.consultationId;
      }

      if (filters.ratingType) {
        where.ratingType = filters.ratingType;
      }

      if (filters.minRating) {
        where.rating = {
          gte: parseInt(filters.minRating)
        };
      }

      if (filters.maxRating) {
        where.rating = {
          ...where.rating,
          lte: parseInt(filters.maxRating)
        };
      }

      const page = filters.page || 1;
      const limit = filters.limit || 10;
      const skip = (page - 1) * limit;

      const [ratings, total] = await Promise.all([
        this.prisma.rating.findMany({
          where,
          include: {
            consultation: {
              include: {
                doctor: true,
                patient: true
              }
            },
            doctor: true,
            patient: true
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: limit
        }),
        this.prisma.rating.count({ where })
      ]);

      return {
        ratings,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      throw new Error('Error finding ratings');
    }
  }

  async update(id, data) {
    try {
      const rating = await this.prisma.rating.update({
        where: { id },
        data,
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        }
      });

      return rating;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Rating not found');
      }
      throw new Error('Error updating rating');
    }
  }

  async delete(id) {
    try {
      await this.prisma.rating.delete({
        where: { id }
      });
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Rating not found');
      }
      throw new Error('Error deleting rating');
    }
  }

  async exists(id) {
    try {
      const rating = await this.prisma.rating.findUnique({
        where: { id },
        select: { id: true }
      });
      return !!rating;
    } catch (error) {
      throw new Error('Error checking rating existence');
    }
  }

  async findByConsultation(consultationId) {
    try {
      return await this.prisma.rating.findMany({
        where: { consultationId },
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        },
        orderBy: { createdAt: 'desc' }
      });
    } catch (error) {
      throw new Error('Error finding ratings by consultation');
    }
  }

  async findByDoctor(doctorId, filters = {}) {
    try {
      const where = { doctorId };

      if (filters.ratingType) {
        where.ratingType = filters.ratingType;
      }

      if (filters.minRating) {
        where.rating = {
          gte: parseInt(filters.minRating)
        };
      }

      if (filters.maxRating) {
        where.rating = {
          ...where.rating,
          lte: parseInt(filters.maxRating)
        };
      }

      const page = filters.page || 1;
      const limit = filters.limit || 10;
      const skip = (page - 1) * limit;

      const [ratings, total] = await Promise.all([
        this.prisma.rating.findMany({
          where,
          include: {
            consultation: {
              include: {
                doctor: true,
                patient: true
              }
            },
            doctor: true,
            patient: true
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: limit
        }),
        this.prisma.rating.count({ where })
      ]);

      return {
        ratings,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      throw new Error('Error finding ratings by doctor');
    }
  }

  async findByPatient(patientId, filters = {}) {
    try {
      const where = { patientId };

      if (filters.ratingType) {
        where.ratingType = filters.ratingType;
      }

      if (filters.minRating) {
        where.rating = {
          gte: parseInt(filters.minRating)
        };
      }

      if (filters.maxRating) {
        where.rating = {
          ...where.rating,
          lte: parseInt(filters.maxRating)
        };
      }

      const page = filters.page || 1;
      const limit = filters.limit || 10;
      const skip = (page - 1) * limit;

      const [ratings, total] = await Promise.all([
        this.prisma.rating.findMany({
          where,
          include: {
            consultation: {
              include: {
                doctor: true,
                patient: true
              }
            },
            doctor: true,
            patient: true
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: limit
        }),
        this.prisma.rating.count({ where })
      ]);

      return {
        ratings,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      throw new Error('Error finding ratings by patient');
    }
  }

  async markAsHelpful(id) {
    try {
      const rating = await this.prisma.rating.update({
        where: { id },
        data: {
          helpfulCount: {
            increment: 1
          }
        },
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        }
      });

      return rating;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Rating not found');
      }
      throw new Error('Error marking rating as helpful');
    }
  }

  async getRatingStats(doctorId = null, patientId = null) {
    try {
      const where = {};

      if (doctorId) {
        where.doctorId = doctorId;
      }

      if (patientId) {
        where.patientId = patientId;
      }

      const [
        totalRatings,
        averageRating,
        ratingDistribution,
        ratingsThisMonth,
        ratingsLastMonth
      ] = await Promise.all([
        this.prisma.rating.count({ where }),
        this.prisma.rating.aggregate({
          where,
          _avg: { rating: true }
        }),
        this.prisma.rating.groupBy({
          by: ['rating'],
          where,
          _count: { rating: true }
        }),
        this.prisma.rating.count({
          where: {
            ...where,
            createdAt: {
              gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
            }
          }
        }),
        this.prisma.rating.count({
          where: {
            ...where,
            createdAt: {
              gte: new Date(new Date().getFullYear(), new Date().getMonth() - 1, 1),
              lt: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
            }
          }
        })
      ]);

      return {
        totalRatings,
        averageRating: averageRating._avg.rating || 0,
        ratingDistribution: ratingDistribution.reduce((acc, item) => {
          acc[item.rating] = item._count.rating;
          return acc;
        }, {}),
        ratingsThisMonth,
        ratingsLastMonth,
        growthRate: ratingsLastMonth > 0
          ? ((ratingsThisMonth - ratingsLastMonth) / ratingsLastMonth) * 100
          : 0
      };
    } catch (error) {
      throw new Error('Error getting rating statistics');
    }
  }
}

module.exports = RatingRepository;