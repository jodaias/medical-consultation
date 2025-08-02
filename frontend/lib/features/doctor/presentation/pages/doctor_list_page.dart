import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_store.dart';
import 'package:medical_consultation_app/features/doctor/presentation/widgets/doctor_card.dart';
import 'package:medical_consultation_app/features/doctor/presentation/widgets/specialty_filter.dart';
import 'package:medical_consultation_app/features/doctor/presentation/widgets/search_bar.dart';
import 'package:medical_consultation_app/features/doctor/presentation/widgets/sort_filter.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  late final DoctorStore _doctorStore;

  @override
  void initState() {
    super.initState();
    _doctorStore = getIt<DoctorStore>();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _doctorStore.loadDoctors(refresh: true),
      _doctorStore.loadSpecialties(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encontrar Médicos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/doctors/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterModal(context),
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          if (_doctorStore.isLoading && _doctorStore.doctors.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_doctorStore.error != null && _doctorStore.doctors.isEmpty) {
            return _buildErrorWidget();
          }

          return RefreshIndicator(
            onRefresh: () => _doctorStore.loadDoctors(refresh: true),
            child: Column(
              children: [
                // Barra de busca
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: DoctorSearchBar(
                    onSearchChanged: _doctorStore.setSearchQuery,
                  ),
                ),

                // Filtros rápidos
                _buildQuickFilters(),

                // Lista de médicos
                Expanded(
                  child: _doctorStore.filteredDoctors.isEmpty
                      ? _buildEmptyState()
                      : _buildDoctorsList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Observer(
      builder: (context) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('Todos', null, _doctorStore.selectedSpecialty == null),
              ..._doctorStore.specialties.take(5).map((specialty) => 
                _buildFilterChip(
                  specialty.name,
                  specialty.id,
                  _doctorStore.selectedSpecialty == specialty.id,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String? value, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          _doctorStore.setSelectedSpecialty(selected ? value : null);
        },
        selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDoctorsList() {
    return Observer(
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: _doctorStore.filteredDoctors.length + 1,
          itemBuilder: (context, index) {
            if (index == _doctorStore.filteredDoctors.length) {
              // Último item - botão "carregar mais" ou loading
              if (_doctorStore.hasMorePages) {
                return _buildLoadMoreButton();
              }
              return const SizedBox.shrink();
            }

            final doctor = _doctorStore.filteredDoctors[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DoctorCard(
                doctor: doctor,
                onTap: () => context.push('/doctors/${doctor.id}'),
                onFavoriteToggle: () => _doctorStore.toggleFavorite(doctor.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadMoreButton() {
    return Observer(
      builder: (context) {
        if (_doctorStore.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => _doctorStore.loadMoreDoctors(),
            child: const Text('Carregar mais médicos'),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum médico encontrado',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tente ajustar os filtros ou termos de busca',
            style: TextStyle(color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _doctorStore.clearFilters(),
            child: const Text('Limpar filtros'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar médicos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _doctorStore.error ?? 'Erro desconhecido',
            style: TextStyle(color: AppTheme.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loadInitialData(),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filtro de especialidade
                      Text(
                        'Especialidade',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Observer(
                        builder: (context) => SpecialtyFilter(
                          specialties: _doctorStore.specialties,
                          selectedSpecialty: _doctorStore.selectedSpecialty,
                          onSpecialtyChanged: _doctorStore.setSelectedSpecialty,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Filtro de ordenação
                      Text(
                        'Ordenar por',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Observer(
                        builder: (context) => SortFilter(
                          currentSort: _doctorStore.sortBy,
                          onSortChanged: _doctorStore.setSortBy,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Filtro de rating mínimo
                      Text(
                        'Rating mínimo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Observer(
                        builder: (context) => _buildRatingFilter(),
                      ),
                      const SizedBox(height: 24),

                      // Filtro de preço máximo
                      Text(
                        'Preço máximo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Observer(
                        builder: (context) => _buildPriceFilter(),
                      ),
                      const SizedBox(height: 32),

                      // Botões de ação
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _doctorStore.clearFilters();
                                Navigator.pop(context);
                              },
                              child: const Text('Limpar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Aplicar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: _doctorStore.minRating ?? 0,
            min: 0,
            max: 5,
            divisions: 10,
            label: '${(_doctorStore.minRating ?? 0).toStringAsFixed(1)}',
            onChanged: (value) => _doctorStore.setMinRating(value),
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            '${(_doctorStore.minRating ?? 0).toStringAsFixed(1)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: _doctorStore.maxPrice ?? 500,
            min: 50,
            max: 500,
            divisions: 45,
            label: 'R\$ ${(_doctorStore.maxPrice ?? 500).toInt()}',
            onChanged: (value) => _doctorStore.setMaxPrice(value),
          ),
        ),
        SizedBox(
          width: 80,
          child: Text(
            'R\$ ${(_doctorStore.maxPrice ?? 500).toInt()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
} 