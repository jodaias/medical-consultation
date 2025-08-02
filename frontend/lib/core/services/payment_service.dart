import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';

@injectable
class PaymentService {
  final ApiService _apiService;
  final StorageService _storageService;

  PaymentService(this._apiService, this._storageService);

  // Criar pagamento para consulta
  Future<Map<String, dynamic>?> createPayment({
    required String consultationId,
    required double amount,
    required String doctorId,
    required String patientId,
    String? description,
  }) async {
    try {
      final response = await _apiService.post('/payments/create', data: {
        'consultationId': consultationId,
        'amount': amount,
        'doctorId': doctorId,
        'patientId': patientId,
        'description': description ?? 'Consulta médica',
        'currency': 'BRL',
      });

      return response.data;
    } catch (e) {
      print('Erro ao criar pagamento: $e');
      return null;
    }
  }

  // Processar pagamento com cartão
  Future<Map<String, dynamic>?> processCardPayment({
    required String paymentId,
    required String cardToken,
    required int installments,
  }) async {
    try {
      final response = await _apiService.post('/payments/process-card', data: {
        'paymentId': paymentId,
        'cardToken': cardToken,
        'installments': installments,
      });

      return response.data;
    } catch (e) {
      print('Erro ao processar pagamento: $e');
      return null;
    }
  }

  // Processar pagamento com PIX
  Future<Map<String, dynamic>?> processPixPayment({
    required String paymentId,
  }) async {
    try {
      final response = await _apiService.post('/payments/process-pix', data: {
        'paymentId': paymentId,
      });

      return response.data;
    } catch (e) {
      print('Erro ao processar PIX: $e');
      return null;
    }
  }

  // Verificar status do pagamento
  Future<Map<String, dynamic>?> getPaymentStatus(String paymentId) async {
    try {
      final response = await _apiService.get('/payments/$paymentId/status');
      return response.data;
    } catch (e) {
      print('Erro ao verificar status do pagamento: $e');
      return null;
    }
  }

  // Listar pagamentos do usuário
  Future<List<Map<String, dynamic>>> getUserPayments({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response =
          await _apiService.get('/payments/user', queryParameters: queryParams);
      return List<Map<String, dynamic>>.from(response.data['payments']);
    } catch (e) {
      print('Erro ao listar pagamentos: $e');
      return [];
    }
  }

  // Cancelar pagamento
  Future<bool> cancelPayment(String paymentId, {String? reason}) async {
    try {
      await _apiService.post('/payments/$paymentId/cancel', data: {
        'reason': reason ?? 'Cancelado pelo usuário',
      });
      return true;
    } catch (e) {
      print('Erro ao cancelar pagamento: $e');
      return false;
    }
  }

  // Solicitar reembolso
  Future<Map<String, dynamic>?> requestRefund({
    required String paymentId,
    required String reason,
    double? amount,
  }) async {
    try {
      final response =
          await _apiService.post('/payments/$paymentId/refund', data: {
        'reason': reason,
        'amount': amount,
      });

      return response.data;
    } catch (e) {
      print('Erro ao solicitar reembolso: $e');
      return null;
    }
  }

  // Gerar relatório de pagamentos
  Future<Map<String, dynamic>?> generatePaymentReport({
    required DateTime startDate,
    required DateTime endDate,
    String? status,
  }) async {
    try {
      final response = await _apiService.post('/payments/report', data: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': status,
      });

      return response.data;
    } catch (e) {
      print('Erro ao gerar relatório: $e');
      return null;
    }
  }

  // Validar dados do cartão
  bool validateCardData({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardholderName,
  }) {
    // Validação básica do número do cartão (Luhn algorithm)
    if (!_isValidCardNumber(cardNumber)) return false;

    // Validar mês de expiração
    final month = int.tryParse(expiryMonth);
    if (month == null || month < 1 || month > 12) return false;

    // Validar ano de expiração
    final year = int.tryParse(expiryYear);
    if (year == null || year < DateTime.now().year) return false;

    // Validar CVV
    if (cvv.length < 3 || cvv.length > 4) return false;

    // Validar nome do titular
    if (cardholderName.trim().isEmpty) return false;

    return true;
  }

  // Algoritmo de Luhn para validar número do cartão
  bool _isValidCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cleanNumber.length < 13 || cleanNumber.length > 19) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cleanNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    return (sum % 10) == 0;
  }

  // Formatar valor monetário
  String formatCurrency(double amount) {
    return 'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Calcular valor com desconto
  double calculateDiscount(double originalAmount, double discountPercentage) {
    return originalAmount - (originalAmount * discountPercentage / 100);
  }

  // Calcular valor com taxa
  double calculateWithTax(double amount, double taxPercentage) {
    return amount + (amount * taxPercentage / 100);
  }
}
