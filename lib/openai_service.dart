import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class OpenAIService {
  final String apiKey; // Your OpenAI API key
  final String apiUrl = 'https://api.openai.com/v1/chat/completions'; // OpenAI API URL
  final firestore = FirebaseFirestore.instance;

  OpenAIService(this.apiKey);

  Future<String> askQuestion(String question) async {
    try {
      // Load text file content from assets
      final docSnapshot = await firestore.collection('info').doc('content').get();
      final fileContent = docSnapshot.data()?['text'] ?? '';
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo-0125',
          'max_tokens': 300,
          'messages': [
            {
              'role': 'system',
              'content': "You are a knowledgeable bot that answers any questions only regarding the event FIRST Championships (FTC and FLL) in Central Asia. Also you can answer questions regarding FIRST Tech Challenge and FIRST LEGO League 2023-2024. Say straight and say only facts, avoid answering other questions not related to FIRST. Your words must not exceed 200 words.",
            },
            {
              'role': 'system',
              'content': 'here is information about FIRST Competitions in Central Asia: $fileContent',
            },
            {
              'role': 'user',
              'content': question,
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to load data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in askQuestion: $e');
    }
  }
}
