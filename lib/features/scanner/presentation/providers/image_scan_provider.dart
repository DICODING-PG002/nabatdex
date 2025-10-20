import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageScanProvider with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  ImageState _state = ImageInitial();

  ImageState get state => _state;

  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  Future<bool> pickImage(ImageSource source) async {
    final Permission permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    final PermissionStatus status = await permission.request();

    if (!status.isGranted) {
      String message;
      if (status.isPermanentlyDenied) {
        message =
        "Izin untuk mengakses ${source.name} ditolak permanen. "
            "Harap aktifkan izin di pengaturan aplikasi.";
        // Buka halaman pengaturan aplikasi
        await openAppSettings();
      } else {
        // Jika hanya ditolak sementara (belum di klik tolak melalui pop up permission request)
        message = "Izin untuk mengakses ${source.name} ditolak.";
      }

      _state = ImageError(message);
      notifyListeners();
      return false;
    }

    _state = ImageLoading();
    notifyListeners();

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 256,
        maxWidth: 256,
      );
      if (pickedFile != null) {
        _imageFile = pickedFile;
        _state = ImageLoaded(pickedFile);
        notifyListeners();
        return true;
      } else {
        _state = ImageInitial();
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = ImageError("Gagal mengambil gambar: $e");
      notifyListeners();
      return false;
    }
  }

  Future<void> cropImage() async {
    // Pastikan ada file gambar untuk di-crop
    if (_imageFile == null) return;

    try {
      if (_imageFile == null) {
        throw Error();
      }
      final croppedFile = await _cropper.cropImage(
        sourcePath: _imageFile!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit Gambar',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Edit Gambar',
            doneButtonTitle: 'Selesai',
            cancelButtonTitle: 'Batal',
          ),
        ],
      );

      // Jika user berhasil crop (tidak menekan tombol cancel)
      if (croppedFile != null) {
        // Ganti file gambar lama & state dengan file yang sudah di-crop
        _imageFile = XFile(croppedFile.path);
        _state = ImageLoaded(_imageFile!);
        notifyListeners();
      }
    } catch (e) {
      _state = ImageError("Gagal mengedit gambar: $e");
      notifyListeners();
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
