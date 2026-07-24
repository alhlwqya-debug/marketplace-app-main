class UserEntity {
  final String uid;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String type;
  final bool isVerified;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.type,
    required this.isVerified,
  });
}
