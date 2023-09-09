import 'dart:convert';

class OrderSummary {
  final int total;
  final int count;

  OrderSummary({
    required this.total,
    required this.count,
  });

  OrderSummary copyWith({
    int? total,
    int? count,
  }) {
    return OrderSummary(
      total: total ?? this.total,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'count': count,
    };
  }

  factory OrderSummary.fromMap(Map<String, dynamic> map) {
    return OrderSummary(
      total: map['total']?.toInt() ?? 0,
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderSummary.fromJson(String source) =>
      OrderSummary.fromMap(json.decode(source));

  @override
  String toString() => 'OrderSummary(total: $total, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderSummary &&
        other.total == total &&
        other.count == count;
  }

  @override
  int get hashCode => total.hashCode ^ count.hashCode;
}
