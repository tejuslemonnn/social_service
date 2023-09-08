import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_service/models/product_model.dart';
import 'package:social_service/repositories/products/impl_product_repository.dart';

class ProductRepository extends ImplProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore.collection('products').snapshots().map(
          (event) =>
              event.docs.map((docs) => Product.fromSnapshop(docs)).toList(),
        );
  }
}
