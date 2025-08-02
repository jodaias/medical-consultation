// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DoctorStore on _DoctorStore, Store {
  Computed<List<DoctorModel>>? _$filteredDoctorsComputed;

  @override
  List<DoctorModel> get filteredDoctors => (_$filteredDoctorsComputed ??=
          Computed<List<DoctorModel>>(() => super.filteredDoctors,
              name: '_DoctorStore.filteredDoctors'))
      .value;
  Computed<List<DoctorModel>>? _$topRatedDoctorsComputed;

  @override
  List<DoctorModel> get topRatedDoctors => (_$topRatedDoctorsComputed ??=
          Computed<List<DoctorModel>>(() => super.topRatedDoctors,
              name: '_DoctorStore.topRatedDoctors'))
      .value;
  Computed<List<DoctorModel>>? _$verifiedDoctorsComputed;

  @override
  List<DoctorModel> get verifiedDoctors => (_$verifiedDoctorsComputed ??=
          Computed<List<DoctorModel>>(() => super.verifiedDoctors,
              name: '_DoctorStore.verifiedDoctors'))
      .value;
  Computed<Map<String, int>>? _$specialtyCountsComputed;

  @override
  Map<String, int> get specialtyCounts => (_$specialtyCountsComputed ??=
          Computed<Map<String, int>>(() => super.specialtyCounts,
              name: '_DoctorStore.specialtyCounts'))
      .value;

  late final _$doctorsAtom =
      Atom(name: '_DoctorStore.doctors', context: context);

  @override
  ObservableList<DoctorModel> get doctors {
    _$doctorsAtom.reportRead();
    return super.doctors;
  }

  @override
  set doctors(ObservableList<DoctorModel> value) {
    _$doctorsAtom.reportWrite(value, super.doctors, () {
      super.doctors = value;
    });
  }

  late final _$specialtiesAtom =
      Atom(name: '_DoctorStore.specialties', context: context);

  @override
  ObservableList<SpecialtyModel> get specialties {
    _$specialtiesAtom.reportRead();
    return super.specialties;
  }

  @override
  set specialties(ObservableList<SpecialtyModel> value) {
    _$specialtiesAtom.reportWrite(value, super.specialties, () {
      super.specialties = value;
    });
  }

  late final _$favoriteDoctorsAtom =
      Atom(name: '_DoctorStore.favoriteDoctors', context: context);

  @override
  ObservableList<DoctorModel> get favoriteDoctors {
    _$favoriteDoctorsAtom.reportRead();
    return super.favoriteDoctors;
  }

  @override
  set favoriteDoctors(ObservableList<DoctorModel> value) {
    _$favoriteDoctorsAtom.reportWrite(value, super.favoriteDoctors, () {
      super.favoriteDoctors = value;
    });
  }

  late final _$onlineDoctorsAtom =
      Atom(name: '_DoctorStore.onlineDoctors', context: context);

  @override
  ObservableList<DoctorModel> get onlineDoctors {
    _$onlineDoctorsAtom.reportRead();
    return super.onlineDoctors;
  }

  @override
  set onlineDoctors(ObservableList<DoctorModel> value) {
    _$onlineDoctorsAtom.reportWrite(value, super.onlineDoctors, () {
      super.onlineDoctors = value;
    });
  }

  late final _$selectedDoctorAtom =
      Atom(name: '_DoctorStore.selectedDoctor', context: context);

  @override
  DoctorModel? get selectedDoctor {
    _$selectedDoctorAtom.reportRead();
    return super.selectedDoctor;
  }

  @override
  set selectedDoctor(DoctorModel? value) {
    _$selectedDoctorAtom.reportWrite(value, super.selectedDoctor, () {
      super.selectedDoctor = value;
    });
  }

  late final _$doctorRatingsAtom =
      Atom(name: '_DoctorStore.doctorRatings', context: context);

  @override
  ObservableList<RatingModel> get doctorRatings {
    _$doctorRatingsAtom.reportRead();
    return super.doctorRatings;
  }

  @override
  set doctorRatings(ObservableList<RatingModel> value) {
    _$doctorRatingsAtom.reportWrite(value, super.doctorRatings, () {
      super.doctorRatings = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_DoctorStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isLoadingRatingsAtom =
      Atom(name: '_DoctorStore.isLoadingRatings', context: context);

  @override
  bool get isLoadingRatings {
    _$isLoadingRatingsAtom.reportRead();
    return super.isLoadingRatings;
  }

  @override
  set isLoadingRatings(bool value) {
    _$isLoadingRatingsAtom.reportWrite(value, super.isLoadingRatings, () {
      super.isLoadingRatings = value;
    });
  }

  late final _$errorAtom = Atom(name: '_DoctorStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: '_DoctorStore.searchQuery', context: context);

  @override
  String? get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String? value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$selectedSpecialtyAtom =
      Atom(name: '_DoctorStore.selectedSpecialty', context: context);

  @override
  String? get selectedSpecialty {
    _$selectedSpecialtyAtom.reportRead();
    return super.selectedSpecialty;
  }

  @override
  set selectedSpecialty(String? value) {
    _$selectedSpecialtyAtom.reportWrite(value, super.selectedSpecialty, () {
      super.selectedSpecialty = value;
    });
  }

  late final _$sortByAtom = Atom(name: '_DoctorStore.sortBy', context: context);

  @override
  String get sortBy {
    _$sortByAtom.reportRead();
    return super.sortBy;
  }

  @override
  set sortBy(String value) {
    _$sortByAtom.reportWrite(value, super.sortBy, () {
      super.sortBy = value;
    });
  }

  late final _$minRatingAtom =
      Atom(name: '_DoctorStore.minRating', context: context);

  @override
  double? get minRating {
    _$minRatingAtom.reportRead();
    return super.minRating;
  }

  @override
  set minRating(double? value) {
    _$minRatingAtom.reportWrite(value, super.minRating, () {
      super.minRating = value;
    });
  }

  late final _$maxPriceAtom =
      Atom(name: '_DoctorStore.maxPrice', context: context);

  @override
  double? get maxPrice {
    _$maxPriceAtom.reportRead();
    return super.maxPrice;
  }

  @override
  set maxPrice(double? value) {
    _$maxPriceAtom.reportWrite(value, super.maxPrice, () {
      super.maxPrice = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_DoctorStore.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$hasMorePagesAtom =
      Atom(name: '_DoctorStore.hasMorePages', context: context);

  @override
  bool get hasMorePages {
    _$hasMorePagesAtom.reportRead();
    return super.hasMorePages;
  }

  @override
  set hasMorePages(bool value) {
    _$hasMorePagesAtom.reportWrite(value, super.hasMorePages, () {
      super.hasMorePages = value;
    });
  }

  late final _$loadDoctorsAsyncAction =
      AsyncAction('_DoctorStore.loadDoctors', context: context);

  @override
  Future<void> loadDoctors({bool refresh = false}) {
    return _$loadDoctorsAsyncAction
        .run(() => super.loadDoctors(refresh: refresh));
  }

  late final _$loadMoreDoctorsAsyncAction =
      AsyncAction('_DoctorStore.loadMoreDoctors', context: context);

  @override
  Future<void> loadMoreDoctors() {
    return _$loadMoreDoctorsAsyncAction.run(() => super.loadMoreDoctors());
  }

  late final _$loadSpecialtiesAsyncAction =
      AsyncAction('_DoctorStore.loadSpecialties', context: context);

  @override
  Future<void> loadSpecialties() {
    return _$loadSpecialtiesAsyncAction.run(() => super.loadSpecialties());
  }

  late final _$loadFavoriteDoctorsAsyncAction =
      AsyncAction('_DoctorStore.loadFavoriteDoctors', context: context);

  @override
  Future<void> loadFavoriteDoctors() {
    return _$loadFavoriteDoctorsAsyncAction
        .run(() => super.loadFavoriteDoctors());
  }

  late final _$loadOnlineDoctorsAsyncAction =
      AsyncAction('_DoctorStore.loadOnlineDoctors', context: context);

  @override
  Future<void> loadOnlineDoctors() {
    return _$loadOnlineDoctorsAsyncAction.run(() => super.loadOnlineDoctors());
  }

  late final _$loadDoctorDetailsAsyncAction =
      AsyncAction('_DoctorStore.loadDoctorDetails', context: context);

  @override
  Future<void> loadDoctorDetails(String doctorId) {
    return _$loadDoctorDetailsAsyncAction
        .run(() => super.loadDoctorDetails(doctorId));
  }

  late final _$loadDoctorRatingsAsyncAction =
      AsyncAction('_DoctorStore.loadDoctorRatings', context: context);

  @override
  Future<void> loadDoctorRatings(String doctorId) {
    return _$loadDoctorRatingsAsyncAction
        .run(() => super.loadDoctorRatings(doctorId));
  }

  late final _$rateDoctorAsyncAction =
      AsyncAction('_DoctorStore.rateDoctor', context: context);

  @override
  Future<void> rateDoctor(String doctorId, double rating, String comment) {
    return _$rateDoctorAsyncAction
        .run(() => super.rateDoctor(doctorId, rating, comment));
  }

  late final _$toggleFavoriteAsyncAction =
      AsyncAction('_DoctorStore.toggleFavorite', context: context);

  @override
  Future<void> toggleFavorite(String doctorId) {
    return _$toggleFavoriteAsyncAction
        .run(() => super.toggleFavorite(doctorId));
  }

  late final _$_DoctorStoreActionController =
      ActionController(name: '_DoctorStore', context: context);

  @override
  void setSearchQuery(String? query) {
    final _$actionInfo = _$_DoctorStoreActionController.startAction(
        name: '_DoctorStore.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_DoctorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedSpecialty(String? specialty) {
    final _$actionInfo = _$_DoctorStoreActionController.startAction(
        name: '_DoctorStore.setSelectedSpecialty');
    try {
      return super.setSelectedSpecialty(specialty);
    } finally {
      _$_DoctorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortBy(String sort) {
    final _$actionInfo = _$_DoctorStoreActionController.startAction(
        name: '_DoctorStore.setSortBy');
    try {
      return super.setSortBy(sort);
    } finally {
      _$_DoctorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMinRating(double? rating) {
    final _$actionInfo = _$_DoctorStoreActionController.startAction(
        name: '_DoctorStore.setMinRating');
    try {
      return super.setMinRating(rating);
    } finally {
      _$_DoctorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMaxPrice(double? price) {
    final _$actionInfo = _$_DoctorStoreActionController.startAction(
        name: '_DoctorStore.setMaxPrice');
    try {
      return super.setMaxPrice(price);
    } finally {
      _$_DoctorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_DoctorStoreActionController.startAction(
        name: '_DoctorStore.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_DoctorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_DoctorStoreActionController.startAction(
        name: '_DoctorStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_DoctorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
doctors: ${doctors},
specialties: ${specialties},
favoriteDoctors: ${favoriteDoctors},
onlineDoctors: ${onlineDoctors},
selectedDoctor: ${selectedDoctor},
doctorRatings: ${doctorRatings},
isLoading: ${isLoading},
isLoadingRatings: ${isLoadingRatings},
error: ${error},
searchQuery: ${searchQuery},
selectedSpecialty: ${selectedSpecialty},
sortBy: ${sortBy},
minRating: ${minRating},
maxPrice: ${maxPrice},
currentPage: ${currentPage},
hasMorePages: ${hasMorePages},
filteredDoctors: ${filteredDoctors},
topRatedDoctors: ${topRatedDoctors},
verifiedDoctors: ${verifiedDoctors},
specialtyCounts: ${specialtyCounts}
    ''';
  }
}
