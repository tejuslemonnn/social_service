import 'package:social_service/models/category_model.dart';

abstract class ImplCategoryRepository{
  Stream<List<Category>> getAllCategories();
}