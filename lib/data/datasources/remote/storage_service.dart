import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<List<File>> pickMultipleImages({int maxImages = 5}) async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    return pickedFiles.take(maxImages).map((f) => File(f.path)).toList();
  }

  static Future<String> uploadFile({
    required File file,
    required String path,
    required String fileName,
  }) async {
    final ref = FirebaseStorage.instance.ref().child('$path/$fileName');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  static Future<void> deleteFile(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  static String generateFileName(String prefix) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}
