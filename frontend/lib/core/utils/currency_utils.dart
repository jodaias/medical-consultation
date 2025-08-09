String normalizeCurrency(String input) {
  // Remove tudo que não seja dígito, vírgula ou ponto
  String clean = input.replaceAll(RegExp(r'[^0-9.,]'), '');

  // Se não tem vírgula, só ponto: ponto é decimal
  if (!clean.contains(',')) {
    // Remove possíveis pontos de milhares
    clean = clean.replaceAll('.', '');
    return clean;
  }

  // Se não tem ponto, só vírgula: vírgula é decimal
  if (!clean.contains('.')) {
    return clean.replaceAll(',', '.');
  }

  // Se tem vírgula e ponto, identificar qual é decimal:
  // Assume que o último separador é o decimal
  int lastComma = clean.lastIndexOf(',');
  int lastDot = clean.lastIndexOf('.');

  if (lastComma > lastDot) {
    // vírgula é decimal, ponto é milhar
    clean = clean.replaceAll('.', '');
    clean = clean.replaceAll(',', '.');
  } else {
    // ponto é decimal, vírgula é milhar
    clean = clean.replaceAll(',', '');
  }

  return clean;
}
