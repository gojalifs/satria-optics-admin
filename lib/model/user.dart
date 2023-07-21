import 'dart:convert';
import 'dart:io';

class UserProfile {
  final String? id;
  final bool? isOwner;
  final String? name;
  final String? email;
  final String? phone;
  final String? birth;
  final String? gender;
  final String? avatarPath;
  final File? image;
  final DateTime? createdAt;

  UserProfile({
    this.id = '',
    this.isOwner = false,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.birth = '',
    this.gender = '',
    this.avatarPath = '',
    this.image,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isOwner': isOwner,
      'name': name,
      'email': email,
      'phone': phone,
      'birth': birth,
      'gender': gender,
      'avatarPath': avatarPath,
      'image': image,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      isOwner: map['isOwner'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      birth: map['birth'],
      gender: map['gender'],
      avatarPath: map['avatarPath'],
      image: map['image'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  UserProfile copyWith({
    String? id,
    bool? isOwner,
    String? name,
    String? email,
    String? phone,
    String? birth,
    String? gender,
    String? avatarPath,
    File? image,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      isOwner: isOwner ?? this.isOwner,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      avatarPath: avatarPath ?? this.avatarPath,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, isOwner: $isOwner, name: $name, email: $email, phone: $phone, birth: $birth, gender: $gender, avatarPath: $avatarPath, image: $image, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.isOwner == isOwner &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.birth == birth &&
        other.gender == gender &&
        other.avatarPath == avatarPath &&
        other.image == image &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isOwner.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        avatarPath.hashCode ^
        image.hashCode ^
        createdAt.hashCode;
  }
}
