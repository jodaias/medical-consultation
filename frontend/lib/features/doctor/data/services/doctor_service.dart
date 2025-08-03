import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/doctor/data/models/doctor_model.dart';
import 'package:medical_consultation_app/features/doctor/data/models/specialty_model.dart';
import 'package:medical_consultation_app/features/doctor/data/models/rating_model.dart';

class DoctorService {
  final ApiService _apiService;

  DoctorService(this._apiService);

  // Buscar lista de médicos
  Future<List<DoctorModel>> getDoctors({
    String? specialty,
    String? search,
    double? minRating,
    double? maxPrice,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'userType': 'DOCTOR', // Filtrar apenas médicos
      };

      if (specialty != null) queryParams['specialty'] = specialty;
      if (search != null) queryParams['search'] = search;
      if (minRating != null) queryParams['minRating'] = minRating;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (sortBy != null) queryParams['orderBy'] = sortBy;

      final response =
          await _apiService.get('/users', queryParameters: queryParams);

      if (response.data['success'] == true) {
        final List<dynamic> doctorsData = response.data['data']['users'];
        return doctorsData.map((json) => DoctorModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao buscar médicos');
      }
    } catch (e) {
      throw Exception('Erro ao buscar médicos: $e');
    }
  }

  // Buscar médico por ID
  Future<DoctorModel> getDoctorById(String doctorId) async {
    try {
      final response = await _apiService.get('/users/$doctorId');

      if (response.data['success'] == true) {
        return DoctorModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao buscar médico');
      }
    } catch (e) {
      throw Exception('Erro ao buscar médico: $e');
    }
  }

  // Buscar especialidades
  Future<List<SpecialtyModel>> getSpecialties() async {
    try {
      final response = await _apiService.get('/users/specialties');

      if (response.data['success'] == true) {
        final List<dynamic> specialtiesData = response.data['data'];
        return specialtiesData
            .map((json) => SpecialtyModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar especialidades');
      }
    } catch (e) {
      throw Exception('Erro ao buscar especialidades: $e');
    }
  }

  // Buscar avaliações de um médico
  Future<List<RatingModel>> getDoctorRatings(
    String doctorId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      final response = await _apiService.get(
        'ratings/doctors/$doctorId',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> ratingsData = response.data['data']['ratings'];
        return ratingsData.map((json) => RatingModel.fromJson(json)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar avaliações');
      }
    } catch (e) {
      throw Exception('Erro ao buscar avaliações: $e');
    }
  }

  // Avaliar um médico
  Future<void> rateDoctor(
      String doctorId, double rating, String comment) async {
    try {
      final response = await _apiService.post('ratings', data: {
        'doctorId': doctorId,
        'rating': rating,
        'comment': comment,
      });

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Erro ao avaliar médico');
      }
    } catch (e) {
      throw Exception('Erro ao avaliar médico: $e');
    }
  }

  // Favoritar/desfavoritar médico
  Future<void> toggleFavorite(String doctorId) async {
    try {
      final response =
          await _apiService.post('/users/doctors/$doctorId/favorite');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Erro ao favoritar médico');
      }
    } catch (e) {
      throw Exception('Erro ao favoritar médico: $e');
    }
  }

  // Buscar médicos favoritos
  Future<List<DoctorModel>> getFavoriteDoctors() async {
    try {
      final response = await _apiService.get('/users/doctors/favorites');

      if (response.data['success'] == true) {
        final List<dynamic> doctorsData = response.data['data'];
        return doctorsData.map((json) => DoctorModel.fromJson(json)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar médicos favoritos');
      }
    } catch (e) {
      throw Exception('Erro ao buscar médicos favoritos: $e');
    }
  }

  // Buscar médicos online
  Future<List<DoctorModel>> getOnlineDoctors() async {
    try {
      final response = await _apiService.get('/users/doctors/online');

      if (response.data['success'] == true) {
        final List<dynamic> doctorsData = response.data['data'];
        return doctorsData.map((json) => DoctorModel.fromJson(json)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar médicos online');
      }
    } catch (e) {
      throw Exception('Erro ao buscar médicos online: $e');
    }
  }

  // Buscar estatísticas de médicos
  Future<Map<String, dynamic>> getDoctorStats(String doctorId) async {
    try {
      final response = await _apiService.get('/users/doctors/stats');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar estatísticas');
      }
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas: $e');
    }
  }
}
