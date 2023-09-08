import 'package:social_service/models/product_model.dart';

abstract class ImplProductRepository {
  Stream<List<Product>> getAllProducts();
}
