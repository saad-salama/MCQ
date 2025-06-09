import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class CameraService {
  static final ImagePicker _picker = ImagePicker();
  
  // Get available cameras
  static Future<List<CameraDescription>> getAvailableCameras() async {
    try {
      return await availableCameras();
    } catch (e) {
      print('Error getting cameras: $e');
      return [];
    }
  }

  // Take photo from camera
  static Future<File?> takePhotoFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Show options dialog for image source
  static Future<File?> showImageSourceDialog() async {
    // This would typically show a dialog to choose between camera and gallery
    // For now, we'll just use camera by default
    return await takePhotoFromCamera();
  }
} 