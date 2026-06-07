// lib/App/Services/firebase_storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadProductImages(
    File mainImage,
    List<File> additionalImages,
    String productId,
  ) async {
    List<String> imageUrls = [];

    try {
      // Upload main image
      String mainImageUrl = await _uploadImage(
        mainImage,
        'products/$productId/main_image',
      );
      imageUrls.add(mainImageUrl);

      // Upload additional images
      for (int i = 0; i < additionalImages.length; i++) {
        String imageUrl = await _uploadImage(
          additionalImages[i],
          'products/$productId/additional_image_$i',
        );
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error uploading images: $e');
      throw Exception('Failed to upload images');
    }
  }

  Future<String> _uploadImage(File image, String storagePath) async {
    try {
      // Compress image if needed
      // You can add image compression here

      Reference ref = _storage.ref().child(storagePath);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading single image: $e');
      rethrow;
    }
  }

  Future<void> deleteProductImages(String productId) async {
    try {
      final ListResult result =
          await _storage.ref().child('products/$productId').listAll();

      for (Reference ref in result.items) {
        await ref.delete();
      }
    } catch (e) {
      print('Error deleting images: $e');
    }
  }
}
