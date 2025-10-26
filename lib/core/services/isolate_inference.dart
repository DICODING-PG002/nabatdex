import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateInference {
  static const String _debugName = "ML_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: _debugName,
    );
    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final InferenceModel isolateModel in port) {
      try {
        final preprocessedImage = isolateModel.preprocessedImage;
        final input = [preprocessedImage];
        final output = [List<double>.filled(isolateModel.outputShape[1], 0.0)];
        final address = isolateModel.interpreterAddress;

        // Run inference using interpreter address
        final result = _runInference(input, output, address);

        // Parse the result
        final parsedResult = _parseOutput(
          result,
          isolateModel.labels,
        );

        isolateModel.responsePort.send(parsedResult);
      } catch (e) {
        debugPrint('Error in isolate inference: $e');
        isolateModel.responsePort.send({
          'error': e.toString(),
        });
      }
    }
  }

  static List<double> _runInference(
    List<List<List<List<double>>>> input,
    List<List<double>> output,
    int interpreterAddress,
  ) {
    Interpreter interpreter = Interpreter.fromAddress(interpreterAddress);
    interpreter.run(input, output);
    final result = output.first;
    return result;
  }

  static Map<String, dynamic> _parseOutput(
    List<double> probabilities,
    List<String> labels,
  ) {
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
    debugPrint('Predicted label: $predictedLabel (confidence: $maxConfidence)');

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
      debugPrint('Unexpected label format: $label');
    }

    return {
      'plantName': plantName,
      'diseaseName': diseaseName,
    };
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }
}

class InferenceModel {
  final List<List<List<double>>> preprocessedImage;
  final int interpreterAddress;
  final List<String> labels;
  final List<int> inputShape;
  final List<int> outputShape;
  late SendPort responsePort;

  InferenceModel(
    this.preprocessedImage,
    this.interpreterAddress,
    this.labels,
    this.inputShape,
    this.outputShape,
  );
}

