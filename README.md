# NabatDex

Aplikasi pendeteksi penyakit tanaman dengan memanfaatkan machine learning. Merupakan project capstone dari Bootcamp Dicoding Flutter Dev x Machine Learning

### Project Structure
Menggunakan pendekatan Feature-First + konsep clean architecture sebagaimana berikut:
``` 
lib
├───common                               # Berisi resource global lintas fitur
│   ├───shared_widgets                   # Widget UI reusable yang dapat digunakan di fitur manapun.
│   └───utils                            # Kumpulan fungsi pembantu tanpa efek samping (misal DateFormatter)
│
├───core                                 # Fondasi utama aplikasi
│   ├───constant                         # Kumpulan konstanta global (rute navigasi, warna tema, endpoint api, dll.)
│   ├───database                         # Setup & konfigurasi database SQLite
│   │   ├───migration                    # Script migrasi schema DB (ubah tabel, tambah kolom)
│   │   └───seeds                        # Data awal (master data) yang akan dimasukkan saat database pertama kali dibuat.
│   ├───network                          # Konfigurasi client HTTP, interceptor, base URL
│   └───services                         # Service global untuk fungsi pihak ketiga atau latar belakang. (misal notifikasi dll)
│
└───features                             # Fitur utama aplikasi, dipisah per domain
    └───[feature_name]                   # nama fitur seperti: journal, ensiklopedia, scanner
        ├───data                         # Layer data (akses DB/API, parsing model)
        │   ├───datasources              # Sumber data (SQLite, API, cache, kamera, dll.)
        │   ├───models                   # Model data untuk parsing JSON/DB
        │   └───repositories             # Implementasi repository dari 'kontrak'/interface di Repositories Domain
        │
        ├───domain                       # Layer domain (aturan bisnis murni)
        │   ├───entities                 # Entity/domain data object murni dari fitur
        │   ├───repositories             # Abstraksi repository (kontrak interface)
        │   └───usecases                 # Use case (aksi spesifik, misal: AddJournal, PredictPlant)
        │
        └───presentation                 # Layer UI + state management
            ├───providers                # State management (Provider)
            ├───screen                   # Halaman utama dari fitur
            └───widgets                  # Widget yang hanya digunakan pada fitur ini
```
