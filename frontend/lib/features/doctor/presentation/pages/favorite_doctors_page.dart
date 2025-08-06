import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/doctor/data/models/doctor_model.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_store.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class FavoriteDoctorsPage extends StatefulWidget {
  const FavoriteDoctorsPage({super.key});

  @override
  State<FavoriteDoctorsPage> createState() => _FavoriteDoctorsPageState();
}

class _FavoriteDoctorsPageState extends State<FavoriteDoctorsPage> {
  final doctorStore = getIt<DoctorStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Médicos Favoritos'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) {
          final favorites = doctorStore.favoriteDoctors;

          if (doctorStore.requestStatus == RequestStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum médico favorito encontrado.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doctor = favorites[index];
              return _DoctorCard(doctor: doctor);
            },
          );
        },
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctorStore = getIt<DoctorStore>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.go('/doctors/${doctor.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: doctor.avatar != null
                    ? NetworkImage(doctor.avatar!)
                    : const AssetImage(AppConstants.defaultDoctor)
                        as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialty,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor.rating.toStringAsFixed(1)} • ${doctor.yearsOfExperience} anos',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  doctorStore.toggleFavorite(doctor.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
