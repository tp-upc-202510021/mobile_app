import 'package:mobile_app/features/game/data/investment/apply_exchange_investment_model.dart';

class GameInvestmentData {
  final double initialCapitalPen;
  final FxRate baseFxRate;
  final List<InvestmentRound> rounds;

  GameInvestmentData({
    required this.initialCapitalPen,
    required this.baseFxRate,
    required this.rounds,
  });

  factory GameInvestmentData.fromJson(Map<String, dynamic> json) {
    return GameInvestmentData(
      initialCapitalPen: (json['initial_capital_pen'] as num).toDouble(),
      baseFxRate: FxRate.fromJson(json['base_fx_rate']),
      rounds: (json['rounds'] as List<dynamic>)
          .map((e) => InvestmentRound.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class InvestmentRound {
  final int round;
  final int investmentDurationMonths;
  final List<InvestmentOption> options;
  final FxEvent fxEvent;

  InvestmentRound({
    required this.round,
    required this.investmentDurationMonths,
    required this.options,
    required this.fxEvent,
  });

  factory InvestmentRound.fromJson(Map<String, dynamic> json) {
    return InvestmentRound(
      round: json['round'],
      investmentDurationMonths: json['investment_duration_months'],
      options: (json['options'] as List<dynamic>)
          .map((e) => InvestmentOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      fxEvent: FxEvent.fromJson(json['fx_event']),
    );
  }
}

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

RiskLevel riskLevelFromString(String value) {
  switch (value.toLowerCase().trim()) {
    case 'low':
      return RiskLevel.low;
    case 'medium':
      return RiskLevel.medium;
    case 'high':
      return RiskLevel.high;
    default:
      throw Exception('❌ Invalid risk level: "$value"');
  }
}

Frequency frequencyFromString(String value) {
  final normalized = value.toLowerCase().replaceAll('_', '');
  switch (normalized) {
    case 'annual':
      return Frequency.annual;
    case 'semiannual':
      return Frequency.semiAnnual;
    case 'quarterly':
      return Frequency.quarterly;
    case 'monthly':
      return Frequency.monthly;
    default:
      throw Exception('❌ Invalid frequency: "$value"');
  }
}

class InvestmentOption {
  final String title;
  final String description;
  final double expectedReturnPct;
  final double volatilityPct;
  final RiskLevel riskLevel;
  final Frequency frequency;
  final String currency;

  InvestmentOption({
    required this.title,
    required this.description,
    required this.expectedReturnPct,
    required this.volatilityPct,
    required this.riskLevel,
    required this.frequency,
    required this.currency,
  });

  factory InvestmentOption.fromJson(Map<String, dynamic> json) {
    return InvestmentOption(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      expectedReturnPct: (json['expected_return_pct'] as num).toDouble(),
      volatilityPct: (json['volatility_pct'] as num).toDouble(),
      riskLevel: riskLevelFromString(json['risk_level']),
      frequency: frequencyFromString(json['frequency']),
      currency: json['currency'] ?? 'PEN',
    );
  }
}

class FxEvent {
  final int probabilityToChange;
  final String typeOfChange;
  final double percentageOfVariation;
  final String eventDescription;

  FxEvent({
    required this.probabilityToChange,
    required this.typeOfChange,
    required this.percentageOfVariation,
    required this.eventDescription,
  });

  factory FxEvent.fromJson(Map<String, dynamic> json) {
    return FxEvent(
      probabilityToChange: json['probability_to_change'],
      typeOfChange: json['type_of_change'],
      percentageOfVariation: (json['percentage_of_variation'] as num)
          .toDouble(),
      eventDescription: json['event_description'],
    );
  }
}

extension GameInvestmentDataX on GameInvestmentData {
  GameInvestmentData copyWithNewCapital(double newCapital, FxRate newBaseRate) {
    return GameInvestmentData(
      initialCapitalPen: newCapital,
      baseFxRate: newBaseRate,
      rounds: rounds,
    );
  }
}
