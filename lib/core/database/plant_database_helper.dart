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

    return await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.delete('plant_pest_disease_link');
      await db.delete('pest_disease_master');
      await db.delete('plant_master');
      
      await _insertDummyData(db);
    }
    
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS journal_entries (
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
    }
    
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS plant_activities (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          journal_entry_id INTEGER NOT NULL,
          activity_type TEXT NOT NULL,
          activity_name TEXT NOT NULL,
          description TEXT NOT NULL,
          activity_date TEXT NOT NULL,
          notes TEXT,
          FOREIGN KEY (journal_entry_id) REFERENCES journal_entries(id) ON DELETE CASCADE
        )
      ''');
    }
    
    if (oldVersion < 5) {
      await db.execute('DROP TABLE IF EXISTS plant_activities');
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
    }
    
    if (oldVersion < 6) {
      // Insert sample plant images
      await db.insert('plant_image', {
        'plant_master_id': 1,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('plant_image', {
        'plant_master_id': 1,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 2,
      });

      await db.insert('plant_image', {
        'plant_master_id': 1,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 3,
      });

      await db.insert('plant_image', {
        'plant_master_id': 1,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 4,
      });

      await db.insert('plant_image', {
        'plant_master_id': 2,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('plant_image', {
        'plant_master_id': 2,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 2,
      });

      await db.insert('plant_image', {
        'plant_master_id': 2,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 3,
      });

      await db.insert('plant_image', {
        'plant_master_id': 3,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('plant_image', {
        'plant_master_id': 3,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 2,
      });

      await db.insert('plant_image', {
        'plant_master_id': 3,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 3,
      });

      // Insert sample disease images
      await db.insert('pest_disease_image', {
        'pest_disease_id': 1,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('pest_disease_image', {
        'pest_disease_id': 2,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('pest_disease_image', {
        'pest_disease_id': 3,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('pest_disease_image', {
        'pest_disease_id': 4,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('pest_disease_image', {
        'pest_disease_id': 5,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('pest_disease_image', {
        'pest_disease_id': 6,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });

      await db.insert('pest_disease_image', {
        'pest_disease_id': 7,
        'image_path': 'assets/image/image_not_found.png',
        'display_order': 1,
      });
    }
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
        image_id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_master_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
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
    
    // Insert sample plant images for new installations
    await db.insert('plant_image', {
      'plant_master_id': 1,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('plant_image', {
      'plant_master_id': 1,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 2,
    });

    await db.insert('plant_image', {
      'plant_master_id': 1,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 3,
    });

    await db.insert('plant_image', {
      'plant_master_id': 1,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 4,
    });

    await db.insert('plant_image', {
      'plant_master_id': 2,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('plant_image', {
      'plant_master_id': 2,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 2,
    });

    await db.insert('plant_image', {
      'plant_master_id': 2,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 3,
    });

    await db.insert('plant_image', {
      'plant_master_id': 3,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('plant_image', {
      'plant_master_id': 3,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 2,
    });

    await db.insert('plant_image', {
      'plant_master_id': 3,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 3,
    });

    // Insert sample disease images for new installations
    await db.insert('pest_disease_image', {
      'pest_disease_id': 1,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 2,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 3,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 4,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 5,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 6,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });

    await db.insert('pest_disease_image', {
      'pest_disease_id': 7,
      'image_path': 'assets/image/image_not_found.png',
      'display_order': 1,
    });
  }

  Future<void> _insertDummyData(Database db) async {
    await db.insert('plant_master', {
      'plant_master_id': 1,
      'common_name': 'Tomat',
      'scientific_name': 'Solanum lycopersicum',
      'description': 'Tomat adalah tanaman dari keluarga Solanaceae yang menghasilkan buah merah bulat.',
      'plant_type': 'Sayuran Buah',
      'life_cycle': 'Tahunan',
      'optimal_temperature': '20-25°C',
      'irq_tips': 'Penyiraman teratur, hindari genangan air',
      'cultivation_guide': 'Tanam di tanah gembur dengan drainase baik, beri pupuk kandang'
    });

    await db.insert('plant_master', {
      'plant_master_id': 2,
      'common_name': 'Padi',
      'scientific_name': 'Oryza sativa',
      'description': 'Padi adalah tanaman biji-bijian yang menjadi makanan pokok sebagian besar penduduk dunia.',
      'plant_type': 'Biji-bijian',
      'life_cycle': 'Tahunan',
      'optimal_temperature': '22-32°C',
      'irq_tips': 'Sawah harus tergenang air selama masa pertumbuhan',
      'cultivation_guide': 'Tanam di lahan sawah dengan sistem irigasi yang baik'
    });

    await db.insert('plant_master', {
      'plant_master_id': 3,
      'common_name': 'Kentang',
      'scientific_name': 'Solanum tuberosum',
      'description': 'Kentang adalah tanaman umbi-umbian yang kaya karbohidrat.',
      'plant_type': 'Umbi',
      'life_cycle': 'Tahunan',
      'optimal_temperature': '15-20°C',
      'irq_tips': 'Tanah harus lembab tetapi tidak tergenang',
      'cultivation_guide': 'Tanam di dataran tinggi dengan tanah gembur'
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 1,
      'name': 'Hawar Daun',
      'type': 'Penyakit',
      'description': 'Penyakit yang disebabkan oleh jamur yang menyerang daun tanaman.',
      'cause': 'Disebabkan oleh jamur Phytophthora infestans. Jamur ini menyerang daun dan batang tanaman, menyebabkan bercak coklat kehitaman yang dapat meluas dengan cepat. Penyakit ini berkembang pesat pada kondisi lembap dan suhu dingin, terutama pada musim hujan.',
      'control_solution': 'Aplikasi fungisida berbasis tembaga secara rutin, buang dan musnahkan daun yang terinfeksi, atur jarak tanam untuk sirkulasi udara yang baik, hindari penyiraman berlebihan pada daun.',
      'prevention_guide': 'Gunakan varietas tahan penyakit, jaga kebersihan lahan dari sisa tanaman, hindari kelembaban berlebih dengan drainase yang baik, rotasi tanaman.'
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 2,
      'name': 'Kresek',
      'type': 'Penyakit',
      'description': 'Penyakit bakteri yang menyerang tanaman padi, ditandai dengan daun yang menguning dan mengering dari ujung.',
      'cause': 'Disebabkan oleh bakteri Xanthomonas oryzae pv. oryzae. Bakteri ini masuk ke tanaman padi melalui luka pada daun atau melalui pori-pori alami daun (hidatoda). Penyakit ini menyebar sangat cepat melalui percikan air hujan, irigasi, dan angin. Kondisi lembap dan hangat, serta pemupukan Nitrogen (N) yang berlebihan, akan memperparah serangan.',
      'control_solution': 'Gunakan varietas padi yang tahan terhadap penyakit kresek, lakukan pengairan secara intermiten (tidak terus menerus tergenang), kurangi dosis pupuk Nitrogen dan seimbangkan dengan Kalium. Aplikasi bakterisida berbahan aktif tembaga dapat dilakukan pada stadium awal serangan. Sanitasi lahan dengan membuang jerami dan sisa tanaman yang terinfeksi.',
      'prevention_guide': 'Gunakan benih sehat dan bersertifikat, hindari pemupukan Nitrogen berlebihan, atur sistem irigasi yang baik, lakukan rotasi varietas, jaga kebersihan saluran air dan pematang sawah.'
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 3,
      'name': 'Early Blight',
      'type': 'Penyakit',
      'description': 'Penyakit bercak daun awal yang menyerang tomat dan kentang.',
      'cause': 'Disebabkan oleh jamur Alternaria solani. Jamur ini menginfeksi daun bagian bawah terlebih dahulu, membentuk bercak konsentris berwarna coklat gelap. Penyakit berkembang pada kondisi hangat dan lembap dengan suhu optimal 24-29°C.',
      'control_solution': 'Aplikasi fungisida berbasis mankozeb atau klorotalonil, pemangkasan daun terinfeksi, atur jarak tanam yang cukup, mulsa plastik untuk mencegah percikan tanah ke daun.',
      'prevention_guide': 'Rotasi tanaman minimal 2 tahun, gunakan varietas tahan, hindari penyiraman dari atas, bersihkan sisa tanaman setelah panen.'
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 4,
      'name': 'Late Blight',
      'type': 'Penyakit',
      'description': 'Penyakit busuk daun yang sangat merusak pada tomat dan kentang.',
      'cause': 'Disebabkan oleh jamur Phytophthora infestans. Penyakit ini menyebar sangat cepat terutama pada kondisi dingin (15-20°C) dan lembap tinggi. Dapat menginfeksi seluruh bagian tanaman dalam waktu singkat.',
      'control_solution': 'Aplikasi fungisida sistemik secara preventif, buang tanaman terinfeksi segera, perbaiki drainase lahan, kurangi kelembapan dengan pemangkasan.',
      'prevention_guide': 'Tanam varietas tahan penyakit, hindari penanaman terlalu rapat, monitoring cuaca untuk aplikasi fungisida preventif, sanitasi lahan.'
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 5,
      'name': 'Leaf Mold',
      'type': 'Penyakit',
      'description': 'Penyakit jamur yang menyerang daun tomat, terutama di greenhouse.',
      'cause': 'Disebabkan oleh jamur Passalora fulva (Cladosporium fulvum). Berkembang pada kelembapan tinggi (>85%) dan suhu 20-25°C. Daun terinfeksi menunjukkan bercak kuning di permukaan atas dan lapisan jamur abu-abu di bawah.',
      'control_solution': 'Tingkatkan ventilasi dan sirkulasi udara, kurangi kelembapan, aplikasi fungisida berbasis tembaga atau sulfur, pemangkasan daun bagian bawah.',
      'prevention_guide': 'Jaga kelembapan di bawah 85%, atur ventilasi yang baik, gunakan varietas tahan, hindari penyiraman berlebihan.'
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 6,
      'name': 'Brown Spot',
      'type': 'Penyakit',
      'description': 'Penyakit bercak coklat pada daun padi yang dapat menurunkan hasil panen.',
      'cause': 'Disebabkan oleh jamur Bipolaris oryzae (Helminthosporium oryzae). Muncul sebagai bercak oval berwarna coklat pada daun. Penyakit ini berkembang pada tanaman yang kekurangan nutrisi, terutama pada tanah miskin Nitrogen.',
      'control_solution': 'Perbaiki nutrisi tanaman dengan pemupukan berimbang, aplikasi fungisida berbasis triklosiklazol, perbaiki manajemen air sawah, buang jerami terinfeksi.',
      'prevention_guide': 'Gunakan benih berkualitas dan sehat, pemupukan berimbang terutama Nitrogen dan Kalium, jaga keseimbangan air, varietas tahan penyakit.'
    });

    await db.insert('pest_disease_master', {
      'pest_disease_id': 7,
      'name': 'Leaf Blast',
      'type': 'Penyakit',
      'description': 'Penyakit blas yang menyerang daun padi, sangat merugikan.',
      'cause': 'Disebabkan oleh jamur Pyricularia oryzae (Magnaporthe oryzae). Membentuk bercak belah ketupat berwarna coklat dengan tepi coklat tua dan bagian tengah putih keabu-abuan. Menyebar cepat pada kondisi lembap dengan suhu 25-28°C.',
      'control_solution': 'Aplikasi fungisida berbasis trisiklazol atau kasugamisin, kurangi pemupukan Nitrogen berlebihan, atur pengairan intermiten, sanitasi lahan.',
      'prevention_guide': 'Tanam varietas tahan blas, pemupukan berimbang dengan penekanan pada Kalium dan Silika, hindari Nitrogen berlebihan, monitoring rutin.'
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 1,
      'pest_disease_id': 1,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 1,
      'pest_disease_id': 3,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 1,
      'pest_disease_id': 4,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 1,
      'pest_disease_id': 5,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 2,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 6,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 2,
      'pest_disease_id': 7,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 3,
      'pest_disease_id': 1,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 3,
      'pest_disease_id': 3,
    });

    await db.insert('plant_pest_disease_link', {
      'plant_master_id': 3,
      'pest_disease_id': 4,
    });

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
    
    String searchName = diseaseAliases[diseaseName.toLowerCase()] ?? diseaseName;
    
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
    return await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
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

  Future<List<PlantActivityModel>> getActivitiesByJournalId(int journalId) async {
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
    final results = await db.query(
      'plant_master',
      orderBy: 'common_name ASC',
    );
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
    final results = await db.rawQuery('''
      SELECT pd.* FROM pest_disease_master pd
      INNER JOIN plant_pest_disease_link ppl ON pd.pest_disease_id = ppl.pest_disease_id
      WHERE ppl.plant_master_id = ?
      ORDER BY pd.name ASC
    ''', [plantId]);
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


