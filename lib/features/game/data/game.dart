import 'package:mobile_app/features/game/data/game_data_model.dart';
import 'dart:math';

double _monthlyRate(double annualRate) {
  return pow(1 + annualRate / 100, 1 / 12) - 1;
}

/// Calcula cuota mensual con el método francés
double _monthlyPayment(double principal, double monthlyRate, int months) {
  final factor = pow(1 + monthlyRate, months);
  return principal * monthlyRate * factor / (factor - 1);
}

/// Capital restante después de 'monthsPaid' cuotas
double _remainingPrincipal(
  double principal,
  double monthlyRate,
  double payment,
  int monthsPaid,
) {
  final factor = pow(1 + monthlyRate, monthsPaid);
  return principal * factor - payment * (factor - 1) / monthlyRate;
}

/// Cálculo principal del préstamo
LoanResult calculateLoan({
  required double principal,
  required int termMonths,
  required double originalBaseRate,
  required double newBaseRate,
  required double spread,
  required bool isVariable,
  required bool normalEventOccurred,
  required bool hiddenEventOccurred,
  required String message,
}) {
  final annualInitial = originalBaseRate + spread;
  final monthlyInitial = _monthlyRate(annualInitial);
  final initialPayment = _monthlyPayment(principal, monthlyInitial, termMonths);

  // Si es tasa fija, o variable pero NO ocurrió ningún evento → se calcula como cuota fija
  final noEvents = !normalEventOccurred && !hiddenEventOccurred;

  if (!isVariable || noEvents) {
    final total = initialPayment * termMonths;
    return LoanResult(
      totalPaid: total,
      totalInterest: total - principal,
      message: message,
    );
  }

  // Caso: tasa variable y sí ocurrió evento → cálculo en dos tramos
  final firstSegment = min(12, termMonths);
  final remainingMonths = termMonths - firstSegment;

  final paidFirst = initialPayment * firstSegment;
  final remainingCapital = _remainingPrincipal(
    principal,
    monthlyInitial,
    initialPayment,
    firstSegment,
  );

  final annualNew = newBaseRate + spread;
  final monthlyNew = _monthlyRate(annualNew);
  final newPayment = _monthlyPayment(
    remainingCapital,
    monthlyNew,
    remainingMonths,
  );
  final paidSecond = newPayment * remainingMonths;

  final totalPaid = paidFirst + paidSecond;

  return LoanResult(
    totalPaid: totalPaid,
    totalInterest: totalPaid - principal,
    message: message,
  );
}

void main() {
  // Datos simulados desde el backend
  final principal = 45000.0;
  final termMonths = 48;
  final originalBaseRate = 6.25;
  final newBaseRate = 9.75; // cambiar para probar escenarios
  final spread = 6.5;
  final isVariable = true;

  // Simular eventos ocurridos o no
  final normalEventOccurred = false;
  final hiddenEventOccurred = true;

  final message = normalEventOccurred
      ? "El evento anunciado: El BCRP informó un cambio. Se cumplió"
      : hiddenEventOccurred
      ? "Crisis global imprevista afectó las tasas"
      : "No hubo cambios importantes, se mantiene la tasa";

  final result = calculateLoan(
    principal: principal,
    termMonths: termMonths,
    originalBaseRate: originalBaseRate,
    newBaseRate: newBaseRate,
    spread: spread,
    isVariable: isVariable,
    normalEventOccurred: normalEventOccurred,
    hiddenEventOccurred: hiddenEventOccurred,
    message: message,
  );

  print("📝 Mensaje: ${result.message}");
  print("💰 Total pagado: S/ ${result.totalPaid.toStringAsFixed(2)}");
  print("📈 Intereses: S/ ${result.totalInterest.toStringAsFixed(2)}");
}
