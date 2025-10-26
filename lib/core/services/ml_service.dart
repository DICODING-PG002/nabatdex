import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'isolate_inference.dart';

class MLService {
  final modelPath = 'lib/core/services/machine_learning_model/model(1).tflite';
  final labelsPath = 'lib/core/services/machine_learning_model/label.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;

  late final IsolateInference isolateInference;
  bool _isInitialized = false;

  /// Load model with platform-specific optimizations
  Future<void> _loadModel() async {
    // Try loading with different configurations
    Exception? lastError;
    
    // Configuration 1: Try with platform delegates
    try {
      debugPrint('Attempting to load model with platform delegates...');
      final options = InterpreterOptions()
        ..threads = 4;
      
      if (Platform.isAndroid) {
        options.useNnApiForAndroid = true;
      } else if (Platform.isIOS) {
        options.useMetalDelegateForIOS = true;
      }
      
      interpreter = await Interpreter.fromAsset(modelPath, options: options);
      inputTensor = interpreter.getInputTensors().first;
      outputTensor = interpreter.getOutputTensors().first;
      
      debugPrint('✅ Interpreter loaded with platform delegates');
      debugPrint('Input shape: ${inputTensor.shape}');
      debugPrint('Output shape: ${outputTensor.shape}');
      return;
    } catch (e) {
      debugPrint('Failed to load with platform delegates: $e');
      lastError = e as Exception;
    }
    
    // Configuration 2: Try with basic options (fallback)
    try {
      debugPrint('Attempting to load model with basic options...');
      final options = InterpreterOptions()
        ..threads = 4;
      
      interpreter = await Interpreter.fromAsset(modelPath, options: options);
      inputTensor = interpreter.getInputTensors().first;
      outputTensor = interpreter.getOutputTensors().first;
      
      debugPrint('✅ Interpreter loaded with basic options');
      debugPrint('Input shape: ${inputTensor.shape}');
      debugPrint('Output shape: ${outputTensor.shape}');
      return;
    } catch (e) {
      debugPrint('Failed to load with basic options: $e');
      lastError = e as Exception;
    }
    
    // Configuration 3: Try without any options (last resort)
    try {
      debugPrint('Attempting to load model without options...');
      interpreter = await Interpreter.fromAsset(modelPath);
      inputTensor = interpreter.getInputTensors().first;
      outputTensor = interpreter.getOutputTensors().first;
      
      debugPrint('⚠️ Interpreter loaded without options (may be slower)');
      debugPrint('Input shape: ${inputTensor.shape}');
      debugPrint('Output shape: ${outputTensor.shape}');
      return;
    } catch (e) {
      debugPrint('Failed to load without options: $e');
      lastError = e as Exception;
    }
    
    // If all attempts failed, throw the last error
    throw Exception(
      'Failed to load model after trying multiple configurations. '
      'This might be due to incompatible model operators. '
      'Please check if your model is compatible with TFLite runtime version. '
      'Last error: $lastError'
    );
  }

  /// Load labels from text file
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n').where((line) => line.isNotEmpty).toList();
    debugPrint('✅ Labels loaded: ${labels.length} classes');
  }

  /// Initialize the ML service
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      await _loadLabels();
      await _loadModel();
      isolateInference = IsolateInference();
      await isolateInference.start();
      _isInitialized = true;
      debugPrint('ML Service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing ML Service: $e');
      rethrow;
    }
  }

  /// Predict image with isolate for better performance
  Future<Map<String, dynamic>> predictImage(String imagePath) async {
    try {
      if (!_isInitialized) {
        await init();
      }

      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      // Load and preprocess image in main isolate
      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      debugPrint('Image loaded: ${image.width}x${image.height}');

      // Preprocess image
      final preprocessedImage = _preprocessImage(image);

      // Use isolate for inference in debug mode, or run directly in release mode
      if (kDebugMode) {
        return await _runInferenceInIsolate(preprocessedImage);
      } else {
        // In release mode, run directly for better performance
        return await _runInferenceDirect(preprocessedImage);
      }
    } catch (e) {
      debugPrint('Error during prediction: $e');
      rethrow;
    }
  }

  /// Run inference in isolate (for debug mode)
  Future<Map<String, dynamic>> _runInferenceInIsolate(
    List<List<List<double>>> preprocessedImage,
  ) async {
    final isolateModel = InferenceModel(
      preprocessedImage,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );

    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(
      isolateModel..responsePort = responsePort.sendPort,
    );

    final result = await responsePort.first as Map<String, dynamic>;
    
    if (result.containsKey('error')) {
      throw Exception(result['error']);
    }
    
    return result;
  }

  /// Run inference directly in main isolate (for release mode or fallback)
  Future<Map<String, dynamic>> _runInferenceDirect(
    List<List<List<double>>> preprocessedImage,
  ) async {
    final input = [preprocessedImage];
    final output = [List<double>.filled(outputTensor.shape[1], 0.0)];

    interpreter.run(input, output);

    final result = output.first;
    
    // Parse the result
    return _parseOutput(result);
  }

  /// Preprocess image for model input
  List<List<List<double>>> _preprocessImage(img.Image image) {
    // Resize to 256x256 if needed
    img.Image resizedImage = image;
    if (image.width != 256 || image.height != 256) {
      resizedImage = img.copyResize(
        image,
        width: 256,
        height: 256,
        interpolation: img.Interpolation.linear,
      );
    }

    // Convert to format required by model: [256, 256, 3]
    final imageMatrix = List.generate(
      256,
      (y) => List.generate(
        256,
        (x) {
          final pixel = resizedImage.getPixel(x, y);
          // Normalize pixel values to 0-1 range
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        },
      ),
    );

    return imageMatrix;
  }

  /// Parse output from model
  Map<String, dynamic> _parseOutput(List<double> probabilities) {
    if (labels.isEmpty) {
      throw Exception('Labels not loaded');
    }

    // Get index with highest confidence
    int maxIndex = 0;
    double maxConfidence = probabilities[0];

    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxConfidence) {
        maxConfidence = probabilities[i];
        maxIndex = i;
      }
    }

    // Get predicted label
    final predictedLabel = labels[maxIndex];
    debugPrint('🎯 Predicted: $predictedLabel (confidence: ${(maxConfidence * 100).toStringAsFixed(2)}%)');

    // Parse label to extract plant and disease
    final parsedResult = _parseLabel(predictedLabel);

    return {
      'plantName': parsedResult['plantName'],
      'confidence': maxConfidence,
      'diseaseName': parsedResult['diseaseName'],
    };
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
      debugPrint('⚠️ Unexpected label format: $label');
    }

    return {
      'plantName': plantName,
      'diseaseName': diseaseName,
    };
  }

  /// Clean up resources
  Future<void> close() async {
    if (_isInitialized) {
      await isolateInference.close();
      interpreter.close();
      _isInitialized = false;
      debugPrint('✅ ML Service closed');
    }
  }
}
