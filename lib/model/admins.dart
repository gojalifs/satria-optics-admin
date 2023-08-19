import 'dart:convert';

class Admin {
  final String? id;
  final String? name;
  final String? email;
  final bool? isOwner;
  bool? isBanned;
  final String? password;

  Admin({
    this.id,
    required this.name,
    required this.email,
    this.isOwner = false,
    this.isBanned = false,
    this.password,
  });

  Admin copyWith({
    String? id,
    String? name,
    String? email,
    bool? isOwner,
    bool? isBanned,
    String? password,
  }) {
    return Admin(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isOwner: isOwner ?? this.isOwner,
      isBanned: isBanned ?? this.isBanned,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isOwner': isOwner ?? false,
      'isBanned': isBanned ?? false,
      'password': password,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      isOwner: map['isOwner'] ?? false,
      isBanned: map['isBanned'] ?? false,
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) => Admin.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Admin(id: $id, name: $name, email: $email, isOwner: $isOwner, isBanned: $isBanned, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Admin &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.isOwner == isOwner &&
        other.isBanned == isBanned &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        isOwner.hashCode ^
        isBanned.hashCode ^
        password.hashCode;
  }
}
