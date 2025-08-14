import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../repositories/user_repository.dart';
import '../services/firestore_service.dart';

class ProfileVM extends ChangeNotifier {
  final _repo = UserRepository(FirestoreService());
  UserProfile? profile;
  Stream<UserProfile>? _stream;

  void init() {}

  void load(String uid) {
    _stream = _repo.streamProfile(uid);
    _stream!.listen((p) { profile = p; notifyListeners(); });
  }

  Future<void> updateName(String uid, String name) async {
    final p = profile;
    if (p == null) return;
    p.name = name;
    await _repo.upsertUser(p);
  }

  Future<void> updatePhoto(String uid, String url) async {
    final p = profile; if (p == null) return;
    p.photoUrl = url; await _repo.upsertUser(p);
  }

  Future<void> updateBudget(String uid, double budget) async {
    final p = profile; if (p == null) return;
    p.monthlyBudget = budget; await _repo.upsertUser(p);
  }
}
