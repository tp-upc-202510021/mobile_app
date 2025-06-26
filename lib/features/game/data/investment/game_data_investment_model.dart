class GameInvestmentData {
  final double initialCapitalPen;
  final BaseFxRate baseFxRate;
  final List<InvestmentRound> rounds;

  GameInvestmentData({
    required this.initialCapitalPen,
    required this.baseFxRate,
    required this.rounds,
  });

  factory GameInvestmentData.fromJson(Map<String, dynamic> json) {
    return GameInvestmentData(
      initialCapitalPen: json['initial_capital_pen'],
      baseFxRate: BaseFxRate.fromJson(json['base_fx_rate']),
      rounds: (json['rounds'] as List)
          .map((e) => InvestmentRound.fromJson(e))
          .toList(),
    );
  }
}

class BaseFxRate {
  final double buy;
  final double sell;

  BaseFxRate({required this.buy, required this.sell});

  factory BaseFxRate.fromJson(Map<String, dynamic> json) {
    return BaseFxRate(buy: json['buy'], sell: json['sell']);
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
      options: (json['options'] as List)
          .map((e) => InvestmentOption.fromJson(e))
          .toList(),
      fxEvent: FxEvent.fromJson(json['fx_event']),
    );
  }
}

class InvestmentOption {
  final String title;
  final String description;
  final double expectedReturnPct;
  final double volatilityPct;
  final String riskLevel;
  final String frequency;
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
      title: json['title'],
      description: json['description'],
      expectedReturnPct: json['expected_return_pct'],
      volatilityPct: json['volatility_pct'],
      riskLevel: json['risk_level'],
      frequency: json['frequency'],
      currency: json['currency'],
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
      percentageOfVariation: json['percentage_of_variation'],
      eventDescription: json['event_description'],
    );
  }
}
