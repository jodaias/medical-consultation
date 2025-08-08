import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_store.dart';
import 'package:medical_consultation_app/features/doctor/presentation/widgets/rating_widget.dart';
import 'package:medical_consultation_app/features/doctor/presentation/widgets/availability_widget.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
import 'package:share_plus/share_plus.dart';

class DoctorDetailPage extends StatefulWidget {
  final String doctorId;

  const DoctorDetailPage({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage>
    with SingleTickerProviderStateMixin {
  late final DoctorStore _doctorStore;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _doctorStore = getIt<DoctorStore>();
    _tabController = TabController(length: 3, vsync: this);
    _loadDoctorData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctorData() async {
    await Future.wait([
      _doctorStore.loadDoctorDetails(widget.doctorId),
      _doctorStore.loadDoctorRatings(widget.doctorId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          if (_doctorStore.selectedDoctor == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final doctor = _doctorStore.selectedDoctor!;

          return CustomScrollView(
            slivers: [
              // App Bar com imagem de fundo
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagem de fundo
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                      // Informações do médico
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: doctor.avatar != null
                                  ? NetworkImage(doctor.avatar!)
                                  : null,
                              child: doctor.avatar == null
                                  ? Text(
                                      doctor.name!
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Dr. ${doctor.name}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (doctor.isVerified)
                                        Icon(
                                          Icons.verified,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doctor.specialty,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${doctor.rating.toStringAsFixed(1)} (${doctor.totalReviews} avaliações)',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () => _doctorStore.toggleFavorite(doctor.id),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final doctor = _doctorStore.selectedDoctor;
                      if (doctor != null) {
                        final shareText =
                            'Confira o perfil do Dr. ${doctor.name} (${doctor.specialty}) na Medical Consultation Online!\n${doctor.bio != null ? '\n${doctor.bio}' : ''}\nAcesse o app para agendar uma consulta.';
                        try {
                          Share.share(shareText);
                        } catch (e) {
                          ToastUtils.showErrorToast('Erro ao compartilhar: $e');
                        }
                      }
                    },
                  ),
                ],
              ),

              // Conteúdo principal
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Informações rápidas
                    _buildQuickInfo(doctor),

                    // Tabs
                    Container(
                      margin: const EdgeInsets.all(AppConstants.defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            labelColor: AppTheme.primaryColor,
                            unselectedLabelColor: AppTheme.textSecondaryColor,
                            indicatorColor: AppTheme.primaryColor,
                            tabs: const [
                              Tab(text: 'Sobre'),
                              Tab(text: 'Avaliações'),
                              Tab(text: 'Disponibilidade'),
                            ],
                          ),
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildAboutTab(doctor),
                                _buildRatingsTab(),
                                _buildAvailabilityTab(doctor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botão de agendar consulta
                    Padding(
                      padding:
                          const EdgeInsets.all(AppConstants.defaultPadding),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              context.push('/schedule/${doctor.id}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius),
                            ),
                          ),
                          child: const Text(
                            'Agendar Consulta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickInfo(doctor) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              icon: Icons.work,
              title: 'Experiência',
              value: '${doctor.yearsOfExperience} anos',
            ),
          ),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.people,
              title: 'Consultas',
              value: '${doctor.totalConsultations}',
            ),
          ),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.attach_money,
              title: 'Preço',
              value: 'R\$ ${doctor.consultationPrice.toStringAsFixed(0)}',
            ),
          ),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.circle,
              title: 'Status',
              value: doctor.isOnline ? 'Online' : 'Offline',
              valueColor:
                  doctor.isOnline ? AppTheme.successColor : AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab(doctor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (doctor.bio != null) ...[
            const Text(
              'Biografia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.bio!,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
          ],
          if (doctor.certifications.isNotEmpty) ...[
            const Text(
              'Certificações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...doctor.certifications.map((cert) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: AppTheme.infoColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(cert)),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
          ],
          if (doctor.languages.isNotEmpty) ...[
            const Text(
              'Idiomas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: doctor.languages
                  .map((lang) => Chip(
                        label: Text(lang),
                        backgroundColor:
                            AppTheme.primaryColor.withValues(alpha: 0.1),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
          if (doctor.address != null) ...[
            const Text(
              'Endereço',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.textSecondaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(doctor.address!)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingsTab() {
    return Observer(
      builder: (context) {
        if (_doctorStore.ratingsStatus == RequestStatusEnum.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_doctorStore.doctorRatings.isEmpty) {
          return const Center(
            child: Text('Nenhuma avaliação ainda'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: _doctorStore.doctorRatings.length,
          itemBuilder: (context, index) {
            final rating = _doctorStore.doctorRatings[index];
            return RatingWidget(rating: rating);
          },
        );
      },
    );
  }

  Widget _buildAvailabilityTab(doctor) {
    return AvailabilityWidget(availability: doctor.availability);
  }
}
