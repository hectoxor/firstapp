import 'package:flutter/material.dart';
import 'package:firstapp/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService storageService = StorageService();
  Future<List<String>>? historyFuture;

  @override
  void initState() {
    super.initState();
    historyFuture = storageService.getHistory();
  }

  void refreshHistory() {
    setState(() {
      historyFuture = storageService.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await storageService.clearHistory();
              refreshHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('History cleared')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: storageService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
              );
            },
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:openai_flutter_app/storage_service.dart';

// class HistoryScreen extends StatelessWidget {
//   final StorageService storageService = StorageService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('History'),
//       ),
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: storageService.getHistory(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No history found.'));
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               var item = snapshot.data![index];
//               return ListTile(
//                 title: Text('Your question: ${item['question']}'),
//                 subtitle: Text("AI's response: ${item['answer']}"),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

