const { PrismaClient } = require('@prisma/client');
const { NotFoundException, ConflictException } = require('../exceptions/app-exception');

/**
 * UserRepository - Implementa o padrão Repository
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class UserRepository {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async create(userData) {
    try {
      const user = await this.prisma.user.create({
        data: userData
      });
      return user;
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('User with this email already exists');
      }
      throw error;
    }
  }

  async findById(id) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: {
        doctorConsultations: {
          include: {
            patient: true
          }
        },
        patientConsultations: {
          include: {
            doctor: true
          }
        },
        schedules: true,
        prescriptions: true,
        ratings: true,
        receivedRatings: true
      }
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return user;
  }

  async findByEmail(email) {
    const user = await this.prisma.user.findUnique({
      where: { email: email.toLowerCase() }
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return user;
  }

  async findAll(filters = {}) {
    const {
      userType,
      specialty,
      search,
      page = 1,
      limit = 10,
      orderBy = 'createdAt',
      order = 'desc'
    } = filters;

    const skip = (page - 1) * limit;
    const where = {};

    if (userType) {
      where.userType = userType;
    }

    if (specialty) {
      where.specialty = specialty;
    }

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
        { specialty: { contains: search, mode: 'insensitive' } }
      ];
    }

    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [orderBy]: order },
        include: {
          _count: {
            select: {
              doctorConsultations: true,
              patientConsultations: true,
              sentMessages: true,
              receivedMessages: true,
              schedules: true,
              doctorPrescriptions: true,
              patientPrescriptions: true,
              ratings: true,
              receivedRatings: true
            }
          }
        }
      }),
      this.prisma.user.count({ where })
    ]);

    return {
      users,
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
      const user = await this.prisma.user.update({
        where: { id },
        data,
        include: {
          doctorConsultations: true,
          patientConsultations: true,
          schedules: true,
          doctorPrescriptions: true,
          patientPrescriptions: true,
          ratings: true,
          receivedRatings: true
        }
      });
      return user;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('User not found');
      }
      if (error.code === 'P2002') {
        throw new ConflictException('User with this email already exists');
      }
      throw error;
    }
  }

  async delete(id) {
    try {
      await this.prisma.user.delete({
        where: { id }
      });
      return true;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('User not found');
      }
      throw error;
    }
  }

  async exists(id) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: { id: true }
    });
    return !!user;
  }

  async findBySpecialty(specialty) {
    return await this.prisma.user.findMany({
      where: {
        userType: 'doctor',
        specialty: specialty
      },
      include: {
        _count: {
          select: {
            patientConsultations: true,
            doctorConsultations: true,
            sentMessages: true,
            receivedMessages: true,
            schedules: true,
            doctorPrescriptions: true,
            patientPrescriptions: true,
            ratings: true,
            receivedRatings: true
          }
        }
      }
    });
  }

  async getDoctorsWithStats() {
    return await this.prisma.user.findMany({
      where: {
        userType: 'doctor'
      },
      include: {
        _count: {
          select: {
            patientConsultations: true,
            doctorConsultations: true,
            sentMessages: true,
            receivedMessages: true,
            schedules: true,
            doctorPrescriptions: true,
            patientPrescriptions: true,
            ratings: true,
            receivedRatings: true
          }
        },
        receivedRatings: {
          select: {
            rating: true
          }
        }
      }
    });
  }

  async updatePassword(id, hashedPassword) {
    return await this.prisma.user.update({
      where: { id },
      data: {
        password: hashedPassword,
        passwordChangedAt: new Date()
      }
    });
  }

  async verifyUser(id) {
    return await this.prisma.user.update({
      where: { id },
      data: { isVerified: true }
    });
  }
}

module.exports = UserRepository;