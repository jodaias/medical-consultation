import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/features/doctor/data/models/doctor_model.dart';
import 'package:medical_consultation_app/features/doctor/data/models/specialty_model.dart';
import 'package:medical_consultation_app/features/doctor/data/models/rating_model.dart';
import 'package:medical_consultation_app/features/doctor/data/services/doctor_service.dart';

part 'doctor_store.g.dart';

class DoctorStore = _DoctorStore with _$DoctorStore;

abstract class _DoctorStore with Store {
  final DoctorService _doctorService;

  _DoctorStore(this._doctorService);

  // Observables
  @observable
  ObservableList<DoctorModel> doctors = ObservableList<DoctorModel>();

  @observable
  ObservableList<SpecialtyModel> specialties = ObservableList<SpecialtyModel>();

  @observable
  ObservableList<DoctorModel> favoriteDoctors = ObservableList<DoctorModel>();

  @observable
  ObservableList<DoctorModel> onlineDoctors = ObservableList<DoctorModel>();

  @observable
  DoctorModel? selectedDoctor;

  @observable
  ObservableList<RatingModel> doctorRatings = ObservableList<RatingModel>();

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingRatings = false;

  @observable
  String? error;

  @observable
  String? searchQuery;

  @observable
  String? selectedSpecialty;

  @observable
  String sortBy = 'rating';

  @observable
  double? minRating;

  @observable
  double? maxPrice;

  @observable
  int currentPage = 1;

  @observable
  bool hasMorePages = true;

  // Computed
  @computed
  List<DoctorModel> get filteredDoctors {
    List<DoctorModel> filtered = doctors.toList();

    // Filtrar por busca
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filtered = filtered.where((doctor) =>
          doctor.name.toLowerCase().contains(searchQuery!.toLowerCase()) ||
          doctor.specialty.toLowerCase().contains(searchQuery!.toLowerCase())).toList();
    }

    // Filtrar por especialidade
    if (selectedSpecialty != null) {
      filtered = filtered.where((doctor) => doctor.specialty == selectedSpecialty).toList();
    }

    // Filtrar por rating mínimo
    if (minRating != null) {
      filtered = filtered.where((doctor) => doctor.rating >= minRating!).toList();
    }

    // Filtrar por preço máximo
    if (maxPrice != null) {
      filtered = filtered.where((doctor) => doctor.consultationPrice <= maxPrice!).toList();
    }

    // Ordenar
    switch (sortBy) {
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.consultationPrice.compareTo(b.consultationPrice));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.consultationPrice.compareTo(a.consultationPrice));
        break;
      case 'experience':
        filtered.sort((a, b) => b.yearsOfExperience.compareTo(a.yearsOfExperience));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return filtered;
  }

  @computed
  List<DoctorModel> get topRatedDoctors {
    return doctors.where((doctor) => doctor.rating >= 4.5).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  @computed
  List<DoctorModel> get verifiedDoctors {
    return doctors.where((doctor) => doctor.isVerified).toList();
  }

  @computed
  Map<String, int> get specialtyCounts {
    Map<String, int> counts = {};
    for (var doctor in doctors) {
      counts[doctor.specialty] = (counts[doctor.specialty] ?? 0) + 1;
    }
    return counts;
  }

  // Actions
  @action
  Future<void> loadDoctors({bool refresh = false}) async {
    try {
      isLoading = true;
      error = null;

      if (refresh) {
        currentPage = 1;
        hasMorePages = true;
        doctors.clear();
      }

      final newDoctors = await _doctorService.getDoctors(
        specialty: selectedSpecialty,
        search: searchQuery,
        minRating: minRating,
        maxPrice: maxPrice,
        sortBy: sortBy,
        page: currentPage,
        limit: 20,
      );

      if (refresh || currentPage == 1) {
        doctors.clear();
      }

      doctors.addAll(newDoctors);
      hasMorePages = newDoctors.length == 20;
      currentPage++;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadMoreDoctors() async {
    if (!isLoading && hasMorePages) {
      await loadDoctors();
    }
  }

  @action
  Future<void> loadSpecialties() async {
    try {
      final newSpecialties = await _doctorService.getSpecialties();
      specialties.clear();
      specialties.addAll(newSpecialties);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> loadFavoriteDoctors() async {
    try {
      final favorites = await _doctorService.getFavoriteDoctors();
      favoriteDoctors.clear();
      favoriteDoctors.addAll(favorites);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> loadOnlineDoctors() async {
    try {
      final online = await _doctorService.getOnlineDoctors();
      onlineDoctors.clear();
      onlineDoctors.addAll(online);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> loadDoctorDetails(String doctorId) async {
    try {
      selectedDoctor = await _doctorService.getDoctorById(doctorId);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> loadDoctorRatings(String doctorId) async {
    try {
      isLoadingRatings = true;
      final ratings = await _doctorService.getDoctorRatings(doctorId);
      doctorRatings.clear();
      doctorRatings.addAll(ratings);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingRatings = false;
    }
  }

  @action
  Future<void> rateDoctor(String doctorId, double rating, String comment) async {
    try {
      await _doctorService.rateDoctor(doctorId, rating, comment);
      // Recarregar avaliações
      await loadDoctorRatings(doctorId);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> toggleFavorite(String doctorId) async {
    try {
      await _doctorService.toggleFavorite(doctorId);
      // Recarregar favoritos
      await loadFavoriteDoctors();
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  void setSearchQuery(String? query) {
    searchQuery = query;
    loadDoctors(refresh: true);
  }

  @action
  void setSelectedSpecialty(String? specialty) {
    selectedSpecialty = specialty;
    loadDoctors(refresh: true);
  }

  @action
  void setSortBy(String sort) {
    sortBy = sort;
    loadDoctors(refresh: true);
  }

  @action
  void setMinRating(double? rating) {
    minRating = rating;
    loadDoctors(refresh: true);
  }

  @action
  void setMaxPrice(double? price) {
    maxPrice = price;
    loadDoctors(refresh: true);
  }

  @action
  void clearFilters() {
    searchQuery = null;
    selectedSpecialty = null;
    sortBy = 'rating';
    minRating = null;
    maxPrice = null;
    loadDoctors(refresh: true);
  }

  @action
  void clearError() {
    error = null;
  }
} 