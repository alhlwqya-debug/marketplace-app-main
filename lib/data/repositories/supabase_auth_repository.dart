import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../services/supabase_service.dart';

class SupabaseAuthRepository {
  final SupabaseClient _client = SupabaseService.client;
  final _table = 'users';

  User? get currentUser => _client.auth.currentUser;
  String? get currentUserId => _client.auth.currentUser?.id;
  bool get isAuthenticated => _client.auth.currentUser != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Get current user data from database
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from(_table)
        .select('*')
        .eq('uid', user.id)
        .single();

    if (response == null) return null;
    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  /// Sign up with email and password
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final authResponse = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': name,
        'phone': phone,
      },
    );

    if (authResponse.user == null) {
      throw Exception('Signup failed');
    }

    // Create user record in database
    final user = UserModel(
      uid: authResponse.user!.id,
      email: email,
      phone: phone,
      displayName: name,
      type: UserType.buyer,
      createdAt: DateTime.now(),
      isVerified: false,
    );

    await _client.from(_table).insert(user.toJson());

    return user;
  }

  /// Sign in with email and password
  Future<UserModel> signIn(String email, String password) async {
    final authResponse = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw Exception('Login failed');
    }

    return await getCurrentUser() ?? UserModel(
      uid: authResponse.user!.id,
      email: email,
      phone: '',
      displayName: authResponse.user!.userMetadata?['display_name'] ?? '',
      type: UserType.buyer,
      createdAt: DateTime.now(),
      isVerified: authResponse.user!.emailConfirmedAt != null,
    );
  }

  /// Sign in with OTP (Phone)
  Future<void> signInWithOtp(String phone) async {
    await _client.auth.signInWithOtp(
      phone: phone,
    );
  }

  /// Verify OTP
  Future<UserModel> verifyOtp(String phone, String token) async {
    final authResponse = await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );

    if (authResponse.user == null) {
      throw Exception('OTP verification failed');
    }

    return await getCurrentUser() ?? UserModel(
      uid: authResponse.user!.id,
      email: authResponse.user!.email ?? '',
      phone: phone,
      displayName: '',
      type: UserType.buyer,
      createdAt: DateTime.now(),
      isVerified: true,
    );
  }

  /// Sign in with OAuth (Google, Apple, etc.)
  Future<UserModel> signInWithOAuth(Provider provider) async {
    await _client.auth.signInWithOAuth(
      provider,
      redirectTo: 'io.supabase.marketplace://callback',
    );

    // User will be redirected back to app
    // Handle in deep link
    throw Exception('OAuth redirect initiated');
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.marketplace://reset-password',
    );
  }

  /// Update user profile
  Future<void> updateUser(UserModel user) async {
    await _client
        .from(_table)
        .update(user.toJson())
        .eq('uid', user.uid);
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Update email
  Future<void> updateEmail(String newEmail) async {
    await _client.auth.updateUser(
      UserAttributes(email: newEmail),
    );
  }

  /// Upload avatar
  Future<String> uploadAvatar(String userId, dynamic imageFile) async {
    final fileName = 'avatars/$userId/${DateTime.now().millisecondsSinceEpoch}.webp';

    await _client.storage
        .from('user-avatars')
        .upload(fileName, imageFile);

    return _client.storage
        .from('user-avatars')
        .getPublicUrl(fileName);
  }
}
