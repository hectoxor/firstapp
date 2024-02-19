import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';


class Event {
  final String name;
  final String description;
  final DateTime date;
  final String time;
  final String location;
  final String briefDescription;

  Event({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.briefDescription,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    Timestamp timestamp = data['date'] as Timestamp;
    return Event(
      name: data['name'],
      description: data['description'],
      date: timestamp.toDate(),
      time: data['time'],
      location: data['location'],
      briefDescription: data['briefDescription'],
    );
  }
}

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Adjusted AppBar color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('events').orderBy('date').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Event> events = snapshot.data!.docs.map((doc) {
            return Event.fromFirestore(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              Event event = events[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.orange.shade50, // Card background color
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      event.name,
                      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${DateFormat('MMM d, yyyy').format(event.date)} at ${event.time}\nLocation: ${event.location}\n${event.briefDescription}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    isThreeLine: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.deepOrange), // Arrow icon added here
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }
}




class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    // Theme data for consistent styling
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Consistent AppBar color with the theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Event Date
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  'Date: ${event.date}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Event Time
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  'Time: ${event.time}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Event Location
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.deepOrange),
                SizedBox(width: 8),
                Flexible( // To prevent overflow on smaller screens
                  child: Text(
                    'Location: ${event.location}',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Description Title
            Text(
              'Description:',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Description Text
            Text(
              event.description,
              style: TextStyle(fontSize: 16.0, height: 1.5), // Improved readability with line height
            ),
            // Optionally, add an image if the Event class is updated to include imageUrl
            // Add more content as needed...
          ],
        ),
      ),
    );
  }
}