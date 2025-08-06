import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/custom_dio/rest.dart';

@injectable
class RatingService {
  final Rest _rest;

  RatingService(this._rest);

  // Criar avaliação
  Future<RestResult<Map<String, dynamic>>> createRating({
    required String doctorId,
    required String consultationId,
    required int rating,
    String? comment,
    Map<String, int>? criteriaRatings,
  }) async {
    return await _rest.postModel<Map<String, dynamic>>(
      'ratings/create',
      {
        'doctorId': doctorId,
        'consultationId': consultationId,
        'rating': rating,
        'comment': comment,
        'criteriaRatings': criteriaRatings,
      },
      parse: (data) => data as Map<String, dynamic>,
    );
  }

  // Obter avaliações de um médico
  Future<RestResult<List<Map<String, dynamic>>>> getDoctorRatings({
    required String doctorId,
    int? limit,
    int? offset,
    String? sortBy,
    String? order,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (order != null) queryParams['order'] = order;

    return await _rest.getModel<List<Map<String, dynamic>>>(
      'ratings/doctors/$doctorId',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Obter estatísticas de avaliação do médico
  Future<RestResult<Map<String, dynamic>>> getDoctorRatingStats(
      String doctorId) async {
    return await _rest.getModel<Map<String, dynamic>>(
      'ratings/doctors/$doctorId/stats',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Marcar avaliação como útil
  Future<RestResult<void>> markRatingAsHelpful(String ratingId) async {
    return await _rest.postModel<void>(
      'ratings/$ratingId/helpful',
      null,
    );
  }

  // Reportar avaliação inadequada
  Future<RestResult<void>> reportRating({
    required String ratingId,
    required String reason,
    String? description,
  }) async {
    return await _rest.postModel<void>(
      'ratings/$ratingId/report',
      {
        'reason': reason,
        'description': description,
      },
    );
  }

  // Responder a uma avaliação (médico)
  Future<RestResult<void>> replyToRating({
    required String ratingId,
    required String reply,
  }) async {
    return await _rest.postModel<void>(
      'ratings/$ratingId/reply',
      {
        'reply': reply,
      },
    );
  }

  // Editar avaliação
  Future<RestResult<void>> updateRating({
    required String ratingId,
    int? rating,
    String? comment,
    Map<String, int>? criteriaRatings,
  }) async {
    final data = <String, dynamic>{};
    if (rating != null) data['rating'] = rating;
    if (comment != null) data['comment'] = comment;
    if (criteriaRatings != null) data['criteriaRatings'] = criteriaRatings;

    return await _rest.putModel<void>(
      'ratings/$ratingId',
      body: data,
    );
  }

  // Deletar avaliação
  Future<RestResult<void>> deleteRating(String ratingId) async {
    return await _rest.deleteModel<void>(
      'ratings/$ratingId',
      {},
    );
  }

  // Obter avaliações do usuário logado
  Future<RestResult<List<Map<String, dynamic>>>> getUserRatings({
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    return await _rest.getModel<List<Map<String, dynamic>>>(
      'ratings/user',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Verificar se usuário pode avaliar consulta
  Future<RestResult<Map<String, dynamic>>> canRateConsultation(
      String consultationId) async {
    return await _rest.getModel<Map<String, dynamic>>(
      'ratings/can-rate/$consultationId',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Obter critérios de avaliação
  Future<RestResult<List<Map<String, dynamic>>>> getRatingCriteria() async {
    return await _rest.getModel<List<Map<String, dynamic>>>(
      'ratings/criteria',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
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
