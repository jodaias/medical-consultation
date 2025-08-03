import 'package:flutter/services.dart';

/// Formatter personalizado para moeda brasileira
/// Formato: R$ 1.234,56
/// Digitação: da direita para a esquerda (centavos → reais)
/// Cursor sempre no final para impedir edição no meio
class BrazilianCurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove tudo que não é número
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (text.isEmpty) {
      return newValue.copyWith(
        text: 'R\$ 0,00',
        selection:
            const TextSelection.collapsed(offset: 7), // Posição após "R$ 0,00"
      );
    }

    // Converte para centavos
    final cents = int.parse(text);
    final reais = cents ~/ 100;
    final centavos = cents % 100;

    // Formata com separadores brasileiros
    String formatted = 'R\$ ';

    if (reais > 0) {
      // Adiciona separadores de milhares
      final reaisStr = reais.toString();
      final groups = <String>[];

      for (int i = reaisStr.length; i > 0; i -= 3) {
        final start = i - 3 < 0 ? 0 : i - 3;
        groups.insert(0, reaisStr.substring(start, i));
      }

      formatted += groups.join('.');
    } else {
      formatted += '0';
    }

    formatted += ',${centavos.toString().padLeft(2, '0')}';

    // Sempre posiciona o cursor no final
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Converte o valor formatado para centavos (int)
  static int parseToCents(String formattedValue) {
    final cleanValue = formattedValue.replaceAll(RegExp(r'[^\d]'), '');
    return cleanValue.isEmpty ? 0 : int.parse(cleanValue);
  }

  /// Converte o valor formatado para reais (double)
  static double parseToReais(String formattedValue) {
    final cents = parseToCents(formattedValue);
    return cents / 100.0;
  }

  /// Formata um valor em centavos para o formato brasileiro
  static String formatFromCents(int cents) {
    final reais = cents ~/ 100;
    final centavos = cents % 100;

    String formatted = 'R\$ ';

    if (reais > 0) {
      final reaisStr = reais.toString();
      final groups = <String>[];

      for (int i = reaisStr.length; i > 0; i -= 3) {
        final start = i - 3 < 0 ? 0 : i - 3;
        groups.insert(0, reaisStr.substring(start, i));
      }

      formatted += groups.join('.');
    } else {
      formatted += '0';
    }

    formatted += ',${centavos.toString().padLeft(2, '0')}';

    return formatted;
  }

  /// Formata um valor em reais para o formato brasileiro
  static String formatFromReais(double reais) {
    final cents = (reais * 100).round();
    return formatFromCents(cents);
  }
}
