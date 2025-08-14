class UserProfile {
  final String uid;
  String name;
  String email;
  String? photoUrl;
  double monthlyBudget;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.monthlyBudget = 0,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'monthlyBudget': monthlyBudget,
      };

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        uid: m['uid'],
        name: m['name'] ?? '',
        email: m['email'] ?? '',
        photoUrl: m['photoUrl'],
        monthlyBudget: (m['monthlyBudget'] ?? 0).toDouble(),
      );
}
