import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MLService {
  static Interpreter? _interpreter;
  static List<String>? _labels;
  
  static Future<void> _loadModel() async {
    if (_interpreter == null) {
      try {
        _interpreter = await Interpreter.fromAsset('lib/core/services/machine_learning_model/model.tflite');
        debugPrint('Model loaded successfully');
      } catch (e) {
        debugPrint('Error loading model: $e');
        rethrow;
      }
    }
    
    if (_labels == null) {
      try {
        final labelData = await rootBundle.loadString('lib/core/services/machine_learning_model/label.txt');
        _labels = labelData.split('\n').where((line) => line.isNotEmpty).toList();
        debugPrint('Labels loaded: ${_labels!.length} classes');
      } catch (e) {
        debugPrint('Error loading labels: $e');
        rethrow;
      }
    }
  }

  /// Load model dari data yang dikirim ke isolate
  static Future<void> _loadModelFromData(_IsolateModelData modelData) async {
    if (_interpreter == null && modelData.modelBytes != null) {
      try {
        _interpreter = Interpreter.fromBuffer(modelData.modelBytes!);
        debugPrint('Model loaded from isolate data');
      } catch (e) {
        debugPrint('Error loading model from data: $e');
        rethrow;
      }
    }
    
    if (_labels == null && modelData.labels != null) {
      _labels = modelData.labels;
      debugPrint('Labels loaded from isolate data: ${_labels!.length} classes');
    }
  }
  
  static const Map<String, String> _plantMapping = {
    'Potato': 'kentang',
    'Rice': 'padi',
    'Tomato': 'tomat',
  };
  
  static const Map<String, String> _diseaseMapping = {
    'Early_blight': 'early_blight',
    'Late_blight': 'late_blight',
    'Bacterial_Leaf_Blight': 'bacterial_leaf_blight',
    'Brown_Spot': 'brown_spot',
    'Healthy_Rice_Leaf': 'healthy',
    'Leaf_Blast': 'leaf_blast',
    'Leaf_scald': 'leaf_scald',
    'Narrow_Brown_Leaf_Spot': 'narrow_brown_spot',
    'Neck_Blast': 'neck_blast',
    'Rice_Hispa': 'rice_hispa',
    'Sheath_Blight': 'sheath_blight',
    'Tungro': 'tungro',
    'bacterial_leaf_blight': 'bacterial_leaf_blight',
    'brown_spot': 'brown_spot',
    'healthy': 'healthy',
    'leaf_blast': 'leaf_blast',
    'leaf_scald': 'leaf_scald',
    'narrow_brown_spot': 'narrow_brown_spot',
    'neck_blast': 'neck_blast',
    'rice_hispa': 'rice_hispa',
    'sheath_blight': 'sheath_blight',
    'tungro': 'tungro',
    'Bacterial_spot': 'bacterial_spot',
    'Leaf_Mold': 'leaf_mold',
    'Septoria_leaf_spot': 'septoria_leaf_spot',
    'Spider_mites_Two_spotted_spider_mite': 'spider_mites',
    'Tomato_YellowLeaf_Curl_Virus': 'yellow_leaf_curl_virus',
    'Target_Spot': 'target_spot',
    'Tomato_mosaic_virus': 'mosaic_virus',
  };

  Future<Map<String, dynamic>> predictImage(String imagePath) async {
    // Load model di main isolate terlebih dahulu
    await _loadModel();
    
    if (kDebugMode) {
      return await _runInIsolate(imagePath);
    } else {
      return await _predictImageInternal(imagePath);
    }
  }

  Future<Map<String, dynamic>> _runInIsolate(String imagePath) async {
    final receivePort = ReceivePort();
    
    // Siapkan data model untuk dikirim ke isolate
    final modelData = _IsolateModelData(
      modelBytes: _interpreter != null ? await _getModelBytes() : null,
      labels: _labels,
    );
    
    await Isolate.spawn(
      _isolateEntryPoint,
      _IsolateData(
        sendPort: receivePort.sendPort,
        imagePath: imagePath,
        modelData: modelData,
      ),
    );

    final result = await receivePort.first as Map<String, dynamic>;
    return result;
  }

  static Future<Uint8List> _getModelBytes() async {
    final modelData = await rootBundle.load('lib/core/services/machine_learning_model/model.tflite');
    return modelData.buffer.asUint8List();
  }

  static void _isolateEntryPoint(_IsolateData data) async {
    final result = await _predictImageInternal(data.imagePath, data.modelData);
    data.sendPort.send(result);
  }

  static Future<Map<String, dynamic>> _predictImageInternal(String imagePath, [_IsolateModelData? modelData]) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw Exception('Image file not found');
    }

    // Load model dan labels
    if (modelData != null) {
      // Di isolate, gunakan data yang dikirim
      await _loadModelFromData(modelData);
    } else {
      // Di main thread, load normal
      await _loadModel();
    }

    try {
      // Load dan preprocess image
      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Preprocess image untuk model
      final input = _preprocessImage(image);

      // Get model input/output shapes
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      
      debugPrint('Input shape: $inputShape');
      debugPrint('Output shape: $outputShape');

      // Prepare output tensor
      final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0).reshape(outputShape);

      // Run inference
      _interpreter!.run(input, output);

      // Parse hasil
      final results = _parseOutput(output);

      debugPrint('Prediction result: $results');

      return results;
    } catch (e) {
      debugPrint('❌ Error during inference: $e');
      rethrow;
    }
  }

  /// Preprocess image untuk model TFLite
  static List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize ke 256x256 jika belum
    img.Image resizedImage = image;
    if (image.width != 256 || image.height != 256) {
      resizedImage = img.copyResize(
        image,
        width: 256,
        height: 256,
        interpolation: img.Interpolation.linear,
      );
    }

    // Convert ke format yang dibutuhkan model: [1, 256, 256, 3]
    final input = List.generate(
      1,
      (_) => List.generate(
        256,
        (_) => List.generate(
          256,
          (_) => List.generate(3, (_) => 0.0),
        ),
      ),
    );

    // Normalize pixel values ke range 0-1
    for (int y = 0; y < 256; y++) {
      for (int x = 0; x < 256; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0; // Red
        input[0][y][x][1] = pixel.g / 255.0; // Green
        input[0][y][x][2] = pixel.b / 255.0; // Blue
      }
    }

    return input;
  }

  /// Parse output dari model
  static Map<String, dynamic> _parseOutput(List output) {
    if (_labels == null || _labels!.isEmpty) {
      throw Exception('Labels not loaded');
    }

    final probabilities = output[0] as List<double>;
    
    // Get index dengan confidence tertinggi
    int maxIndex = 0;
    double maxConfidence = probabilities[0];
    
    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxConfidence) {
        maxConfidence = probabilities[i];
        maxIndex = i;
      }
    }

    // Get predicted label
    final predictedLabel = _labels![maxIndex];
    debugPrint('Predicted label: $predictedLabel (confidence: $maxConfidence)');

    // Parse label untuk extract plant dan disease
    final parsedResult = _parseLabel(predictedLabel);

    return {
      'plantName': parsedResult['plantName'],
      'confidence': maxConfidence,
      'diseaseName': parsedResult['diseaseName'],
    };
  }

  static Map<String, dynamic> _parseLabel(String label) {
    String plantName = 'unknown';
    String? diseaseName;
    
    if (label.contains('___')) {
      final parts = label.split('___');
      if (parts.length == 2) {
        plantName = _plantMapping[parts[0]] ?? parts[0].toLowerCase();
        final diseasePart = parts[1];
        if (diseasePart.toLowerCase() == 'healthy') {
          diseaseName = null;
        } else {
          diseaseName = _diseaseMapping[diseasePart] ?? diseasePart.toLowerCase();
        }
      }
    } else if (label.startsWith('Tomato')) {
      plantName = 'tomat';
      final diseasePart = label.substring(7); // Remove "Tomato" prefix
      if (diseasePart.toLowerCase() == 'healthy') {
        diseaseName = null;
      } else {
        diseaseName = _diseaseMapping[diseasePart] ?? diseasePart.toLowerCase();
      }
    } else {
      debugPrint('Unexpected label format: $label');
    }

    return {
      'plantName': plantName,
      'diseaseName': diseaseName,
    };
  }

}

class _IsolateData {
  final SendPort sendPort;
  final String imagePath;
  final _IsolateModelData? modelData;

  _IsolateData({
    required this.sendPort,
    required this.imagePath,
    this.modelData,
  });
}

class _IsolateModelData {
  final Uint8List? modelBytes;
  final List<String>? labels;

  _IsolateModelData({
    this.modelBytes,
    this.labels,
  });
}

