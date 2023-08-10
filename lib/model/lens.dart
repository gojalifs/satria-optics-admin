import 'dart:convert';

class Lens {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final int? price;

  Lens({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory Lens.fromMap(Map<String, dynamic> map) {
    return Lens(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Lens.fromJson(String source) => Lens.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Lens &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        price.hashCode;
  }

  Lens copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? price,
  }) {
    return Lens(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'Lens(id: $id, name: $name, description: $description, imageUrl: $imageUrl, price: $price)';
  }
}
