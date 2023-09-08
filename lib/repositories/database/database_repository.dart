import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_service/models/user_model.dart';
import 'package:social_service/repositories/database/impl_database_repository.dart';


class DatabaseRepository extends ImplDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String email) {
    return _firebaseFirestore
        .collection('users')
        .doc(email)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUser(User user) async {
    return _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update(user.toJson())
        .then(
          (value) => print('User document updated.'),
    );
  }
}