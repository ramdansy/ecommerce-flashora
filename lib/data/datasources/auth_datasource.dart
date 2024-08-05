import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDatasource {
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password);
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password);
}

class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
