import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "Why did you create this app",
      "answer": "To promote FIRST values, Robotics, and Technology. To enhance cohesion across all robotics teams and enthuasists"
    },
    {
      "question": "How do I know when there is a new announcement or event?",
      "answer": "On events and announcement pages. Also you will be notified if there is one"
    },
    {
      "question": "AI bot answers incorrectly. What should I do?",
      "answer": "You can send an error to telegram @enteneract. Also, try to avoid grammar | context errors, or any kind of texts that leads to confusion"
    },
    // Add more FAQs here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Adjusted AppBar color
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 4,
            child: ExpansionTile(
              title: Text(
                faqs[index]["question"]!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange, // Themed Text color for question
                ),
              ),
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    faqs[index]["answer"]!,
                    style: TextStyle(
                      color: Colors.black87, // Adjusted text color for answer
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
