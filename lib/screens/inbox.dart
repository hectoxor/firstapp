import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    _updateLastSeenTimestamp(); // Add this line
  }

  void _updateLastSeenTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSeenTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Custom AppBar color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('announcements').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              DateTime dateSent = (data['dateSent'] as Timestamp).toDate();
              String formattedDate = DateFormat('MMM d, yyyy, h:mm a').format(dateSent);

              return Card(
                margin: EdgeInsets.all(8),
                color: const Color.fromARGB(255, 255, 255, 255), // Light orange card background
                child: ListTile(
                  title: Text(data['title'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)), // Title with orange text
                  subtitle: Text("${data['message']}\nSent on $formattedDate", style: TextStyle(color: Colors.grey.shade600)), // Subtitle text color
                  isThreeLine: true,
                  onTap: () {}, // Implement onTap action if needed
                  // For an icon, uncomment the line below
                  // trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepOrange),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
