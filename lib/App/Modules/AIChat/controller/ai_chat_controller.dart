import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:racharuchi/App/Models/AIChat/chat_message_model.dart';

class AIChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  var isTyping = false.obs;

  final TextEditingController messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  final List<String> suggestedPrompts = [
    'What can I make with eggs?',
    'Quick dinner recipes',
    'Healthy breakfast ideas',
    'Vegan recipe suggestions',
    'How to make biryani?',
    'Paneer dishes for lunch',
  ];

  // Your Gemini API Key
  final String apiKey = 'AIzaSyCB_eQYNleQ2tDh-u3db_lsE4LUxPJb_zE';

  @override
  void onInit() {
    super.onInit();
    _addWelcomeMessage();
    _testAvailableModels(); // Test which models are available
  }

  void _testAvailableModels() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
        ),
      );
      print('=== AVAILABLE MODELS ===');
      print(response.body);
      print('========================');
    } catch (e) {
      print('Error listing models: $e');
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message:
          "Hello! I'm your AI Recipe Assistant. 🍳\n\nI can help you with:\n• Recipe suggestions\n• Cooking tips and techniques\n• Ingredient substitutions\n• Meal planning ideas\n• Dietary restrictions\n\nWhat would you like to cook today?",
      isUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
    messages.add(welcomeMessage);
  }

  void sendMessage({String? customMessage}) async {
    final String messageText = customMessage ?? messageController.text.trim();
    if (messageText.isEmpty) return;

    if (customMessage == null) {
      messageController.clear();
    }

    // Add user message
    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: messageText,
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
    messages.add(userMessage);
    _scrollToBottom();

    // Show loading states
    isTyping.value = true;
    isLoading.value = true;

    try {
      final aiResponse = await _getGeminiResponse(messageText);

      isTyping.value = false;
      isLoading.value = false;

      final aiMessage = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );
      messages.add(aiMessage);
      _scrollToBottom();
    } catch (e) {
      print('Error in sendMessage: $e');
      isTyping.value = false;
      isLoading.value = false;

      final errorMessage = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message:
            "⚠️ API Error: ${e.toString()}\n\nPlease check the logs for more details.",
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.error,
      );
      messages.add(errorMessage);
      _scrollToBottom();
    }
  }

  Future<String> _getGeminiResponse(String userMessage) async {
    // Try different model names and API versions

    // Option 1: Try with v1 (not v1beta) and gemini-pro
    final urlsToTry = [
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey',
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=$apiKey',
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$apiKey',
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$apiKey',
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
    ];

    for (var url in urlsToTry) {
      try {
        print('Trying URL: $url');

        final requestBody = {
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "You are a helpful recipe and cooking assistant. Provide concise, practical cooking advice. User question: $userMessage",
                },
              ],
            },
          ],
        };

        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        print(
          'Response status for ${url.split('?')[0]}: ${response.statusCode}',
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text = data['candidates'][0]['content']['parts'][0]['text'];
          print('✅ Success with URL: $url');
          return text.trim();
        } else if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['candidates'][0]['content']['parts'][0]['text'].trim();
        }
      } catch (e) {
        print('Error with URL $url: $e');
        continue;
      }
    }

    // If all URLs fail, return a clear error message
    return "⚠️ **Gemini API Error**\n\nCould not connect to Gemini API. Please check:\n\n1. Your internet connection\n2. API key validity\n3. API quotas\n\nCheck the console logs for more details.";
  }

  void clearChat() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              messages.clear();
              _addWelcomeMessage();
              Get.back();
              Get.snackbar(
                'Chat Cleared',
                'Chat history has been cleared',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void retryMessage(ChatMessageModel message) {
    final index = messages.indexOf(message);
    if (index > 0 && messages[index - 1].isUser) {
      messages.removeAt(index);
      sendMessage(customMessage: messages[index - 1].message);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void useSuggestedPrompt(String prompt) {
    messageController.text = prompt;
    sendMessage();
  }

  @override
  void onClose() {
    messageController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
