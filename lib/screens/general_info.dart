import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralInfoScreen extends StatelessWidget {
  // URL for the action when the image is tapped
  final String targetUrl = 'https://go.2gis.com/ukp70'; // Replace with your actual URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Info'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Themed AppBar Color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => _launchURL(targetUrl),
              child: Image.asset(
                'lib/img/location.png',
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 20),
            Text(
              'App info',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to the app for the Central Asian FIRST Competitions! This all-in-one platform offers 24/7 chatbot support for instant answers to your questions, real-time notifications to keep you updated on crucial announcements, comprehensive event details, live scores, and standings (during the matches). Plus, access exclusive STEM resources and connect with the FIRST community. Whether you are a participant, mentor, or fan, our app is designed to enhance your experience, keep you informed, and support your journey through the competition.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),

            // SizedBox(height: 20),
            // Text(
            //   'FTC Central Asia',
            //   style: TextStyle(
            //     fontSize: 24.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.deepOrange,
            //   ),
            // ),
            // SizedBox(height: 10),
            // Text(
            //   'The FIRST Tech Challenge (FTC) in Central Asia is a highly anticipated annual robotics competition that brings together the most skilled and innovative teams. This event is part of the global FIRST Tech Challenge, which aims to inspire young people to be science and technology leaders and innovators by engaging them in exciting mentor-based programs that build science, engineering, and technology skills, that inspire innovation, and that foster well-rounded life capabilities including self-confidence, communication, and leadership.',
            //   style: TextStyle(
            //     fontSize: 16.0,
            //     color: Colors.black87,
            //   ),
            // ),

            Text(
              'Overview of the Event',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Central Asian FIRST events gather teams from various countries within the region, including Kazakhstan, Uzbekistan, Kyrgyzstan, Tajikistan, and Turkmenistan, among others. Teams that have excelled in national or regional qualifiers are invited to compete, making this event a showcase of the strongest contenders in robotics from Central Asia.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),


            Text(
              'Примечание',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Это альфа версия приложения. Такие секции, как “maps и schedules” обновятся сразу, как фотографии карт будут доступны (вам придет оповещение об обновлении приложения). Вся информация в ИИ боте обновляется почти сразу же после официального релиза, а все новые ивенты и объявления приходят в inbox и events. Также, не забудьте включить уведомления, чтобы не пропустить важные оповещения. Всем удачных соревнований!',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            // ... other content ...
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // Handle the error, possibly showing a dialog or a snackbar
      print(e);
    }
  }

}
