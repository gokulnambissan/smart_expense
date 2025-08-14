import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signup(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> logout() => _auth.signOut();

  Future<UserCredential> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    return _auth.signInWithCredential(credential);
  }
}
