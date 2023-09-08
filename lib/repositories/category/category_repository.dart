import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_service/models/error_exception.dart';
import 'package:social_service/models/category_model.dart';
import 'package:social_service/repositories/category/impl_category_repository.dart';

class CategoryRepository extends ImplCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Category>> getAllCategories() {
    return _firebaseFirestore
        .collection('categories')
        .snapshots()
        .map(
          (event) =>
              event.docs.map((docs) => Category.fromSnapshop(docs)).toList(),
        )
        .handleError((error) {
          throw ErrorException(message: error);
    });
  }
}
