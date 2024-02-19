import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksScreen extends StatelessWidget {
  final List<Map<String, String>> links = [
    {
      "title": "FIRST KZ Official Telegram Channel - New official announcements",
      "url": "https://t.me/firstkazakhstan",
    },
    {
      "title": "FIRST KZ Community - Ask organizers & community any question regarding the event",
      "url": "https://t.me/firstkazakhstan/98",
    },
    {
      "title": "FTC Central Asia official FIRST website",
      "url": "https://ftc-events.firstinspires.org/2022/KZCMP",
    },
    {
      "title": "Official FIRST KZ Instagram",
      "url": "https://www.instagram.com/firstroboticskz/",
    },
    {
      "title": "Official FIRST KZ Website",
      "url": "https://firstrobotics.kz/",
    },
    {
      "title": "USTEM Youtube Channel - online streaming of qualification matches",
      "url": "https://www.youtube.com/channel/UCBXqD1Kn2u3mFnjHsHMMTKQ",
    },
    {
      "title": "App | Technical Support",
      "url": "https://t.me/enteneract",
    },
  ];
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Links'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Custom color for AppBar
      ),
      body: ListView.separated(
        itemCount: links.length,
        separatorBuilder: (context, index) => Divider(color: const Color.fromARGB(255, 197, 196, 196)),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              links[index]["title"]!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange, // Custom text color
              ),
            ),
            trailing: Icon(Icons.launch, color: Colors.blueGrey), // Icon for external link
            onTap: () => _launchURL(context, links[index]["url"]!),
          );
        },
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

}

