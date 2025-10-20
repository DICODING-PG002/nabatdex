import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

class MLService {
  /// Label dari tanaman. 
  // TODO: Ubah ini ketika sudah ada model
  static const List<String> _plantLabels = ['tomato', 'padi', 'kentang'];
  
  /// TODO: Ubah ini ketika sudah ada model
  static const Map<String, List<String>> _plantDiseases = {
    'tomato': ['early_blight', 'late_blight', 'leaf_mold', 'septoria_leaf_spot'],
    'padi': ['bacterial_leaf_blight', 'brown_spot', 'leaf_blast'],
    'kentang': ['early_blight', 'late_blight'],
  };

  Future<Map<String, dynamic>> predictImage(String imagePath) async {
    if (kDebugMode) {
      return await _runInIsolate(imagePath);
    } else {
      return await _predictImageInternal(imagePath);
    }
  }

  Future<Map<String, dynamic>> _runInIsolate(String imagePath) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn(
      _isolateEntryPoint,
      _IsolateData(
        sendPort: receivePort.sendPort,
        imagePath: imagePath,
      ),
    );

    final result = await receivePort.first as Map<String, dynamic>;
    return result;
  }

  static void _isolateEntryPoint(_IsolateData data) async {
    final result = await _predictImageInternal(data.imagePath);
    data.sendPort.send(result);
  }

  static Future<Map<String, dynamic>> _predictImageInternal(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw Exception('Image file not found');
    }

    // ========================================================================
    // TODO: REPLACE THIS SECTION WITH TFLITE INFERENCE. Ubah section ini dengan TFlite interference
    //! Saat ini masih data DUMMY. Step by step dibawah ini agar tidak lupa
    // ========================================================================
    // 
    // Step 1: Load TFLite model (bisa di-cache di class level)
    // Contih: 
    // final interpreter = await Interpreter.fromAsset('assets/models/plant_disease_model.tflite');
    //
    // Step 2: Load dan preprocess image
    // Image sudah 256x256 dari provider, maka tinggal:
    // - Load image bytes
    // - Convert ke format yang dibutuhkan model (RGB, normalized, dll)
    // - Reshape sesuai input model (biasanya [1, 256, 256, 3])
    //
    // Step 3: Run inference
    // interpreter.run(inputTensor, outputTensor);
    //
    // Step 4: Parse output
    // - Get predicted class index dari output tensor
    // - Get confidence score
    // - Map ke plantName dan diseaseName sesuai label
    //
    // Step 5: Cleanup
    // interpreter.close();
    // ========================================================================

    //! DUMMY IMPLEMENTATION 
    //TODO: hapus ini nanti
    await Future.delayed(const Duration(seconds: 2));
    
    final random = _generatePseudoRandom(imagePath);
    final plantIndex = random % _plantLabels.length;
    final plantName = _plantLabels[plantIndex];
    
    final hasDisease = (random % 100) > 30;
    String? diseaseName;
    
    if (hasDisease && _plantDiseases.containsKey(plantName)) {
      final diseases = _plantDiseases[plantName]!;
      diseaseName = diseases[random % diseases.length];
    }

    final confidence = 0.65 + (random % 30) / 100;
    //! END DUMMY IMPLEMENTATION

    // Return format HARUS tetap seperti ini:
    return {
      'plantName': plantName,         // String: 'tomato' | 'padi' | 'kentang'
      'confidence': confidence,       // double: 0.0 - 1.0
      'diseaseName': diseaseName,    // String? : nama penyakit atau null jika sehat
    };
  }

  static int _generatePseudoRandom(String seed) {
    int hash = 0;
    for (int i = 0; i < seed.length; i++) {
      hash = ((hash << 5) - hash) + seed.codeUnitAt(i);
      hash = hash & hash;
    }
    return hash.abs();
  }
}

class _IsolateData {
  final SendPort sendPort;
  final String imagePath;

  _IsolateData({
    required this.sendPort,
    required this.imagePath,
  });
}

