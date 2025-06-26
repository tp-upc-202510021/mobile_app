import 'dart:math' as math;

/* ==== MODELOS BÁSICOS ==== */

enum RiskLevel { low, medium, high }

enum Frequency { annual, semiAnnual, quarterly, monthly }

extension FrequencyX on Frequency {
  int get periodsPerYear => switch (this) {
    Frequency.annual => 1,
    Frequency.semiAnnual => 2,
    Frequency.quarterly => 4,
    Frequency.monthly => 12,
  };
}

class InvestmentOption {
  final String title;
  final String description;
  final double expectedReturnPct; // Ej.: 8  ⇒ 8 %
  final double volatilityPct; // No se usa aquí, pero se mantiene.
  final RiskLevel riskLevel;
  final Frequency frequency;
  final String currency; // "PEN" | "USD"

  InvestmentOption({
    required this.title,
    required this.description,
    required this.expectedReturnPct,
    required this.volatilityPct,
    required this.riskLevel,
    required this.frequency,
    required this.currency,
  });
}

class FxRate {
  final double buy; // PEN que reciben al vender USD
  final double sell; // PEN que pagan al comprar USD
  const FxRate({required this.buy, required this.sell});
}

class InvestmentOutcome {
  final String currency; // "PEN" o "USD"
  final double finalAmount; // Capital total al cierre
  final double gain; // Ganancia (puede ser negativa)

  const InvestmentOutcome({
    required this.currency,
    required this.finalAmount,
    required this.gain,
  });
}

/* ==== FUNCIÓN PRINCIPAL ==== */

/// Calcula el capital final y la ganancia para una opción seleccionada.
///
/// [initialPen]  – capital de partida en soles.
/// [option]      – opción elegida (puede estar en PEN o USD).
/// [fx]          – tipo de cambio de la ronda (buy / sell).
/// [durationM]   – duración de la inversión en meses.
///
/// La función:
/// 1. Convierte PEN→USD si la opción está en dólares (usa fx.sell).
/// 2. Aplica interés compuesto según frecuencia y duración.
/// 3. Devuelve el resultado en la *misma moneda* de la opción.
InvestmentOutcome computeOutcome({
  required double initialPen,
  required InvestmentOption option,
  required FxRate fx,
  required int durationM,
}) {
  final years = durationM / 12.0;

  // 1️⃣ Capital inicial en la moneda de la opción
  late double capitalStart;
  if (option.currency == 'USD') {
    capitalStart = initialPen / fx.sell; // compras USD
  } else {
    capitalStart = initialPen;
  }

  // 2️⃣ Interés compuesto
  final periods = option.frequency.periodsPerYear;
  final rateAnnual = option.expectedReturnPct / 100; // fracción
  final ratePerPeriod = math.pow(1 + rateAnnual, 1 / periods) - 1;
  final totalPeriods = (periods * years).round();

  double capital = capitalStart;
  for (var i = 0; i < totalPeriods; i++) {
    capital *= (1 + ratePerPeriod);
  }

  // 3️⃣ Resultado
  final gain = capital - capitalStart;

  return InvestmentOutcome(
    currency: option.currency,
    finalAmount: double.parse(capital.toStringAsFixed(2)),
    gain: double.parse(gain.toStringAsFixed(2)),
  );
}

/* ==== EJEMPLO DE USO ==== */
void main() {
  // Datos resumidos de tu JSON
  final fxRound1 = FxRate(buy: 3.82, sell: 3.79);
  final optionUsd = InvestmentOption(
    title: 'Acciones de Credicorp (BAP)',
    description: 'Holding financiero peruano',
    expectedReturnPct: 15,
    volatilityPct: 35,
    riskLevel: RiskLevel.high,
    frequency: Frequency.semiAnnual, // 6 m
    currency: 'USD',
  );

  final optionPen = InvestmentOption(
    title: 'Depósito a Plazo Fijo - Caja Rural',
    description: 'Protegido por el FSD',
    expectedReturnPct: 7.5,
    volatilityPct: 2,
    riskLevel: RiskLevel.low,
    frequency: Frequency.annual,
    currency: 'PEN',
  );

  // Capital inicial del JSON
  const capitalPen = 15000.0;

  // Duración de la ronda 1: 12 meses
  final outcomeUsd = computeOutcome(
    initialPen: capitalPen,
    option: optionUsd,
    fx: fxRound1,
    durationM: 12,
  );

  final outcomePen = computeOutcome(
    initialPen: capitalPen,
    option: optionPen,
    fx: fxRound1,
    durationM: 12,
  );

  print(
    'USD Outcome: currency=${outcomeUsd.currency}, finalAmount=${outcomeUsd.finalAmount}, gain=${outcomeUsd.gain}',
  );
  print(
    'PEN Outcome: currency=${outcomePen.currency}, finalAmount=${outcomePen.finalAmount}, gain=${outcomePen.gain}',
  );
}
