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
        doctorPrescriptions: true,
        patientPrescriptions: true,
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

  // Buscar especialidades
  async getSpecialties() {
    // Caso queira buscar as especialidades de todos os médicos cadastrados
    //  const specialties = await this.prisma.user.findMany({
    //   where: {
    //     userType: 'DOCTOR',
    //     specialty: { not: null }
    //   },
    //   select: {
    //     specialty: true
    //   },
    //   distinct: ['specialty']
    // });

    // return specialties.map(s => s.specialty);

    // Lista completa de especialidades médicas reconhecidas pelo CFM
    return [
      'Acupuntura',
      'Alergologia',
      'Anestesiologia',
      'Angiologia',
      'Cardiologia',
      'Cirurgia Cardiovascular',
      'Cirurgia da Mão',
      'Cirurgia de Cabeça e Pescoço',
      'Cirurgia do Aparelho Digestivo',
      'Cirurgia Geral',
      'Cirurgia Pediátrica',
      'Cirurgia Plástica',
      'Cirurgia Torácica',
      'Cirurgia Vascular',
      'Clínica Médica',
      'Coloproctologia',
      'Dermatologia',
      'Endocrinologia e Metabologia',
      'Endoscopia',
      'Gastroenterologia',
      'Genética Médica',
      'Geriatria',
      'Ginecologia e Obstetrícia',
      'Hematologia e Hemoterapia',
      'Homeopatia',
      'Infectologia',
      'Mastologia',
      'Medicina de Família e Comunidade',
      'Medicina do Trabalho',
      'Medicina de Tráfego',
      'Medicina Esportiva',
      'Medicina Física e Reabilitação',
      'Medicina Intensiva',
      'Medicina Legal e Perícia Médica',
      'Medicina Nuclear',
      'Medicina Preventiva e Social',
      'Nefrologia',
      'Neurocirurgia',
      'Neurologia',
      'Nutrologia',
      'Oftalmologia',
      'Oncologia Clínica',
      'Ortopedia e Traumatologia',
      'Otorrinolaringologia',
      'Patologia',
      'Patologia Clínica/Medicina Laboratorial',
      'Pediatria',
      'Pneumologia',
      'Psiquiatria',
      'Radiologia e Diagnóstico por Imagem',
      'Radioterapia',
      'Reumatologia',
      'Urologia'
    ];
  }

  // Buscar médicos online
  async getOnlineDoctors() {
    return await this.prisma.user.findMany({
      where: {
        userType: 'DOCTOR',
        isActive: true,
        isVerified: true
      },
      include: {
        _count: {
          select: {
            patientConsultations: true,
            ratings: true
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

  // Buscar médicos favoritos
  async getFavoriteDoctors(userId) {
    return await this.prisma.user.findMany({
      where: {
        userType: 'DOCTOR',
        favorites: {
          some: {
            userId: userId
          }
        }
      },
      include: {
        _count: {
          select: {
            patientConsultations: true,
            ratings: true
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

  // Adicionar/remover médico dos favoritos
  async toggleFavorite(userId, doctorId) {
    // Verificar se já é favorito
    const existingFavorite = await this.prisma.favorite.findFirst({
      where: {
        userId: userId,
        doctorId: doctorId
      }
    });

    if (existingFavorite) {
      // Remover dos favoritos
      await this.prisma.favorite.delete({
        where: { id: existingFavorite.id }
      });
      return { isFavorite: false };
    } else {
      // Adicionar aos favoritos
      await this.prisma.favorite.create({
        data: {
          userId: userId,
          doctorId: doctorId
        }
      });
      return { isFavorite: true };
    }
  }

  // Buscar médicos disponíveis
  async getAvailableDoctors(specialty, date) {
    // Busca todos os médicos ativos e verificados
    const doctorWhere = {
      userType: 'DOCTOR',
      isVerified: true,
      isActive: true,
      doctorProfile: specialty ? { specialty } : undefined
    };

    // Se data for informada, busca todos os médicos sem conflito de horário em uma única consulta
    if (date) {
      // Busca todos os médicos com conflito no horário
      const conflictedDoctors = await this.prisma.consultation.findMany({
        where: {
          scheduledAt: {
            gte: new Date(date),
            lt: new Date(new Date(date).getTime() + 30 * 60 * 1000)
          },
          status: {
            in: ['SCHEDULED', 'IN_PROGRESS']
          }
        },
        select: {
          doctorId: true
        }
      });
      const conflictedIds = conflictedDoctors.map(c => c.doctorId);

      doctorWhere.id = { notIn: conflictedIds };
    }

    const doctors = await this.prisma.user.findMany({
      where: doctorWhere,
      include: {
        doctorProfile: {
          select: {
            specialty: true,
            crm: true,
            consultationFee: true,
            bio: true
          }
        },
        _count: {
          select: {
            patientConsultations: true,
            ratings: true
          }
        },
        receivedRatings: {
          select: {
            rating: true
          }
        }
      }
    });

    return doctors;
  }

  // Dashboard do médico
  async getDoctorDashboard(doctorId) {
    const [
      doctor,
      todayConsultations,
      totalPatients,
      averageRating,
      monthlyRevenue
    ] = await Promise.all([
      this.prisma.user.findUnique({
        where: { id: doctorId },
        include: {
          doctorProfile: {
            select: { specialty: true }
          }
        }
      }),
      this.prisma.consultation.count({
        where: {
          doctorId: doctorId,
          scheduledAt: {
            gte: new Date(new Date().setHours(0, 0, 0, 0)),
            lt: new Date(new Date().setHours(23, 59, 59, 999))
          }
        }
      }),
      this.prisma.consultation.groupBy({
        by: ['patientId'],
        where: { doctorId: doctorId },
        _count: { patientId: true }
      }).then(result => result.length),
      this.prisma.rating.aggregate({
        where: { doctorId: doctorId },
        _avg: { rating: true }
      }),
      this.prisma.consultation.findMany({
        where: {
          doctorId: doctorId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
          }
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      })
    ]);

    // Soma manual dos valores de consulta
    const monthlyRevenueValue = monthlyRevenue.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    return {
      specialty: doctor?.doctorProfile?.specialty || 'Não informado',
      todayConsultations: todayConsultations,
      totalPatients: totalPatients,
      averageRating: averageRating._avg?.rating || 0.0,
      monthlyRevenue: monthlyRevenueValue
    };
  }

  // Dashboard do paciente
  async getPatientDashboard(patientId) {
    try {
      console.log('🔍 getPatientDashboard - patientId:', patientId);

      const [
        totalConsultations,
        upcomingConsultations,
        completedConsultations,
        recentConsultations,
        favoriteDoctors,
        recentPrescriptions
      ] = await Promise.all([
        this.prisma.consultation.count({
          where: { patientId: patientId }
        }),
        this.prisma.consultation.count({
          where: {
            patientId: patientId,
            status: 'SCHEDULED',
            scheduledAt: { gte: new Date() }
          }
        }),
        this.prisma.consultation.findMany({
          where: {
            patientId: patientId,
            status: 'COMPLETED'
          },
          include: {
            doctor: {
              select: {
                doctorProfile: {
                  select: { consultationFee: true }
                }
              }
            }
          }
        }),
        this.prisma.consultation.findMany({
          where: { patientId: patientId },
          take: 5,
          orderBy: { scheduledAt: 'desc' },
          include: {
            doctor: {
              select: {
                name: true,
                doctorProfile: {
                  select: { specialty: true }
                }
              }
            }
          }
        }),
        this.prisma.favorite.findMany({
          where: { userId: patientId },
          include: {
            doctor: {
              select: {
                name: true,
                doctorProfile: {
                  select: { specialty: true }
                },
                receivedRatings: {
                  select: {
                    rating: true
                  }
                }
              }
            }
          }
        }),
        this.prisma.prescription.findMany({
          where: { patientId: patientId },
          take: 5,
          orderBy: { createdAt: 'desc' }
        })
      ]);

      // Soma manual dos valores de consulta
      const totalSpent = completedConsultations.reduce((acc, c) => {
        const fee = c.doctor?.doctorProfile?.consultationFee;
        return acc + (fee ? Number(fee) : 0);
      }, 0);

      const result = {
        totalConsultations: totalConsultations,
        upcomingConsultations: upcomingConsultations,
        totalSpent: totalSpent,
        recentConsultations: recentConsultations,
        favoriteDoctors: favoriteDoctors.map(f => ({
          ...f.doctor,
          averageRating: f.doctor.receivedRatings.length
            ? (f.doctor.receivedRatings.reduce((acc, r) => acc + r.rating, 0) / f.doctor.receivedRatings.length)
            : null
        })),
        recentPrescriptions: recentPrescriptions
      };

      console.log('🔍 getPatientDashboard - result:', result);
      return result;
    } catch (error) {
      console.error('❌ getPatientDashboard - error:', error);
      throw error;
    }
  }

  // Estatísticas do médico
  async getDoctorStats(doctorId) {
    const [
      totalConsultations,
      completedConsultations,
      averageRating,
      totalPatients,
      monthlyRevenue
    ] = await Promise.all([
      this.prisma.consultation.count({
        where: { doctorId: doctorId }
      }),
      this.prisma.consultation.count({
        where: {
          doctorId: doctorId,
          status: 'COMPLETED'
        }
      }),
      this.prisma.rating.aggregate({
        where: { doctorId: doctorId },
        _avg: { rating: true }
      }),
      this.prisma.consultation.groupBy({
        by: ['patientId'],
        where: { doctorId: doctorId },
        _count: { patientId: true }
      }).then(result => result.length),
      this.prisma.consultation.aggregate({
        where: {
          doctorId: doctorId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
          }
        },
        _sum: { consultationFee: true }
      })
    ]);

    return {
      totalConsultations: totalConsultations,
      completedConsultations: completedConsultations,
      averageRating: averageRating._avg?.rating || 0.0,
      totalPatients: totalPatients,
      monthlyRevenue: monthlyRevenue._sum?.consultationFee || 0.0
    };
  }

  // Pacientes recentes do médico
  async getRecentPatients(doctorId) {
    const patients = await this.prisma.consultation.findMany({
      where: { doctorId: doctorId },
      take: 10,
      orderBy: { scheduledAt: 'desc' },
      include: {
        patient: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        }
      },
      distinct: ['patientId']
    });

    return patients.map(c => c.patient);
  }

  // Receita do médico
  async getDoctorRevenue(doctorId) {
    const [
      monthlyRevenue,
      yearlyRevenue,
      totalRevenue,
      revenueByMonth
    ] = await Promise.all([
      this.prisma.consultation.findMany({
        where: {
          doctorId: doctorId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
          }
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      }),
      this.prisma.consultation.findMany({
        where: {
          doctorId: doctorId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), 0, 1)
          }
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      }),
      this.prisma.consultation.findMany({
        where: {
          doctorId: doctorId,
          status: 'COMPLETED'
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      }),
      this.prisma.consultation.findMany({
        where: {
          doctorId: doctorId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), 0, 1)
          }
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      })
    ]);

    // Soma manual dos valores de consulta
    const monthlyRevenueValue = monthlyRevenue.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    const yearlyRevenueValue = yearlyRevenue.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    const totalRevenueValue = totalRevenue.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    // Para revenueByMonth, pode ser necessário adaptar para somar por mês
    return {
      monthlyRevenue: monthlyRevenueValue,
      yearlyRevenue: yearlyRevenueValue,
      totalRevenue: totalRevenueValue,
      revenueByMonth: revenueByMonth // Adaptação futura se necessário
    };
  }

  // Médicos favoritos do paciente
  async getPatientFavoriteDoctors(patientId) {
    const favorites = await this.prisma.favorite.findMany({
      where: { userId: patientId },
      include: {
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: { specialty: true }
            },
            receivedRatings: {
              select: {
                rating: true
              }
            },
            isActive: true,
            isVerified: true
          }
        }
      }
    });

    return favorites.map(f => f.doctor);
  }

  // Histórico médico do paciente
  async getPatientMedicalHistory(patientId) {
    const [
      consultations,
      prescriptions,
      ratings,
      totalSpent
    ] = await Promise.all([
      this.prisma.consultation.findMany({
        where: { patientId: patientId },
        orderBy: { scheduledAt: 'desc' },
        include: {
          doctor: {
            select: {
              name: true,
              doctorProfile: {
                select: { specialty: true }
              }
            }
          }
        }
      }),
      this.prisma.prescription.findMany({
        where: { patientId: patientId },
        orderBy: { createdAt: 'desc' },
        include: {
          doctor: {
            select: {
              name: true,
              doctorProfile: {
                select: { specialty: true }
              }
            }
          }
        }
      }),
      this.prisma.rating.findMany({
        where: { patientId: patientId },
        orderBy: { createdAt: 'desc' }
      }),
      this.prisma.consultation.findMany({
        where: {
          patientId: patientId,
          status: 'COMPLETED'
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      })
    ]);

    // Soma manual dos valores de consulta
    const totalSpentValue = totalSpent.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    return {
      consultations: consultations,
      prescriptions: prescriptions,
      ratings: ratings,
      totalSpent: totalSpentValue
    };
  }

  // Gastos médicos do paciente
  async getPatientExpenses(patientId) {
    const [
      totalSpent,
      monthlySpent,
      yearlySpent,
      expensesByMonth
    ] = await Promise.all([
      this.prisma.consultation.findMany({
        where: {
          patientId: patientId,
          status: 'COMPLETED'
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      }),
      this.prisma.consultation.findMany({
        where: {
          patientId: patientId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
          }
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      }),
      this.prisma.consultation.findMany({
        where: {
          patientId: patientId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), 0, 1)
          }
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      }),
      this.prisma.consultation.findMany({
        where: {
          patientId: patientId,
          status: 'COMPLETED',
          scheduledAt: {
            gte: new Date(new Date().getFullYear(), 0, 1)
          }
        },
        include: {
          doctor: {
            select: {
              doctorProfile: {
                select: { consultationFee: true }
              }
            }
          }
        }
      })
    ]);

    // Soma manual dos valores de consulta
    const totalSpentValue = totalSpent.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    const monthlySpentValue = monthlySpent.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    const yearlySpentValue = yearlySpent.reduce((acc, c) => {
      const fee = c.doctor?.doctorProfile?.consultationFee;
      return acc + (fee ? Number(fee) : 0);
    }, 0);
    // Para expensesByMonth, pode ser necessário adaptar para somar por mês
    return {
      totalSpent: totalSpentValue,
      monthlySpent: monthlySpentValue,
      yearlySpent: yearlySpentValue,
      expensesByMonth: expensesByMonth // Adaptação futura se necessário
    };
  }
}

module.exports = UserRepository;