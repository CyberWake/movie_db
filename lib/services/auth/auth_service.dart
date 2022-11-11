abstract class Auth{
  Future<bool> signup({required String name,required String emailAddress,required String password});
  Future<bool> login({required String password,required String emailAddress});
  Future<void> signOut();
  Future<bool> isLoggedIn();
}