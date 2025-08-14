import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<bool> init() => _speech.initialize();
  bool get isListening => _speech.isListening;

  Future<void> listen(void Function(String text) onResult) async {
    await _speech.listen(onResult: (r) => onResult(r.recognizedWords));
  }

  Future<void> stop() => _speech.stop();
}
