class RateEventRequest {
  final double baseRate;
  final String economicOutlookStatement;
  final RateVariation rateVariation;
  final HiddenEvent hiddenEvent;

  RateEventRequest({
    required this.baseRate,
    required this.economicOutlookStatement,
    required this.rateVariation,
    required this.hiddenEvent,
  });

  Map<String, dynamic> toJson() => {
    'base_rate': baseRate,
    'economic_outlook_statement': economicOutlookStatement,
    'rate_variation': rateVariation.toJson(),
    'hidden_event': hiddenEvent.toJson(),
  };
}

class RateVariation {
  final String direction;
  final int probability;
  final double? newRatePercentage;

  RateVariation({
    required this.direction,
    required this.probability,
    this.newRatePercentage,
  });

  factory RateVariation.fromJson(Map<String, dynamic> json) {
    return RateVariation(
      direction: json['direction'] ?? '',
      probability: (json['probability'] as num?)?.toInt() ?? 0,
      newRatePercentage: (json['new_rate_percentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'direction': direction,
    'probability': probability,
    'new_rate_percentage': newRatePercentage,
  };
}

class HiddenEvent {
  final String statement;
  final String direction;
  final int probability;
  final double? newRatePercentage;

  HiddenEvent({
    required this.statement,
    required this.direction,
    required this.probability,
    this.newRatePercentage,
  });

  factory HiddenEvent.fromJson(Map<String, dynamic> json) => HiddenEvent(
    statement: json['statement'] ?? '',
    direction: json['direction'] ?? '',
    probability: (json['probability'] as num?)?.toInt() ?? 0,
    newRatePercentage: (json['new_rate_percentage'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'statement': statement,
    'direction': direction,
    'probability': probability,
    'new_rate_percentage': newRatePercentage,
  };
}

class RateEventResponse {
  final String message;
  final double originalRate;
  final double newRate;
  final bool normalEventOccurred;
  final bool hiddenEventOccurred;

  RateEventResponse({
    required this.message,
    required this.originalRate,
    required this.newRate,
    required this.normalEventOccurred,
    required this.hiddenEventOccurred,
  });

  factory RateEventResponse.fromJson(Map<String, dynamic> json) =>
      RateEventResponse(
        message: json['message'],
        originalRate: (json['original_rate'] as num).toDouble(),
        newRate: (json['new_rate'] as num).toDouble(),
        normalEventOccurred: json['normal_event_occurred'],
        hiddenEventOccurred: json['hidden_event_occurred'],
      );
}
