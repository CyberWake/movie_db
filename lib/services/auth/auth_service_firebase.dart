import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_db/services/auth/auth_service.dart';
import 'package:movie_db/services/service_locator.dart';

class FirebaseAuthService extends Auth{
  late User? currentUser;

  @override
  Future<bool> login({required String password,required String emailAddress}) async{
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      currentUser = userCredential.user;
      return true;
    } on FirebaseAuthException catch(e)  {
      navigationService.showSnackBar(e.message ?? "Unknown error occurred");
      return false;
    }
  }

  @override
  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<bool> signup({required String name,required String emailAddress,required String password}) async{
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(userCredential.user!.uid).set({
        'name': name,
        'email': emailAddress,
        'id': userCredential.user!.uid
      });
      currentUser = userCredential.user;
      return true;
    } on FirebaseAuthException catch (e) {
      navigationService.showSnackBar(e.message ?? "Unknown error occurred");
      return false;
    }
  }

  @override
  Future<bool> isLoggedIn()async {
    currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }
}