class BenefitUsage {
  final double totalDiscount;
  final int totalUsed;
  final List<MonthlyUsage> monthlyUsage;

  BenefitUsage({
    required this.totalDiscount,
    required this.totalUsed,
    required this.monthlyUsage,
  });

  factory BenefitUsage.fromJson(Map<String, dynamic> json) {
    return BenefitUsage(
      totalDiscount: (json['totalDiscount'] as num).toDouble(),
      totalUsed: json['totalUsed'] as int,
      monthlyUsage: (json['monthlyUsage'] as List<dynamic>)
          .map((item) => MonthlyUsage.fromJson(item))
          .toList(),
    );
  }
}

class MonthlyUsage {
  final String monthYear;
  final List<Usage> usages;

  MonthlyUsage({
    required this.monthYear,
    required this.usages,
  });

  factory MonthlyUsage.fromJson(Map<String, dynamic> json) {
    return MonthlyUsage(
      monthYear: json['monthYear'] as String,
      usages: (json['usages'] as List<dynamic>)
          .map((item) => Usage.fromJson(item))
          .toList(),
    );
  }
}

class Usage {
  final String restaurantName;
  final String logoUrl;
  final double billAmountFull;
  final double billAmountDiscounted;
  final double discount;
  final DateTime usedAt;

  Usage({
    required this.restaurantName,
    required this.logoUrl,
    required this.billAmountFull,
    required this.billAmountDiscounted,
    required this.discount,
    required this.usedAt,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      restaurantName: json['restaurantName'] as String,
      logoUrl: json['logoUrl'] as String,
      billAmountFull: (json['billAmountFull'] as num).toDouble(),
      billAmountDiscounted: (json['billAmountDiscounted'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      usedAt: DateTime.parse(json['usedAt'] as String),
    );
  }
} 