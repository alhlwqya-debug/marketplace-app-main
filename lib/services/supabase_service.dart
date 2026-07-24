import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class SupabaseService {
  static late SupabaseClient _client;
  static bool _initialized = false;

  // ✅ YOUR SUPABASE PROJECT
  static const String supabaseUrl = 'https://shofjkpvtgitelqvmatp.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_LtM9lVjFeOwcnRJV500E_Q_Vkxivib7';

  static Future<void> initialize() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false,
    );

    _client = Supabase.instance.client;
    _initialized = true;
  }

  static SupabaseClient get client => _client;
  static SupabaseQueryBuilder get productsTable => _client.from('products');
  static SupabaseQueryBuilder get storesTable => _client.from('stores');
  static SupabaseQueryBuilder get ordersTable => _client.from('orders');
  static SupabaseQueryBuilder get usersTable => _client.from('users');
  static SupabaseQueryBuilder get reviewsTable => _client.from('reviews');
  static SupabaseQueryBuilder get cartsTable => _client.from('carts');

  // Storage buckets
  static SupabaseStorageClient get storage => _client.storage;
  static String get productImagesBucket => 'product-images';
  static String get storeLogosBucket => 'store-logos';
  static String get userAvatarsBucket => 'user-avatars';
  static String get reviewImagesBucket => 'review-images';

  /// Compress image before upload to save storage
  static Future<Uint8List> compressImage(File file, {int quality = 80}) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: quality,
      format: CompressFormat.webp,
    );
    return result ?? await file.readAsBytes();
  }

  /// Upload image with compression and automatic WebP conversion
  static Future<String> uploadImage({
    required File file,
    required String bucket,
    required String path,
    int quality = 80,
  }) async {
    // Compress image first
    final bytes = await compressImage(file, quality: quality);

    // Upload to Supabase Storage
    final fileName = '$path/${DateTime.now().millisecondsSinceEpoch}.webp';

    await storage.from(bucket).uploadBinary(
      fileName,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'image/webp',
        upsert: false,
      ),
    );

    // Get public URL
    final imageUrl = storage.from(bucket).getPublicUrl(fileName);
    return imageUrl;
  }

  /// Upload multiple images with batch processing
  static Future<List<String>> uploadMultipleImages({
    required List<File> files,
    required String bucket,
    required String path,
    int quality = 80,
  }) async {
    final urls = <String>[];

    for (final file in files) {
      try {
        final url = await uploadImage(
          file: file,
          bucket: bucket,
          path: path,
          quality: quality,
        );
        urls.add(url);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return urls;
  }

  /// Delete image from storage
  static Future<void> deleteImage(String bucket, String path) async {
    try {
      await storage.from(bucket).remove([path]);
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  /// Real-time subscriptions for live updates
  static RealtimeChannel subscribeToTable({
    required String table,
    required Function(PostgresChangePayload) onChange,
  }) {
    return _client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: onChange,
        )
        .subscribe();
  }
}
