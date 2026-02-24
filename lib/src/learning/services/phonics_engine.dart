import 'dart:typed_data';
import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../../core/config/app_config.dart';

class PhonicsAIEngine {
  late final GenerativeModel _model;

  PhonicsAIEngine() {
    _model = FirebaseVertexAI.instance.generativeModel(
      model: AppConfig.instance.vertexAiModelName,
    );
  }

  /// Takes raw audio bytes and a target phoneme (e.g. 'c' for cat)
  /// Returns a double representing the accuracy score (0.0 to 1.0)
  Future<double> checkPronunciation(
      Uint8List audioBytes, String targetPhoneme) async {
    try {
      final prompt = '''
      You are an expert phonics teacher. Listen to this audio clip of a young child 
      attempting to pronounce the phoneme: /$targetPhoneme/. 
      Grade their accuracy from 0.0 (completely wrong) to 1.0 (perfect articulation).
      Return ONLY the number.
      ''';

      // Attach audio as InlineDataPart
      final audioPart = InlineDataPart('audio/mp4', audioBytes); // Ensure format matches capture

      final content = [
        Content.multi([TextPart(prompt), audioPart])
      ];

      final response = await _model.generateContent(content);
      
      final resultString = response.text?.trim() ?? '0.0';
      return double.tryParse(resultString) ?? 0.0;
    } catch (e) {
      print('Error grading pronunciation: \$e');
      return 0.0;
    }
  }
}
