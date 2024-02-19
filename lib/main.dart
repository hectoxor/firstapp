import 'package:flutter/material.dart';
import 'package:firstapp/openai_service.dart';
import 'package:firstapp/screens/history_screen.dart';
import 'package:firstapp/screens/settings_screen.dart';
import 'package:firstapp/screens/general_info.dart';
import 'package:firstapp/screens/maps.dart';
import 'package:firstapp/screens/sponsors.dart';
import 'package:firstapp/screens/inbox.dart';
import 'package:firstapp/screens/faqs.dart';
import 'package:firstapp/screens/ftc.dart';
import 'package:firstapp/screens/fll.dart';
import 'package:firstapp/screens/links.dart';
import 'package:firstapp/screens/events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';

// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';


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
}




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBnrv6H7j3X6DW4cF3ac3G9TSoyLiwgG_U",
      appId: "1:800455568342:android:85f3bce43a27f779a01277",
      messagingSenderId: "800455568342",
      projectId: "first-app-c9386",
    ),
  );
  try {
  await FirebaseAuth.instance.signInAnonymously();
} catch (e) {
  print("Failed to sign in anonymously: $e");
  
}
  FirebaseMessaging.instance.subscribeToTopic('announcements');

  runApp(OpenAIApp());
}


class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // Index to track selected menu item
  bool hasNewAnnouncement = false;

    @override
    void initState() {
      super.initState();
      requestNotificationPermission(); 
      print("MainLayout initState called");
      checkForNewAnnouncements();
    }

    void requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      // Show custom dialog before requesting permission
      showCustomRequestDialog(context);
    }
  }

  // Custom dialog to explain why you need notification permission
  void showCustomRequestDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Enable Notifications"),
        content: Text("We use notifications to keep you updated with the latest news, events, and announcements in FIRST Competitions in Central Asia. Would you like to enable notifications?"),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              Permission.notification.request(); // Request permission
            },
          ),
        ],
      ),
    );
  }

    void checkForNewAnnouncements() async {
      print("Checking for new announcements...");
      final prefs = await SharedPreferences.getInstance();
      final lastSeenTimestamp = prefs.getInt('lastSeenTimestamp') ?? 0;
      print("Last seen timestamp: $lastSeenTimestamp");
      final announcementsRef = FirebaseFirestore.instance.collection('announcements');

      announcementsRef.orderBy('dateSent', descending: true).limit(1).get().then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          final latestTimestamp = querySnapshot.docs.first.get('dateSent').millisecondsSinceEpoch;
          print("Latest announcement timestamp: $latestTimestamp");
          if (latestTimestamp > lastSeenTimestamp) {
            print("New announcement found.");
            setState(() => hasNewAnnouncement = true);
          } else {
            print("No new announcements.");
          }
        }
      });
    }


    // Update lastSeenTimestamp when user views announcements
    void updateLastSeenTimestamp() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('lastSeenTimestamp', DateTime.now().millisecondsSinceEpoch);
      setState(() => hasNewAnnouncement = false);
    }



  // List of widgets for each menu item
  final _pages = [
    QuestionScreen(),
    GeneralInfoScreen(),
    MapsScreen(),
    LinksScreen(),
    EventsScreen(),
    InboxScreen(),
    SponsorsScreen(),
    SettingsScreen(),
    HistoryScreen(),
    FaqsScreen(),
    FtcScreen(),
    FllScreen(),

    // Add other screens here...
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI FIRST Robotics App'),
      ),

      
      drawer: Drawer(
        
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Central Asia FTC 2024',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 119, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded( // Wrap the image in an Expanded widget
                      child: Image.asset(
                        'lib/img/first.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
            ),


       
            ListTile(
              leading: Icon(Icons.home),
              title: Text('AI Bot'),
              onTap: () => _selectPage(0),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('General Info'),
              onTap: () => _selectPage(1),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Maps'),
              onTap: () => _selectPage(2),
            ),
            // ListTile(
            //   leading: Icon(Icons.construction_sharp),
            //   title: Text('FTC'),
            //   onTap: () => _selectPage(10),
            // ),
            //   ListTile(
            //   leading: Icon(Icons.edit_square),
            //   title: Text('FLL'),
            //   onTap: () => _selectPage(11),
            // ),
            ListTile(
              leading: Icon(Icons.insert_link),
              title: Text('Links'),
              onTap: () => _selectPage(3),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Events'),
              onTap: () => _selectPage(4),
            ),
           ListTile(
              leading: Icon(Icons.mail),
              title: Text('Announcements'),
              trailing: hasNewAnnouncement ? Icon(Icons.circle, size: 10.0, color: Colors.red) : null,
              onTap: () {
                _selectPage(5); // Assuming InboxScreen is at index 5
                updateLastSeenTimestamp();
              },
            ),

            // ListTile(
            //   leading: Icon(Icons.handshake_sharp),
            //   title: Text('Sponsors'),
            //   onTap: () => _selectPage(6),
            // ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   onTap: () => _selectPage(7),
            // ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Chat History'),
              onTap: () => _selectPage(8),
            ),
             ListTile(
              leading: Icon(Icons.help),
              title: Text('FAQ'),
              onTap: () => _selectPage(9),
            ),
            // ... Add other menu items similarly
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Display selected screen
    );
  }
}


class OpenAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI FIRST Robotics App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainLayout(), // Use MainLayout as the home
    );
  }
}




class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  bool _isSubmitDisabled = false;  // New variable to control button state
  Timer? _timer;  // Timer to handle cooldown
  int _remainingTime = 0; 
  final _openAIService = OpenAIService('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');

  @override
  void initState() {
    super.initState();
    _checkCooldown();
  }

  void _checkCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    int lastMessageTimestamp = prefs.getInt('lastMessageTimestamp') ?? 0;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int cooldownTime = 60 * 1000; // 1 minute cooldown in milliseconds

    if (currentTime - lastMessageTimestamp < cooldownTime) {
      int remainingTime = cooldownTime - (currentTime - lastMessageTimestamp);
      _startCooldown(remainingTime ~/ 1000);
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();  // Cancel the timer if it's running
    super.dispose();
  }

   void _handleSubmit() async {
    if (_isSubmitDisabled) {
      // Show a message or handle accordingly
      return;
    }
    String question = _controller.text.trim();
    if (question.isNotEmpty) {
      setState(() {
        _isLoading = true; // Start loading
      });
      try {
        String answer = await _openAIService.askQuestion(question);
        await StorageService().saveQuestionAnswer(question, answer);  // Save to history
        setState(() {
          _response = answer;
          _isLoading = false; // Stop loading
        });
      } catch (e) {
        setState(() {
          _response = 'Error: ${e.toString()}';
          _isLoading = false; // Stop loading
        });
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastMessageTimestamp', DateTime.now().millisecondsSinceEpoch);
    _startCooldown(60);
  }


  void _startCooldown(int seconds) {
    _remainingTime = seconds;
    setState(() => _isSubmitDisabled = true);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        setState(() => _isSubmitDisabled = false);
        timer.cancel();
      }
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask AI Bot'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isSubmitDisabled)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'You can send the next message in $_remainingTime seconds',
                style: TextStyle(color: Colors.red),
              ),
            ),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Enter your question',
                border: OutlineInputBorder(),
              ),
              child: TextFormField(
                controller: _controller,
                maxLines: null, // Allows the input field to expand
                decoration: InputDecoration.collapsed(hintText: null),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_isLoading || _isSubmitDisabled) ? null : _handleSubmit,
              child: _isLoading ? CircularProgressIndicator() : Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _response.isNotEmpty 
              ? Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _response,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                )
              : Container(),
          ],
        ),
      ),
    );
  }
}


