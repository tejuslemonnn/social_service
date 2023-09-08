import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  @override
  List<Object?> get props => [name, code, isPopular, category];

  final String name;
  final String category;
  final String code;
  final bool isPopular;


  const Product({
    required this.name,
    required this.code,
    required this.isPopular,
    required this.category,
  });

  static Product fromSnapshop(DocumentSnapshot snapshot) {
    Product category = Product(
        name: snapshot['name'],
        code: snapshot['code'],
        isPopular: snapshot['isPopular'],
        category: snapshot['category']);
    return category;
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'code': code,
      'isPopular': isPopular,
      'category': category,
    };
  }

static Product fromJson(Map<String, Object> json) {
    return Product(
      name: json['name'] as String,
      code: json['code'] as String,
      isPopular: json['isPopular'] as bool,
      category: json['category'] as String,
    );
  }
}
