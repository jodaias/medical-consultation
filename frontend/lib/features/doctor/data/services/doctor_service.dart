import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/features/doctor/data/models/doctor_model.dart';
import 'package:medical_consultation_app/features/doctor/data/models/specialty_model.dart';
import 'package:medical_consultation_app/features/doctor/data/models/rating_model.dart';

class DoctorService {
  final Rest rest;
  DoctorService(this.rest);

  // Buscar lista de médicos
  Future<RestResult<List<DoctorModel>>> getDoctors({
    String? specialty,
    String? search,
    double? minRating,
    double? maxPrice,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'userType': 'DOCTOR',
    };
    if (specialty != null) queryParams['specialty'] = specialty;
    if (search != null) queryParams['search'] = search;
    if (minRating != null) queryParams['minRating'] = minRating;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (sortBy != null) queryParams['orderBy'] = sortBy;
    return await rest.getModel<List<DoctorModel>>(
      '/users',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Buscar médico por ID
  Future<RestResult<DoctorModel>> getDoctorById(String doctorId) async {
    return await rest.getModel<DoctorModel>(
      '/users/$doctorId',
      (data) => DoctorModel.fromJson(data['data']),
    );
  }

  // Buscar especialidades
  Future<RestResult<List<SpecialtyModel>>> getSpecialties() async {
    return await rest.getModel<List<SpecialtyModel>>(
      '/users/specialties',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => SpecialtyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Buscar avaliações de um médico
  Future<RestResult<List<RatingModel>>> getDoctorRatings(
    String doctorId, {
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    return await rest.getModel<List<RatingModel>>(
      '/ratings/doctors/$doctorId',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Avaliar um médico
  Future<RestResult> rateDoctor(
      String doctorId, double rating, String comment) async {
    return await rest.postModel(
      '/ratings',
      {
        'doctorId': doctorId,
        'rating': rating,
        'comment': comment,
      },
    );
  }

  // Favoritar/desfavoritar médico
  Future<RestResult> toggleFavorite(String doctorId) async {
    return await rest.postModel(
      '/users/doctors/$doctorId/favorite',
      null,
    );
  }

  // Buscar médicos favoritos
  Future<RestResult<List<DoctorModel>>> getFavoriteDoctors() async {
    return await rest.getModel<List<DoctorModel>>(
      '/users/doctors/favorites',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Buscar médicos online
  Future<RestResult<List<DoctorModel>>> getOnlineDoctors() async {
    return await rest.getModel<List<DoctorModel>>(
      '/users/doctors/online',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Buscar estatísticas de médicos
  Future<RestResult<Map<String, dynamic>>> getDoctorStats(
      String doctorId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/doctors/stats',
      (data) => data['data'] as Map<String, dynamic>,
    );
  }
}
