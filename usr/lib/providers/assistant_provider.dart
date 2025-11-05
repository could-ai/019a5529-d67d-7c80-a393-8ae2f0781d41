import 'package:flutter/foundation.dart';
import '../services/speech_service.dart';
import '../services/ai_service.dart';
import '../services/device_control_service.dart';
import '../models/message.dart';

class AssistantProvider extends ChangeNotifier {
  final SpeechService _speechService = SpeechService();
  final AIService _aiService = AIService();
  final DeviceControlService _deviceControl = DeviceControlService();
  
  final List<Message> _messages = [];
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isSpeaking = false;
  String _currentTranscript = '';
  
  List<Message> get messages => _messages;
  bool get isListening => _isListening;
  bool get isProcessing => _isProcessing;
  bool get isSpeaking => _isSpeaking;
  String get currentTranscript => _currentTranscript;
  
  AssistantProvider() {
    _initializeServices();
  }
  
  Future<void> _initializeServices() async {
    await _speechService.initialize();
  }
  
  Future<void> startListening() async {
    if (_isListening) return;
    
    _isListening = true;
    _currentTranscript = '';
    notifyListeners();
    
    await _speechService.startListening(
      onResult: (transcript) {
        _currentTranscript = transcript;
        notifyListeners();
      },
      onComplete: (finalTranscript) async {
        _isListening = false;
        notifyListeners();
        
        if (finalTranscript.isNotEmpty) {
          await processUserInput(finalTranscript);
        }
      },
    );
  }
  
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    await _speechService.stopListening();
    _isListening = false;
    notifyListeners();
  }
  
  Future<void> processUserInput(String input) async {
    // Add user message
    _messages.add(Message(
      text: input,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
    
    _isProcessing = true;
    notifyListeners();
    
    try {
      // Get AI response
      final aiResponse = await _aiService.getResponse(input);
      
      // Execute device commands if detected
      final commandResult = await _deviceControl.executeCommand(input);
      
      String responseText = aiResponse;
      if (commandResult != null) {
        responseText = commandResult;
      }
      
      // Add assistant message
      _messages.add(Message(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      
      // Speak response
      await speakResponse(responseText);
      
    } catch (e) {
      _messages.add(Message(
        text: 'Sorry, I encountered an error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
  
  Future<void> speakResponse(String text) async {
    _isSpeaking = true;
    notifyListeners();
    
    await _speechService.speak(text);
    
    _isSpeaking = false;
    notifyListeners();
  }
  
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
  
  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }
}