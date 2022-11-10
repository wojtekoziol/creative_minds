abstract class IAuthRepo {
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}
