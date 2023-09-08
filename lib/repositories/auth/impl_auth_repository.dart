abstract class ImplAuthRepository {
  Future<void> signupUser(
      {required String role,
      required String name,
      required String email,
      required String password});

  Future<void> loginUser({required String email, required String password});

  Future<void> signInWithToken(String token);

  Future<void> logout();

  Future<void> updateWallet({
    required int wallet,
    required String email,
  });
}
