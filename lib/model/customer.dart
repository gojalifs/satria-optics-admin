import 'dart:convert';

class Customer {
  final String? id;
  final String? username;
  final String? email;
  final String? phone;

  Customer({
    this.id,
    this.username,
    this.email,
    this.phone,
  });

  Customer copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
  }) {
    return Customer(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  static List<Customer> search(List<Customer> customers, String query) {
    query = query.toLowerCase();

    return customers
        .where((element) =>
            element.id.toString().toLowerCase().contains(query) ||
            element.username.toString().toLowerCase().contains(query) ||
            element.email.toString().toLowerCase().contains(query) ||
            element.phone.toString().toLowerCase().contains(query))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Customer(id: $id, username: $username, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ email.hashCode ^ phone.hashCode;
  }
}
