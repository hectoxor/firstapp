import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveQuestionAnswer(String question, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    history.add('$question - $answer');
    await prefs.setStringList('history', history);
  }

  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history'); // This removes the history entry entirely
  }
}


// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert'; 

// class StorageService {
//   Future<void> saveQuestionAnswer(String question, String answer) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<Map<String, String>> history = (prefs.getStringList('history') ?? [])
//         .map((item) => jsonDecode(item) as Map<String, dynamic>)
//         .map((item) => item.map((key, value) => MapEntry(key, value as String)))
//         .toList();
//     history.add({'question': question, 'answer': answer});
//     await prefs.setStringList('history', history.map((item) => jsonEncode(item)).toList());
//   }

//   Future<List<Map<String, String>>> getHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     return (prefs.getStringList('history') ?? [])
//         .map((item) => jsonDecode(item) as Map<String, dynamic>)
//         .map((item) => item.map((key, value) => MapEntry(key, value as String)))
//         .toList();
//   }
// }

