import 'dart:convert';

class ReportModel {
  String id;
  DateTime date;
  int quantity;
  int total;

  ReportModel({
    required this.id,
    required this.date,
    required this.quantity,
    required this.total,
  });

  ReportModel copyWith({
    String? id,
    DateTime? date,
    int? quantity,
    int? total,
  }) {
    return ReportModel(
      id: id ?? this.id,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'quantity': quantity,
      'total': total,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      quantity: map['quantity']?.toInt() ?? 0,
      total: map['total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) =>
      ReportModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReportModel(id: $id, date: $date, quantity: $quantity, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportModel &&
        other.id == id &&
        other.date == date &&
        other.quantity == quantity &&
        other.total == total;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ quantity.hashCode ^ total.hashCode;
  }
}
