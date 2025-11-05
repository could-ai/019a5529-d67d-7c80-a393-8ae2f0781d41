import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isInitialized = await _speech.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) => print('Speech recognition status: $status'),
    );
    
    // Configure TTS
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }
  
  Future<void> startListening({
    required Function(String) onResult,
    required Function(String) onComplete,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_speech.isAvailable) {
      print('Speech recognition not available');
      return;
    }
    
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onComplete(result.recognizedWords);
        } else {
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );
  }
  
  Future<void> stopListening() async {
    await _speech.stop();
  }
  
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }
  
  Future<void> stop() async {
    await _tts.stop();
  }
  
  void dispose() {
    _speech.cancel();
    _tts.stop();
  }
}