import 'package:social_service/models/user_model.dart';

abstract class ImplDatabaseRepository {
  Stream<User> getUser(String email);
  Future<void> updateUser(User user);
}