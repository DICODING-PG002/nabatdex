import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageScanProvider with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  ImageState _state = ImageInitial();

  ImageState get state => _state;

  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  /// Resize gambar menjadi exact 256x256 pixels
  Future<XFile> _resizeImageTo256x256(XFile imageFile) async {
    try {
      // Baca file gambar
      final bytes = await imageFile.readAsBytes();
      
      // Decode gambar
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        throw Exception('Gagal decode gambar');
      }

      // Resize gambar ke 256x256 dengan cara crop center square terlebih dahulu
      // untuk menjaga aspect ratio 1:1
      int size = image.width < image.height ? image.width : image.height;
      int offsetX = (image.width - size) ~/ 2;
      int offsetY = (image.height - size) ~/ 2;

      // Crop ke center square
      img.Image croppedImage = img.copyCrop(
        image,
        x: offsetX,
        y: offsetY,
        width: size,
        height: size,
      );

      // Resize ke 256x256
      img.Image resizedImage = img.copyResize(
        croppedImage,
        width: 256,
        height: 256,
        interpolation: img.Interpolation.linear,
      );

      // Save ke temporary directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'resized_image_$timestamp.jpg';
      final filePath = path.join(tempDir.path, fileName);

      // Encode dan save
      final resizedBytes = img.encodeJpg(resizedImage, quality: 90);
      final file = File(filePath);
      await file.writeAsBytes(resizedBytes);

      debugPrint('Gambar berhasil di-resize menjadi 256x256: $filePath');

      return XFile(filePath);
    } catch (e) {
      debugPrint('Error saat resize gambar: $e');
      // Jika gagal resize, return gambar original
      return imageFile;
    }
  }

  /// Mendapatkan permission yang tepat berdasarkan source dan versi Android
  Future<PermissionStatus> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      return await Permission.camera.request();
    } else {
      // Untuk galeri, cek versi Android
      if (Platform.isAndroid) {
        // Untuk Android 13+ (API 33+), gunakan permission.photos
        // Untuk Android 10-12 (API 29-32), gunakan permission.storage
        // permission_handler akan otomatis handle ini
        
        // Coba request photos permission terlebih dahulu (untuk Android 13+)
        final photosStatus = await Permission.photos.request();
        
        if (photosStatus.isGranted) {
          return photosStatus;
        }
        
        // Jika tidak granted, coba storage permission (untuk Android 10-12)
        final storageStatus = await Permission.storage.request();
        
        // Return status yang lebih baik (granted > limited > denied)
        if (storageStatus.isGranted || photosStatus.isGranted) {
          return PermissionStatus.granted;
        } else if (storageStatus.isLimited || photosStatus.isLimited) {
          return PermissionStatus.limited;
        } else if (storageStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
          return PermissionStatus.permanentlyDenied;
        } else {
          return PermissionStatus.denied;
        }
      } else {
        // Untuk iOS
        return await Permission.photos.request();
      }
    }
  }

  Future<bool> pickImage(ImageSource source) async {
    final PermissionStatus status = await _requestPermission(source);

    if (!status.isGranted && !status.isLimited) {
      String message;
      if (status.isPermanentlyDenied) {
        message =
        "Izin untuk mengakses ${source == ImageSource.camera ? 'kamera' : 'galeri'} ditolak permanen. "
            "Harap aktifkan izin di pengaturan aplikasi.";
        // Buka halaman pengaturan aplikasi
        await openAppSettings();
      } else {
        // Jika hanya ditolak sementara (belum di klik tolak melalui pop up permission request)
        message = "Izin untuk mengakses ${source == ImageSource.camera ? 'kamera' : 'galeri'} ditolak.";
      }

      _state = ImageError(message);
      notifyListeners();
      return false;
    }

    _state = ImageLoading();
    notifyListeners();

    try {
      // Pick image dari sumber (camera/gallery)
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100, // Kualitas tinggi untuk proses resize yang lebih baik
      );
      
      if (pickedFile != null) {
        debugPrint(' Gambar dipilih: ${pickedFile.path}');
        
        // Resize gambar menjadi exact 256x256 pixels dan simpan
        final resizedFile = await _resizeImageTo256x256(pickedFile);
        
        _imageFile = resizedFile;
        _state = ImageLoaded(resizedFile);
        notifyListeners();
        return true;
      } else {
        // User membatalkan pemilihan gambar
        _state = ImageInitial();
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = ImageError("Gagal mengambil gambar: $e");
      notifyListeners();
      debugPrint('❌ Error pickImage: $e');
      return false;
    }
  }

  // Membersihkan state setelah gambar selesai diproses
  void clearImage() {
    _imageFile = null;
    _state = ImageInitial();
    notifyListeners();
  }
}

// Sealed class utama
sealed class ImageState {}

// State Awal, sebelum ada aksi apa pun, dan masih kosong
class ImageInitial extends ImageState {}

// State saat sedang memuat data dari database
class ImageLoading extends ImageState {}

// Berhasil ambil data
class ImageLoaded extends ImageState {
  final XFile imageFile;

  ImageLoaded(this.imageFile);
}

// Terjadi error
class ImageError extends ImageState {
  final String message;

  ImageError(this.message);
}
