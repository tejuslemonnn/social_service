import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:social_service/database/database_helper.dart';
import 'package:social_service/models/error_exception.dart';
import 'package:social_service/models/user_model.dart';
import 'package:social_service/repositories/auth/impl_auth_repository.dart';
import 'package:social_service/core/utils/AuthExceptionHandler.dart';

class AuthRepository extends ImplAuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  AuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;

      if (firebaseUser != null) {
        final detailUser = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();
        currentUser = User.fromJson(detailUser.docs[0].data());
      }

      return currentUser;
    });
  }

  // TODO: Model User for Signup
  @override
  Future<void> signupUser({
    required String role,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final emailIsAlreadyInRole = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: role)
          .where('email', isEqualTo: email)
          .get();

      if (emailIsAlreadyInRole.docs.isNotEmpty) {
        throw ErrorException(message: 'Email already exists for role: $role.');
      }

      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = authResult.user;

      Map<String, dynamic> data = {
        "uid": user!.uid,
        "name": name,
        "role": role,
        "email": user.email,
        "photo": null,
      };

      if (role == "Engineer") {
        data["wallet"] = 0;
      }

      await Future.wait([
        user.updateDisplayName(name),
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .set(data),
      ]);
    } on firebase_auth.FirebaseAuthException catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      if (status != AuthResultStatus.successful) {
        throw ErrorException(
            message: AuthExceptionHandler.generateExceptionMessage(status));
      }

      rethrow;
    }
  }

  @override
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = _firebaseAuth.currentUser;

      if (user != null) {
        final token = await user.getIdToken();
        await _dbHelper.saveToken(token!);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      if (status != AuthResultStatus.successful) {
        throw ErrorException(
            message: AuthExceptionHandler.generateExceptionMessage(status));
      }

      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _dbHelper.clearTokens(),
      ]);
      currentUser = User.empty;
    } catch (_) {}
  }

  @override
  Future<void> signInWithToken(String token) async {
    try {
      final credential =
          firebase_auth.FirebaseAuth.instance.signInWithCustomToken(token);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-custom-token":
          print("The supplied token is not a Firebase custom auth token.");
          break;
        case "custom-token-mismatch":
          print("The supplied token is for a different Firebase project.");
          break;
        default:
          print("Unkown error.");
      }
    }
  }

  // update wallet
  @override
  Future<void> updateWallet({required int wallet, required String email}) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(email)
          .update({'wallet': FieldValue.increment(wallet)});

      await firebaseFirestore
          .collection('users')
          .doc(email)
          .get()
          .then((value) {
        currentUser = User.fromJson(value.data()!);
      });

    } catch (error) {
      throw Exception("Error getting order: $error");
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(uid: uid, email: email, name: displayName, photo: photoURL);
  }
}
