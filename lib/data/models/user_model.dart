import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String phone;
  final String displayName;
  final String? avatarUrl;
  final UserType type;
  final DateTime createdAt;
  final bool isVerified;
  final String? fcmToken;

  const UserModel({
    required this.uid,
    required this.email,
    required this.phone,
    required this.displayName,
    this.avatarUrl,
    required this.type,
    required this.createdAt,
    required this.isVerified,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      type: UserType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => UserType.buyer,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isVerified: json['isVerified'] as bool,
      fcmToken: json['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerified': isVerified,
      'fcmToken': fcmToken,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? displayName,
    String? avatarUrl,
    UserType? type,
    DateTime? createdAt,
    bool? isVerified,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [uid, email, phone, displayName, avatarUrl, type, createdAt, isVerified, fcmToken];
}

enum UserType { buyer, seller, admin }
