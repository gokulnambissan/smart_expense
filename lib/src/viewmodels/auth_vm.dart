import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../repositories/user_repository.dart';

class AuthVM extends ChangeNotifier {
  final _auth = AuthService();
  late final UserRepository _userRepo = UserRepository(FirestoreService());

  bool _ready = false;
  bool get ready => _ready;
  bool get isLoggedIn => _auth.currentUser != null;
  User? get user => _auth.currentUser;

  void init() {
    _auth.authStateChanges().listen((_) {
      _ready = true;
      notifyListeners();
    });
  }

  Future<String?> signup(String name, String email, String pass) async {
    try {
      final cred = await _auth.signup(email, pass);
      final p = UserProfile(uid: cred.user!.uid, name: name, email: email);
      await _userRepo.upsertUser(p);
      return null;
    } catch (e) { return e.toString(); }
  }

  Future<String?> login(String email, String pass) async {
    try { await _auth.login(email, pass); return null; }
    catch (e) { return e.toString(); }
  }

  Future<String?> google() async {
    try {
      final cred = await _auth.loginWithGoogle();
      final u = cred.user!;
      await _userRepo.upsertUser(
        UserProfile(uid: u.uid, name: u.displayName ?? '', email: u.email ?? '', photoUrl: u.photoURL)
      );
      return null;
    } catch (e) { return e.toString(); }
  }

  Future<void> logout() => _auth.logout();
}
