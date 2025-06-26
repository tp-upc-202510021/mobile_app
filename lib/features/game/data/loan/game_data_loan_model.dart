import 'package:mobile_app/features/game/data/loan/rate_event_loan_model.dart';

class GameLoanData {
  final BaseRate baseRate;
  final List<GameLoanRound> rounds;

  GameLoanData({required this.baseRate, required this.rounds});

  factory GameLoanData.fromJson(Map<String, dynamic> json) {
    return GameLoanData(
      baseRate: BaseRate.fromJson(json['base_rate_BCRP']),
      rounds: (json['rounds'] as List)
          .map((r) => GameLoanRound.fromJson(r))
          .toList(),
    );
  }
}

class BaseRate {
  final String description;
  final String rateType;
  final double value;
  final String date;

  BaseRate({
    required this.description,
    required this.rateType,
    required this.value,
    required this.date,
  });

  factory BaseRate.fromJson(Map<String, dynamic> json) => BaseRate(
    description: json['description'],
    rateType: json['rate_type'],
    value: (json['value'] as num).toDouble(),
    date: json['date'],
  );
}

class GameLoanRound {
  final int round;
  final String statement;
  final int requiredAmount;
  final String economicOutlookStatement;
  final RateVariation rateVariation;
  final HiddenEvent hiddenEvent;
  final List<LoanOption> options;

  GameLoanRound({
    required this.round,
    required this.statement,
    required this.requiredAmount,
    required this.economicOutlookStatement,
    required this.rateVariation,
    required this.hiddenEvent,
    required this.options,
  });

  factory GameLoanRound.fromJson(Map<String, dynamic> json) => GameLoanRound(
    round: json['round'],
    statement: json['statement'],
    requiredAmount: json['required_amount'],
    economicOutlookStatement: json['economic_outlook_statement'],
    rateVariation: RateVariation.fromJson(json['rate_variation']),
    hiddenEvent: HiddenEvent.fromJson(json['hidden_event']),
    options: (json['options'] as List)
        .map((e) => LoanOption.fromJson(e))
        .toList(),
  );
}

class LoanOption {
  final String financialEntity;
  final String interestRateType;
  final bool isVariable;
  final double spreadPercentage;
  final int repaymentTermMonths;

  LoanOption({
    required this.financialEntity,
    required this.interestRateType,
    required this.isVariable,
    required this.spreadPercentage,
    required this.repaymentTermMonths,
  });

  factory LoanOption.fromJson(Map<String, dynamic> json) => LoanOption(
    financialEntity: json['financial_entity'],
    interestRateType: json['interest_rate_type'],
    isVariable: json['is_variable'],
    spreadPercentage: (json['spread_percentage'] as num).toDouble(),
    repaymentTermMonths: json['repayment_term_months'],
  );
}

class LoanResult {
  final double totalPaid;
  final double totalInterest;
  final String message;

  LoanResult({
    required this.totalPaid,
    required this.totalInterest,
    required this.message,
  });
}
