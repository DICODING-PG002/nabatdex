# 🌱 NabatDex

> **Aplikasi Pendeteksi Penyakit Tanaman Berbasis Machine Learning**

Aplikasi mobile berbasis Flutter yang menggunakan teknologi Machine Learning untuk mendeteksi penyakit tanaman secara real-time melalui foto daun tanaman.

---

## 📱 Tentang Proyek

NabatDex adalah aplikasi mobile yang dikembangkan sebagai proyek capstone dari **Bootcamp Dicoding Flutter Dev x Machine Learning**. Aplikasi ini membantu para petani dan pecinta tanaman untuk mengidentifikasi penyakit tanaman dengan cepat dan akurat melalui teknologi TensorFlow Lite.

### Fitur Utama

✅ **Scanner Penyakit Tanaman**
- Deteksi penyakit tanaman secara real-time menggunakan kamera
- Dukungan 3 jenis tanaman: Kentang, Tomat, dan Padi
- Deteksi 20+ jenis penyakit dan kondisi sehat
- Akurasi tingkat confidence untuk setiap deteksi

✅ **Jurnal Tanaman**
- Catat hasil scan dan monitoring tanaman
- Lacak riwayat penanganan dan perawatan
- Tambah aktivitas perawatan tanaman
- Simpan gambar dan data deteksi

✅ **Ensiklopedia Tanaman**
- Informasi lengkap tentang tanaman (Kentang, Tomat, Padi)
- Detail penyakit: gejala, penyebab, solusi, dan pencegahan
- Panduan budidaya untuk masing-masing tanaman
- Visualisasi gejala penyakit

---

## 🛠️ Teknologi yang Digunakan

| Kategori | Teknologi |
|----------|-----------|
| **Framework** | Flutter 3.8.1 |
| **Machine Learning** | TensorFlow Lite |
| **Database** | SQLite (sqflite) |
| **State Management** | Provider |
| **Camera** | Camera Plugin, Image Picker |
| **UI/UX** | Material Design, Google Fonts, Figma |

### Dependencies Utama

```yaml
- flutter: sdk
- provider: ^6.1.5+1
- sqflite: ^2.4.2
- camera: ^0.11.2
- tflite_flutter: ^0.11.0
- image_picker: ^1.2.0
- image_cropper: ^11.0.0
- permission_handler: ^12.0.1
- google_fonts: ^6.3.2
```

---

## 📋 Prasyarat

Sebelum menjalankan aplikasi, pastikan Anda memiliki:

- ✅ **Flutter SDK** (minimal 3.8.1)
- **Dart SDK**
- **Android Studio** atau **Visual Studio Code**
- **Android SDK** (untuk Android)
- **Xcode** (untuk iOS - hanya macOS)

### Instalasi Flutter

1. Download Flutter SDK dari [flutter.dev](https://flutter.dev)
2. Extract ke lokasi yang diinginkan
3. Tambahkan Flutter ke PATH environment variable
4. Verifikasi instalasi dengan menjalankan:
   ```bash
   flutter doctor
   ```

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Clone Repository

```bash
git clone https://github.com/DICODING-PG002/nabatdex
cd nabatdex
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Pastikan Device/Emulator Siap

Untuk Android:
```bash
flutter devices
# Pastikan device/emulator terdeteksi
```

### 4. Jalankan Aplikasi

Mode Development:
```bash
flutter run
```

Mode Release (untuk build APK):
```bash
flutter build apk --release
```

Mode Debug:
```bash
flutter run --debug
```

---

## 📦 Build APK

### Cara Membuat APK

1. Jalankan perintah build:
   ```bash
   flutter build apk --release
   ```

2. File APK akan tersimpan di:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. Untuk split APK berdasarkan ABI:
   ```bash
   flutter build apk --split-per-abi
   ```

### Instalasi APK

**Metode 1: Transfer ke Device**
- Transfer file APK ke device Android
- Aktifkan "Install dari sumber tidak dikenal" di pengaturan
- Tap file APK untuk instalasi

**Metode 2: Install via USB**
```bash
flutter install
```

**Metode 3: Drag & Drop**
- Connect device via USB
- Drag file APK ke device untuk instalasi

---

## 📥 Download APK

**Link Build APK**: https://drive.google.com/drive/folders/1DYVO4R_nmrrzN-mgVEXqfta9mtW8XiMh?usp=drive_link

---

## 🏗️ Struktur Project

Aplikasi mengikuti pendekatan **Feature-First + Clean Architecture**:

```
lib
├───common                          # Resource global lintas fitur
│   ├───shared_provider             # Provider global
│   ├───shared_screen              # Screen global
│   ├───shared_widgets             # Widget reusable
│   └───utils                      # Fungsi helper
│
├───core                           # Fondasi aplikasi
│   ├───constant                   # Konstanta (rute, tema, warna)
│   ├───database                   # SQLite database helper
│   ├───model                      # Model data global
│   └───services                    # ML service (TensorFlow Lite)
│
└───features                       # Fitur utama (Clean Architecture)
    ├───scanner                    # Scanner penyakit tanaman
    │   ├───data                   # Layer data
    │   ├───domain                 # Business logic
    │   └───presentation           # UI + State Management
    │
    ├───journal                    # Jurnal tanaman
    │   ├───data
    │   ├───domain
    │   └───presentation
    │
    └───ensiklopedia              # Ensiklopedia tanaman
        ├───domain
        └───presentation
```

---

## 🎯 Fitur Detail

### 1. Scanner Tanaman
- **Input**: Foto daun tanaman (Kamera/Galeri)
- **Proses**: Prediksi menggunakan TensorFlow Lite
- **Output**: Jenis penyakit + confidence level
- **Dukungan**: 3 tanaman, 20+ penyakit

### 2. Jurnal Tanaman
- Riwayat scan dan deteksi
- Aktivitas perawatan (penyemprotan, pemupukan, dll)
- Tracking progress kesehatan tanaman
- Export data tanaman

### 3. Ensiklopedia
- Informasi tanaman (deskripsi, siklus hidup, suhu optimal)
- Detail penyakit (gejala, penyebab, solusi, pencegahan)
- Gambar contoh gejala
- Panduan budidaya

---

## 🔧 Troubleshooting

### Error: "SDK not found"
```bash
flutter doctor
# Ikuti instruksi yang diberikan
```

### Error: "Gradle sync failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error: "Permission denied" (Camera/Storage)
- Pastikan permission sudah ditambahkan di `AndroidManifest.xml`
- Restart aplikasi untuk meminta permission

### ML Model tidak terdeteksi
- Pastikan file `model.tflite` ada di `lib/core/services/machine_learning_model/`
- Lakukan `flutter clean` lalu `flutter pub get`

---

## 📝 Testing

```bash
# Run semua test
flutter test

# Run dengan coverage
flutter test --coverage
```


**📱 Nikmati pengalaman menanam yang lebih baik dengan NabatDex!**