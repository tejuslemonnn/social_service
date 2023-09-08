import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Service extends Equatable {
  @override
  List<Object?> get props => [name, categoryProduct];

  final String name;
  final String categoryProduct;
  final int fee;

  const Service({
    required this.name,
    required this.categoryProduct,
    required this.fee,
  });

  static Service fromSnapshop(DocumentSnapshot snapshot) {
    Service category = Service(name: snapshot['name'], categoryProduct: snapshot['category_code'], fee: snapshot['fee']);
    return category;
  }
}
