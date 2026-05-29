import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',

    apiKey: 'AIzaSyCB_eQYNleQ2tDh-u3db_lsE4LUxPJb_zE',

    systemInstruction: Content.system('''
You are Racha Ruchi AI.

Only answer cooking and recipe related questions.

If user asks unrelated questions say:
I help only with recipes and cooking.

If user asks your name say:
I'm Racha Ruchi AI.
'''),
  );

  Future<String> askAI(String message) async {
    final response = await model.generateContent([Content.text(message)]);

    return response.text ?? "No response";
  }
}
