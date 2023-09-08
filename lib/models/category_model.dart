import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  @override
  List<Object?> get props => [name, code];

  final String name;
  final String code;

  const Category({
    required this.name,
    required this.code,
  });

  static Category fromSnapshop(DocumentSnapshot snapshot) {
    Category category =
        Category(name: snapshot['name'], code: snapshot['code']);
    return category;
  }
}
