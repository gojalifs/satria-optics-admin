import 'dart:convert';

class Admin {
  final String? id;
  final String? name;
  final String? email;
  final bool? isOwner;
  bool? isBanned;

  Admin(
    this.id,
    this.name,
    this.email,
    this.isOwner,
    this.isBanned,
  );

  Admin copyWith({
    String? id,
    String? name,
    String? email,
    bool? isOwner,
    bool? isBanned,
  }) {
    return Admin(
      id ?? this.id,
      name ?? this.name,
      email ?? this.email,
      isOwner ?? this.isOwner,
      isBanned ?? this.isBanned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isOwner': isOwner,
      'isBanned': isBanned,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      map['id'],
      map['name'],
      map['email'],
      map['isOwner'] ?? false,
      map['isBanned'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) => Admin.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Admin(id: $id, name: $name, email: $email, isOwner: $isOwner, isBanned: $isBanned)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Admin &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.isOwner == isOwner &&
        other.isBanned == isBanned;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        isOwner.hashCode ^
        isBanned.hashCode;
  }
}
