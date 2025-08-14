import '../models/user_profile.dart';
import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService _fs;
  UserRepository(this._fs);

  Future<void> upsertUser(UserProfile p) => _fs.setUser(p.uid, p.toMap());

  Stream<UserProfile> streamProfile(String uid) =>
    _fs.userCol().doc(uid).snapshots().map((d) {
      final m = (d.data() ?? {}) as Map<String, dynamic>;
      m['uid'] = uid;
      return UserProfile.fromMap(m);
    });
}
