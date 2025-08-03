import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';

@injectable
class RatingService {
  final ApiService _apiService;
  final StorageService _storageService;

  RatingService(this._apiService, this._storageService);

  // Criar avaliação
  Future<Map<String, dynamic>?> createRating({
    required String doctorId,
    required String consultationId,
    required int rating,
    String? comment,
    Map<String, int>? criteriaRatings, // Avaliações por critério
  }) async {
    try {
      final response = await _apiService.post('ratings/create', data: {
        'doctorId': doctorId,
        'consultationId': consultationId,
        'rating': rating,
        'comment': comment,
        'criteriaRatings': criteriaRatings,
      });

      return response.data;
    } catch (e) {
      print('Erro ao criar avaliação: $e');
      return null;
    }
  }

  // Obter avaliações de um médico
  Future<List<Map<String, dynamic>>> getDoctorRatings({
    required String doctorId,
    int? limit,
    int? offset,
    String? sortBy, // rating, date, helpful
    String? order, // asc, desc
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (order != null) queryParams['order'] = order;

      final response = await _apiService.get('ratings/doctors/$doctorId',
          queryParameters: queryParams);
      return List<Map<String, dynamic>>.from(response.data['ratings']);
    } catch (e) {
      print('Erro ao obter avaliações do médico: $e');
      return [];
    }
  }

  // Obter estatísticas de avaliação do médico
  Future<Map<String, dynamic>?> getDoctorRatingStats(String doctorId) async {
    try {
      final response = await _apiService.get('ratings/doctors/$doctorId/stats');
      return response.data;
    } catch (e) {
      print('Erro ao obter estatísticas de avaliação: $e');
      return null;
    }
  }

  // Marcar avaliação como útil
  Future<bool> markRatingAsHelpful(String ratingId) async {
    try {
      await _apiService.post('ratings/$ratingId/helpful');
      return true;
    } catch (e) {
      print('Erro ao marcar avaliação como útil: $e');
      return false;
    }
  }

  // Reportar avaliação inadequada
  Future<bool> reportRating({
    required String ratingId,
    required String reason,
    String? description,
  }) async {
    try {
      await _apiService.post('ratings/$ratingId/report', data: {
        'reason': reason,
        'description': description,
      });
      return true;
    } catch (e) {
      print('Erro ao reportar avaliação: $e');
      return false;
    }
  }

  // Responder a uma avaliação (médico)
  Future<bool> replyToRating({
    required String ratingId,
    required String reply,
  }) async {
    try {
      await _apiService.post('ratings/$ratingId/reply', data: {
        'reply': reply,
      });
      return true;
    } catch (e) {
      print('Erro ao responder avaliação: $e');
      return false;
    }
  }

  // Editar avaliação
  Future<bool> updateRating({
    required String ratingId,
    int? rating,
    String? comment,
    Map<String, int>? criteriaRatings,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (rating != null) data['rating'] = rating;
      if (comment != null) data['comment'] = comment;
      if (criteriaRatings != null) data['criteriaRatings'] = criteriaRatings;

      await _apiService.put('ratings/$ratingId', data: data);
      return true;
    } catch (e) {
      print('Erro ao atualizar avaliação: $e');
      return false;
    }
  }

  // Deletar avaliação
  Future<bool> deleteRating(String ratingId) async {
    try {
      await _apiService.delete('ratings/$ratingId');
      return true;
    } catch (e) {
      print('Erro ao deletar avaliação: $e');
      return false;
    }
  }

  // Obter avaliações do usuário logado
  Future<List<Map<String, dynamic>>> getUserRatings({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response =
          await _apiService.get('ratings/user', queryParameters: queryParams);
      return List<Map<String, dynamic>>.from(response.data['ratings']);
    } catch (e) {
      print('Erro ao obter avaliações do usuário: $e');
      return [];
    }
  }

  // Verificar se usuário pode avaliar consulta
  Future<bool> canRateConsultation(String consultationId) async {
    try {
      final response =
          await _apiService.get('ratings/can-rate/$consultationId');
      return response.data['canRate'] ?? false;
    } catch (e) {
      print('Erro ao verificar se pode avaliar: $e');
      return false;
    }
  }

  // Obter critérios de avaliação
  Future<List<Map<String, dynamic>>> getRatingCriteria() async {
    try {
      final response = await _apiService.get('ratings/criteria');
      return List<Map<String, dynamic>>.from(response.data['criteria']);
    } catch (e) {
      print('Erro ao obter critérios de avaliação: $e');
      return [];
    }
  }

  // Calcular média de avaliações
  double calculateAverageRating(List<Map<String, dynamic>> ratings) {
    if (ratings.isEmpty) return 0.0;

    final totalRating =
        ratings.fold<int>(0, (sum, rating) => sum + (rating['rating'] as int));
    return totalRating / ratings.length;
  }

  // Calcular distribuição de avaliações
  Map<String, int> calculateRatingDistribution(
      List<Map<String, dynamic>> ratings) {
    final distribution = <String, int>{
      '5': 0,
      '4': 0,
      '3': 0,
      '2': 0,
      '1': 0,
    };

    for (final rating in ratings) {
      final ratingValue = rating['rating'] as int;
      if (ratingValue >= 1 && ratingValue <= 5) {
        distribution[ratingValue.toString()] =
            (distribution[ratingValue.toString()] ?? 0) + 1;
      }
    }

    return distribution;
  }

  // Formatar avaliação para exibição
  String formatRating(int rating) {
    switch (rating) {
      case 5:
        return 'Excelente';
      case 4:
        return 'Muito Bom';
      case 3:
        return 'Bom';
      case 2:
        return 'Regular';
      case 1:
        return 'Ruim';
      default:
        return 'Não avaliado';
    }
  }

  // Validar dados da avaliação
  bool validateRatingData({
    required int rating,
    String? comment,
    Map<String, int>? criteriaRatings,
  }) {
    // Validar rating principal
    if (rating < 1 || rating > 5) return false;

    // Validar comentário (opcional, mas se fornecido deve ter conteúdo)
    if (comment != null && comment.trim().isEmpty) return false;

    // Validar critérios de avaliação
    if (criteriaRatings != null) {
      for (final entry in criteriaRatings.entries) {
        final criteriaRating = entry.value;
        if (criteriaRating < 1 || criteriaRating > 5) return false;
      }
    }

    return true;
  }

  // Obter estrelas para exibição
  List<bool> getStars(int rating) {
    return List.generate(5, (index) => index < rating);
  }

  // Calcular percentual de avaliações positivas (4-5 estrelas)
  double calculatePositiveRatingPercentage(List<Map<String, dynamic>> ratings) {
    if (ratings.isEmpty) return 0.0;

    final positiveRatings =
        ratings.where((rating) => rating['rating'] >= 4).length;
    return (positiveRatings / ratings.length) * 100;
  }
}
