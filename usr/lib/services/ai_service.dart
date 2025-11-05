import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // TODO: Replace with actual AI API endpoint when Supabase is connected
  // This will be connected to Supabase Edge Function for AI processing
  final String _apiEndpoint = 'YOUR_AI_API_ENDPOINT';
  
  Future<String> getResponse(String userInput) async {
    // Mock AI responses for now - will be replaced with actual API calls
    return _getMockResponse(userInput);
  }
  
  String _getMockResponse(String input) {
    final lowercaseInput = input.toLowerCase();
    
    // Device control responses
    if (lowercaseInput.contains('lock') && lowercaseInput.contains('phone')) {
      return 'Locking your phone now.';
    }
    if (lowercaseInput.contains('unlock') && lowercaseInput.contains('phone')) {
      return 'Your phone is now unlocked.';
    }
    if (lowercaseInput.contains('brightness')) {
      return 'Adjusting screen brightness.';
    }
    if (lowercaseInput.contains('volume')) {
      return 'Adjusting volume level.';
    }
    if (lowercaseInput.contains('wifi') || lowercaseInput.contains('wi-fi')) {
      return 'Opening WiFi settings.';
    }
    if (lowercaseInput.contains('bluetooth')) {
      return 'Opening Bluetooth settings.';
    }
    if (lowercaseInput.contains('open') || lowercaseInput.contains('launch')) {
      return 'Opening the requested app.';
    }
    if (lowercaseInput.contains('call')) {
      return 'Opening phone dialer.';
    }
    if (lowercaseInput.contains('message') || lowercaseInput.contains('text')) {
      return 'Opening messaging app.';
    }
    if (lowercaseInput.contains('camera')) {
      return 'Opening camera.';
    }
    if (lowercaseInput.contains('alarm') || lowercaseInput.contains('timer')) {
      return 'Opening clock app.';
    }
    
    // General responses
    if (lowercaseInput.contains('hello') || lowercaseInput.contains('hi')) {
      return 'Hello! I\'m your AI assistant. I can control your phone, open apps, adjust settings, and much more. How can I help you today?';
    }
    if (lowercaseInput.contains('help') || lowercaseInput.contains('what can you do')) {
      return 'I can help you with:\n• Locking and unlocking your phone\n• Opening apps\n• Adjusting settings (WiFi, Bluetooth, volume, brightness)\n• Making calls and sending messages\n• Setting alarms and timers\n• And much more! Just ask me anything.';
    }
    
    return 'I understand you said: "$input". I\'m processing your request. Once connected to the AI backend, I\'ll be able to help you with more complex tasks.';
  }
  
  // Future implementation with actual API
  Future<String> _callAIAPI(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse(_apiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': userInput,
          'context': 'device_assistant',
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'Sorry, I couldn\'t process that.';
      }
      
      return 'Sorry, I\'m having trouble connecting to the AI service.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}