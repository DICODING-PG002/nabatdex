import 'package:nabatdex/core/model/disease_model.dart';
import 'package:nabatdex/core/model/plant_model.dart';
import 'package:nabatdex/core/model/journal_entry_model.dart';
import 'package:nabatdex/core/model/plant_activity_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlantDatabaseHelper {
  static final PlantDatabaseHelper instance = PlantDatabaseHelper._internal();
  static Database? _database;

  PlantDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'nabatdex.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plant_master (
        plant_master_id INTEGER PRIMARY KEY AUTOINCREMENT,
        common_name TEXT NOT NULL,
        scientific_name TEXT NOT NULL,
        description TEXT NOT NULL,
        plant_type TEXT NOT NULL,
        life_cycle TEXT NOT NULL,
        optimal_temperature TEXT NOT NULL,
        irq_tips TEXT NOT NULL,
        cultivation_guide TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pest_disease_master (
        pest_disease_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        cause TEXT NOT NULL,
        control_solution TEXT NOT NULL,
        prevention_guide TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE plant_pest_disease_link (
        plant_master_id INTEGER NOT NULL,
        pest_disease_id INTEGER NOT NULL,
        PRIMARY KEY (plant_master_id, pest_disease_id),
        FOREIGN KEY (plant_master_id) REFERENCES plant_master(plant_master_id),
        FOREIGN KEY (pest_disease_id) REFERENCES pest_disease_master(pest_disease_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE plant_image (
        plant_image_id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_master_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        image_label TEXT NOT NULL,
        display_order INTEGER NOT NULL,
        FOREIGN KEY (plant_master_id) REFERENCES plant_master(plant_master_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE pest_disease_image (
        image_id INTEGER PRIMARY KEY AUTOINCREMENT,
        pest_disease_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        display_order INTEGER NOT NULL,
        FOREIGN KEY (pest_disease_id) REFERENCES pest_disease_master(pest_disease_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE journal_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_name TEXT NOT NULL,
        disease_name TEXT,
        confidence_level REAL NOT NULL,
        image_path TEXT NOT NULL,
        scan_date TEXT NOT NULL,
        is_healthy INTEGER NOT NULL,
        plant_id INTEGER,
        disease_id INTEGER,
        FOREIGN KEY (plant_id) REFERENCES plant_master(plant_master_id),
        FOREIGN KEY (disease_id) REFERENCES pest_disease_master(pest_disease_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE plant_activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        journal_entry_id INTEGER NOT NULL,
        activity_type TEXT NOT NULL,
        activity_name TEXT NOT NULL,
        notes TEXT NOT NULL,
        activity_date_time TEXT NOT NULL,
        FOREIGN KEY (journal_entry_id) REFERENCES journal_entries(id) ON DELETE CASCADE
      )
    ''');

    await _insertDummyData(db);

    // Plant images
    await db.insert('plant_image', {
      'plant_master_id': 1,
      'image_path': 'assets/image/plant/potato/kentang_hp.jpg',
      'image_label': 'Hasil Panen',
      'display_order': 1,
    });
    await db.insert('plant_image', {
      'plant_master_id': 1,
      'image_path': 'assets/image/plant/potato/kentang_sb.jpg',
      'image_label': 'Saat Berbunga',
      'display_order': 2,
    });
    await db.insert('plant_image', {
      'plant_master_id': 1,
      'image_path': 'assets/image/plant/potato/kentang_bt.jpg',
      'image_label': 'Bibit',
      'display_order': 3,
    });

    await db.insert('plant_image', {
      'plant_master_id': 2,
      'image_path': 'assets/image/plant/tomato/tomat_hp.jpg',
      'image_label': 'Hasil Panen',
      'display_order': 1,
    });
    await db.insert('plant_image', {
      'plant_master_id': 2,
      'image_path': 'assets/image/plant/tomato/tomat_sb.jpg',
      'image_label': 'Saat Berbunga',
      'display_order': 2,
    });
    await db.insert('plant_image', {
      'plant_master_id': 2,
      'image_path': 'assets/image/plant/tomato/tomat_bt.jpg',
      'image_label': 'Bibit',
      'display_order': 3,
    });

    await db.insert('plant_image', {
      'plant_master_id': 3,
      'image_path': 'assets/image/plant/paddy/padi_hp.jpg',
      'image_label': 'Hasil Panen',
      'display_order': 1,
    });
    await db.insert('plant_image', {
      'plant_master_id': 3,
      'image_path': 'assets/image/plant/paddy/padi_sb.jpg',
      'image_label': 'Saat Berbunga',
      'display_order': 2,
    });
    await db.insert('plant_image', {
      'plant_master_id': 3,
      'image_path': 'assets/image/plant/paddy/padi_bt.jpg',
      'image_label': 'Bibit',
      'display_order': 3,
    });

    // Insert disease images for new installations
    // Potato diseases
    await db.insert('pest_disease_image', {
      'pest_disease_id': 1, // Early_blight
      'image_path': 'assets/image/plant/potato/disease/potato_early_blight.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 2, // Late_blight
      'image_path': 'assets/image/plant/potato/disease/potato_late_blight.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 3, // healthy
      'image_path': 'assets/image/plant/potato/kentang_hp.jpg',
      'display_order': 1,
    });

    // Tomato diseases
    await db.insert('pest_disease_image', {
      'pest_disease_id': 4, // Bacterial_spot
      'image_path':
          'assets/image/plant/tomato/disease/tomato_bacterial_spot.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 5, // Early_blight
      'image_path':
          'assets/image/plant/tomato/disease/tomato_early_blight.webp',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 6, // Late_blight
      'image_path': 'assets/image/plant/tomato/disease/tomato_late_blight.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 7, // Leaf_Mold
      'image_path': 'assets/image/plant/tomato/disease/tomato_leaf_Mold.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 8, // Septoria_leaf_spot
      'image_path':
          'assets/image/plant/tomato/disease/tomato_septoria_leaf_spot.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 9, // Spider_mites_Two_spotted_spider_mite
      'image_path':
          'assets/image/plant/tomato/disease/tomato_spider_mites_two_spotted_spider_mite.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 10, // Target_Spot
      'image_path': 'assets/image/plant/tomato/disease/tomato__target_spot.jpg',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 11, // Tomato_YellowLeaf__Curl_Virus
      'image_path':
          'assets/image/plant/tomato/disease/tomato_yellowleaf_curl_virus.webp',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 12, // Tomato_mosaic_virus
      'image_path':
          'assets/image/plant/tomato/disease/tomato_tomato_mosaic_virus.png',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 13, // healthy
      'image_path': 'assets/image/plant/tomato/tomat_hp.jpg',
      'display_order': 1,
    });
  }

  Future<void> _insertDummyData(Database db) async {
    // PLANT MASTER
    await db.insert('plant_master', {
      'plant_master_id': 1,
      'common_name': 'Kentang',
      'scientific_name': 'Solanum tuberosum',
      'description':
          'Kentang adalah tanaman umbi bertepung dari famili nightshade Solanum tuberosum. Ini adalah salah satu tanaman pangan terpenting di dunia.',
      'plant_type': 'Umbi-umbian',
      'life_cycle': 'Semusim',
      'optimal_temperature': '15-20°C',
      'irq_tips': 'Jaga tanah tetap lembab namun tidak tergenang air (becek).',
      'cultivation_guide':
          'Tanam di tanah gembur yang memiliki drainase baik dengan kandungan bahan organik tinggi. Lakukan penyiangan secara rutin.',
    });

    await db.insert('plant_master', {
      'plant_master_id': 2,
      'common_name': 'Tomat',
      'scientific_name': 'Solanum lycopersicum',
      'description':
          'Tomat adalah buah dari tanaman berbunga Solanum lycopersicum. Meskipun secara botani adalah buah beri, tomat umumnya digunakan sebagai sayuran dalam masakan.',
      'plant_type': 'Sayuran Buah',
      'life_cycle': 'Semusim',
      'optimal_temperature': '20-25°C',
      'irq_tips':
          'Penyiraman teratur dan konsisten sangat penting. Hindari genangan air untuk mencegah busuk akar.',
      'cultivation_guide':
          'Tanam di tanah gembur dengan drainase baik. Berikan pupuk organik dan anorganik secara seimbang. Perlu penopang (ajir) agar tanaman tidak rebah.',
    });

    await db.insert('plant_master', {
      'plant_master_id': 3,
      'common_name': 'Padi',
      'scientific_name': 'Oryza sativa',
      'description':
          'Padi adalah tanaman sereal yang menjadi makanan pokok bagi lebih dari setengah populasi dunia, terutama di Asia. Padi dibudidayakan untuk diambil bijinya (gabah) yang diolah menjadi beras.',
      'plant_type': 'Sereal / Biji-bijian',
      'life_cycle': 'Semusim',
      'optimal_temperature': '25-30°C',
      'irq_tips':
          'Membutuhkan pengairan yang konsisten. Umumnya ditanam di lahan basah (sawah) dengan irigasi terkontrol. Fase pertumbuhan berbeda membutuhkan ketinggian air yang berbeda.',
      'cultivation_guide':
          'Tanam di tanah lempung berlumpur yang dapat menahan air. Pengelolaan air, pemupukan berimbang (N, P, K), dan pengendalian gulma adalah kunci sukses budidaya.',
    });

    // DISEASE MASTER

    // Potato Disease
    await db.insert('pest_disease_master', {
      'pest_disease_id': 1,
      'name': 'Bercak Kering (Early Blight)',
      'type': 'Penyakit',
      'description':
          'Penyakit jamur umum yang menyerang tanaman kentang, ditandai dengan bercak coklat tua konsentris pada daun.',
      'cause':
          'Disebabkan oleh jamur Alternaria solani. Jamur menginfeksi daun bagian bawah terlebih dahulu. Penyakit berkembang dalam kondisi hangat dan lembab (suhu optimal 24-29°C).',
      'control_solution':
          'Gunakan fungisida berbahan aktif mancozeb atau klorotalonil. Pangkas dan musnahkan daun yang terinfeksi. Jaga jarak tanam yang memadai.',
      'prevention_guide':
          'Lakukan rotasi tanaman minimal 2 tahun. Gunakan varietas tahan. Hindari penyiraman dari atas daun. Bersihkan sisa-sisa tanaman setelah panen.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 2,
      'name': 'Hawar Daun (Late Blight)',
      'type': 'Penyakit',
      'description':
          'Penyakit yang sangat merusak yang menyerang tanaman kentang dan tomat, menyebabkan daun dan umbi membusuk.',
      'cause':
          'Disebabkan oleh jamur Phytophthora infestans. Penyakit menyebar sangat cepat terutama dalam kondisi sejuk (15-20°C) dan kelembaban tinggi. Dapat menghancurkan tanaman dalam waktu singkat.',
      'control_solution':
          'Aplikasikan fungisida sistemik (misal: dimetomorf) secara preventif. Segera cabut dan musnahkan tanaman yang terinfeksi. Perbaiki drainase lahan.',
      'prevention_guide':
          'Tanam varietas yang tahan. Hindari jarak tanam terlalu rapat. Pantau cuaca untuk aplikasi fungisida preventif. Lakukan sanitasi lahan dengan ketat.',
    });

    // Tomat Disease
    await db.insert('pest_disease_master', {
      'pest_disease_id': 4,
      'name': 'Bercak Bakteri (Bacterial Spot)',
      'type': 'Penyakit',
      'description':
          'Penyakit bakteri umum yang menyerang daun, batang, dan buah tomat, menyebabkan bercak kecil basah yang kemudian menjadi gelap.',
      'cause':
          'Disebabkan oleh bakteri spesies Xanthomonas. Bakteri masuk melalui luka atau lubang alami pada daun. Penyakit menyebar melalui percikan air, angin, dan alat pertanian yang terkontaminasi.',
      'control_solution':
          'Semprot dengan bakterisida berbahan dasar tembaga. Buang bagian tanaman yang terinfeksi. Perbaiki sirkulasi udara. Hindari penyiraman dari atas.',
      'prevention_guide':
          'Gunakan benih bebas penyakit. Lakukan rotasi tanaman. Jaga jarak tanam yang ideal. Sanitasi alat-alat pertanian.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 5,
      'name': 'Bercak Kering (Early Blight)',
      'type': 'Penyakit',
      'description':
          'Penyakit jamur yang menyerang tanaman tomat, mirip dengan pada kentang. Menyebabkan bercak konsentris pada daun, batang, dan buah.',
      'cause':
          'Disebabkan oleh jamur Alternaria solani. Jamur menginfeksi daun bagian bawah terlebih dahulu. Berkembang dalam kondisi hangat dan lembab.',
      'control_solution':
          'Gunakan fungisida berbahan aktif mancozeb atau klorotalonil. Pangkas daun yang terinfeksi. Jaga jarak tanam dan gunakan mulsa plastik.',
      'prevention_guide':
          'Rotasi tanaman minimal 2 tahun. Gunakan varietas tahan. Hindari penyiraman dari atas. Bersihkan sisa-sisa tanaman.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 6,
      'name': 'Hawar Daun (Late Blight)',
      'type': 'Penyakit',
      'description':
          'Penyakit jamur yang sangat merusak pada tomat, sama seperti pada kentang. Menyebabkan bercak besar basah pada daun dan buah.',
      'cause':
          'Disebabkan oleh jamur Phytophthora infestans. Menyebar sangat cepat dalam kondisi sejuk dan kelembaban tinggi.',
      'control_solution':
          'Aplikasikan fungisida sistemik secara preventif. Segera musnahkan tanaman yang terinfeksi. Perbaiki drainase dan kurangi kelembaban.',
      'prevention_guide':
          'Tanam varietas tahan. Hindari jarak tanam rapat. Pantau kondisi cuaca. Lakukan sanitasi lahan.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 7,
      'name': 'Bercak Kapang Daun (Leaf Mold)',
      'type': 'Penyakit',
      'description':
          'Penyakit jamur yang menyerang daun tomat, terutama di rumah kaca atau area dengan kelembaban tinggi.',
      'cause':
          'Disebabkan oleh jamur Passalora fulva. Berkembang pada kelembaban tinggi (>85%) dan suhu 20-25°C. Daun menunjukkan bercak kuning di permukaan atas dan lapisan kapang abu-abu di bawahnya.',
      'control_solution':
          'Tingkatkan ventilasi dan sirkulasi udara. Kurangi kelembaban. Semprot fungisida berbahan dasar tembaga atau belerang. Pangkas daun bagian bawah.',
      'prevention_guide':
          'Jaga kelembaban di bawah 85%. Pastikan ventilasi baik. Gunakan varietas tahan. Hindari penyiraman berlebih.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 8,
      'name': 'Bercak Daun Septoria (Septoria Leaf Spot)',
      'type': 'Penyakit',
      'description':
          'Penyakit jamur yang menyebabkan banyak bercak kecil bundar dengan bagian tengah abu-abu pada daun tomat.',
      'cause':
          'Disebabkan oleh jamur Septoria lycopersici. Penyakit menyebar melalui percikan air dan alat yang terkontaminasi. Menyukai kondisi hangat dan lembab.',
      'control_solution':
          'Gunakan fungisida yang mengandung klorotalonil atau tembaga. Buang daun yang terinfeksi. Perbaiki sirkulasi udara. Hindari penyiraman dari atas.',
      'prevention_guide':
          'Gunakan benih bebas penyakit. Lakukan rotasi tanaman. Jaga jarak tanam. Sanitasi alat secara teratur.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 9,
      'name': 'Tungau Laba-laba (Tungau Bercak Dua)',
      'type': 'Hama',
      'description':
          'Hama umum yang menyerang tanaman tomat. Ukurannya sangat kecil dan sulit dilihat mata telanjang.',
      'cause':
          'Disebabkan oleh tungau Tetranychus urticae. Hama ini menghisap cairan tanaman, menyebabkan bintik-bintik kuning (stippling) dan daun menguning lalu kering. Berkembang pesat dalam kondisi panas dan kering.',
      'control_solution':
          'Semprot dengan akarisida (mitisida). Tingkatkan kelembaban (semprot air). Gunakan musuh alami (tungau predator).',
      'prevention_guide':
          'Jaga kelembaban yang cukup. Hindari pemupukan nitrogen berlebih. Pantau secara rutin. Gunakan varietas tahan jika ada.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 10,
      'name': 'Bercak Target (Target Spot)',
      'type': 'Penyakit',
      'description':
          'Penyakit jamur yang menyebabkan bercak bundar seperti "target" (lingkaran konsentris) pada daun tomat.',
      'cause':
          'Disebabkan oleh jamur Corynespora cassiicola. Penyakit menyebar melalui percikan air dan angin. Menyukai kondisi hangat dan lembab.',
      'control_solution':
          'Gunakan fungisida yang mengandung azoxystrobin atau klorotalonil. Buang bagian tanaman yang terinfeksi. Perbaiki sirkulasi udara.',
      'prevention_guide':
          'Gunakan benih bebas penyakit. Lakukan rotasi tanaman. Jaga jarak tanam. Hindari penyiraman dari atas.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 11,
      'name': 'Virus Keriting Daun Kuning Tomat (TYLCV)',
      'type': 'Virus',
      'description':
          'Penyakit virus yang menyebabkan daun menguning, keriting ke atas, dan tanaman menjadi kerdil.',
      'cause':
          'Disebabkan oleh Tomato Yellow Leaf Curl Virus (TYLCV) yang ditularkan oleh kutu kebul (Bemisia tabaci). Virus menyebabkan kerugian hasil panen yang parah.',
      'control_solution':
          'Kendalikan populasi kutu kebul dengan insektisida. Cabut dan musnahkan tanaman yang terinfeksi. Gunakan mulsa reflektif (perak).',
      'prevention_guide':
          'Gunakan bibit bebas virus. Kendalikan kutu kebul sejak dini. Bersihkan gulma yang menjadi inang virus. Tanam varietas tahan virus.',
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 12,
      'name': 'Virus Mosaik Tomat (ToMV)',
      'type': 'Virus',
      'description':
          'Penyakit virus yang menyebabkan pola mosaik (belang-belang hijau muda dan tua) pada daun tomat.',
      'cause':
          'Disebabkan oleh Tomato Mosaic Virus (ToMV). Ditularkan secara mekanis melalui alat, tangan, dan sisa-sisa tanaman yang terkontaminasi. Menyebabkan daun keriput dan distorsi.',
      'control_solution':
          'Tidak ada obat untuk virus. Cabut dan musnahkan tanaman terinfeksi. Sanitasi alat dengan ketat. Kendalikan hama vektor seperti kutu daun (aphid) jika ada.',
      'prevention_guide':
          'Gunakan benih bebas virus. Sanitasi alat di antara tanaman. Cuci tangan sebelum menangani tanaman. Musnahkan tanaman terinfeksi segera.',
    });

    // PLANT DISEASE LINK

    // Potato Disease Links (plant_master_id: 1)
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 1,
      'pest_disease_id': 1,
    }); // Early_blight
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 1,
      'pest_disease_id': 2,
    }); // Late_blight
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 1,
      'pest_disease_id': 3,
    }); // healthy

    // Tomato Disease Links (plant_master_id: 2)
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 4,
    }); // Bacterial_spot
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 5,
    }); // Early_blight
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 6,
    }); // Late_blight
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 7,
    }); // Leaf_Mold
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 8,
    }); // Septoria_leaf_spot
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 9,
    }); // Spider_mites
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 10,
    }); // Target_Spot
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 11,
    }); // TYLCV
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 12,
    }); // ToMV
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 13,
    }); // healthy

    // --- [ADDITION] Rice Disease Links (plant_master_id: 3) ---
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 3,
      'pest_disease_id': 14,
    }); // Kresek
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 3,
      'pest_disease_id': 15,
    }); // Blas
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 3,
      'pest_disease_id': 16,
    }); // Tungro
    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 3,
      'pest_disease_id': 17,
    }); // healthy
  }

  Future<PlantModel?> getPlantByName(String commonName) async {
    final db = await database;
    final results = await db.query(
      'plant_master',
      where: 'LOWER(common_name) = ?',
      whereArgs: [commonName.toLowerCase()],
    );

    if (results.isEmpty) return null;
    return PlantModel.fromMap(results.first);
  }

  Future<DiseaseModel?> getDiseaseByName(String diseaseName) async {
    final db = await database;

    final diseaseAliases = {
      'bacterial_leaf_blight': 'Kresek',
      'bacterial leaf blight': 'Kresek',
    };

    String searchName =
        diseaseAliases[diseaseName.toLowerCase()] ?? diseaseName;

    final formattedName = searchName
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    final results = await db.query(
      'pest_disease_master',
      where: 'LOWER(name) = ?',
      whereArgs: [formattedName.toLowerCase()],
    );

    if (results.isEmpty) {
      final fuzzyResults = await db.query(
        'pest_disease_master',
        where: 'LOWER(name) LIKE ?',
        whereArgs: ['%${formattedName.toLowerCase()}%'],
      );

      if (fuzzyResults.isEmpty) return null;
      return DiseaseModel.fromMap(fuzzyResults.first);
    }

    return DiseaseModel.fromMap(results.first);
  }

  Future<String?> getPlantImagePath(int plantId) async {
    final db = await database;
    final results = await db.query(
      'plant_image',
      where: 'plant_master_id = ?',
      whereArgs: [plantId],
      orderBy: 'display_order ASC',
      limit: 1,
    );

    if (results.isEmpty) return null;
    return results.first['image_path'] as String?;
  }

  Future<String?> getDiseaseImagePath(int diseaseId) async {
    final db = await database;
    final results = await db.query(
      'pest_disease_image',
      where: 'pest_disease_id = ?',
      whereArgs: [diseaseId],
      orderBy: 'display_order ASC',
      limit: 1,
    );

    if (results.isEmpty) return null;
    return results.first['image_path'] as String?;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> deleteDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'nabatdex.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<void> resetDatabase() async {
    await deleteDatabase();
    _database = await _initDatabase();
  }

  Future<int> saveJournalEntry(JournalEntryModel entry) async {
    final db = await database;
    final id = await db.insert(
      'journal_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<JournalEntryModel>> getAllJournalEntries() async {
    final db = await database;
    final results = await db.query(
      'journal_entries',
      orderBy: 'scan_date DESC',
    );

    return results.map((map) => JournalEntryModel.fromMap(map)).toList();
  }

  Future<JournalEntryModel?> getJournalEntryById(int id) async {
    final db = await database;
    final results = await db.query(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return JournalEntryModel.fromMap(results.first);
  }

  Future<int> deleteJournalEntry(int id) async {
    final db = await database;
    return await db.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> saveActivity(PlantActivityModel activity) async {
    final db = await database;
    if (activity.id == null) {
      return await db.insert(
        'plant_activities',
        activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(
        'plant_activities',
        activity.toMap(),
        where: 'id = ?',
        whereArgs: [activity.id],
      );
      return activity.id!;
    }
  }

  Future<List<PlantActivityModel>> getActivitiesByJournalId(
    int journalId,
  ) async {
    final db = await database;
    final results = await db.query(
      'plant_activities',
      where: 'journal_entry_id = ?',
      whereArgs: [journalId],
      orderBy: 'activity_date_time DESC',
    );

    return results.map((map) => PlantActivityModel.fromMap(map)).toList();
  }

  Future<PlantActivityModel?> getActivityById(int id) async {
    final db = await database;
    final results = await db.query(
      'plant_activities',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return PlantActivityModel.fromMap(results.first);
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete(
      'plant_activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Plant repository methods
  Future<List<PlantModel>> getAllPlants() async {
    final db = await database;
    final results = await db.query('plant_master', orderBy: 'common_name ASC');
    return results.map((map) => PlantModel.fromMap(map)).toList();
  }

  Future<PlantModel?> getPlantById(int id) async {
    final db = await database;
    final results = await db.query(
      'plant_master',
      where: 'plant_master_id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return PlantModel.fromMap(results.first);
  }

  Future<List<Map<String, dynamic>>> getPlantImages(int plantId) async {
    final db = await database;
    final results = await db.query(
      'plant_image',
      where: 'plant_master_id = ?',
      whereArgs: [plantId],
      orderBy: 'display_order ASC',
    );
    return results;
  }

  Future<List<Map<String, dynamic>>> getPlantDiseases(int plantId) async {
    final db = await database;
    final results = await db.rawQuery(
      '''
      SELECT pd.* FROM pest_disease_master pd
      INNER JOIN plant_pest_disease_link ppl ON pd.pest_disease_id = ppl.pest_disease_id
      WHERE ppl.plant_master_id = ?
      ORDER BY pd.name ASC
    ''',
      [plantId],
    );
    return results;
  }

  Future<List<Map<String, dynamic>>> getDiseaseImages(int diseaseId) async {
    final db = await database;
    final results = await db.query(
      'pest_disease_image',
      where: 'pest_disease_id = ?',
      whereArgs: [diseaseId],
      orderBy: 'display_order ASC',
    );
    return results;
  }
}
