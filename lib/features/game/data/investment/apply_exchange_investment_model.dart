class ApplyExchangeEventResponse {
  final FxRate baseRate;
  final ExchangeEvent event;

  ApplyExchangeEventResponse({required this.baseRate, required this.event});

  factory ApplyExchangeEventResponse.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('event') || !json.containsKey('base_rate')) {
      throw Exception('JSON inválido: faltan campos obligatorios');
    }

    return ApplyExchangeEventResponse(
      baseRate: FxRate.fromJson(json['base_rate']),
      event: ExchangeEvent.fromJson(json['event']),
    );
  }
}

class FxRate {
  final double buy;
  final double sell;

  FxRate({required this.buy, required this.sell});

  factory FxRate.fromJson(Map<String, dynamic> json) {
    return FxRate(
      buy: (json['buy'] as num).toDouble(),
      sell: (json['sell'] as num).toDouble(),
    );
  }
}

class ExchangeEvent {
  final bool occurred;
  final String description;
  final String type;
  final double variationPct;
  final FxRate? newRate; // ✅ opcional internamente

  ExchangeEvent({
    required this.occurred,
    required this.description,
    required this.type,
    required this.variationPct,
    required this.newRate,
  });

  factory ExchangeEvent.fromJson(Map<String, dynamic> json) {
    final occurred = json['occurred'] as bool;

    // Validación: Si ocurrió, debe venir new_rate
    if (occurred && json['new_rate'] == null) {
      throw Exception('❌ Se esperaba "new_rate" porque occurred es true.');
    }

    return ExchangeEvent(
      occurred: occurred,
      description: json['description'],
      type: json['type'],
      variationPct: (json['variation_pct'] as num).toDouble(),
      newRate: occurred ? FxRate.fromJson(json['new_rate']) : null,
    );
  }
}
