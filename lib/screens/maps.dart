import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MapsScreen extends StatelessWidget {
  final String mapImageUrl = 'lib/img/map.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () => _openImage(context, mapImageUrl),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    mapImageUrl,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.zoom_out_map,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FtcMapScreen()),
                  );
                },
                child: Text('FTC Pit Map'),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FllMapScreen()),
                  );
                },
                child: Text('FLL Pit Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openImage(BuildContext context, String imageUrl) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => PhotoViewScreen(imageUrl: imageUrl),
    ));
  }
}


class FtcMapScreen extends StatelessWidget {
  final String ftcMapImageUrl = 'lib/img/map.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FTC Pit Map')),
      body: Center(
        child: GestureDetector(
          onTap: () => _openImage(context, ftcMapImageUrl),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                ftcMapImageUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.zoom_out_map,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImage(BuildContext context, String imageUrl) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => PhotoViewScreen(imageUrl: imageUrl),
    ));
  }
}


class FllMapScreen extends StatelessWidget {
  final String fllMapImageUrl = 'lib/img/map.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FLL Pit Map')),
      body: Center(
        child: GestureDetector(
          onTap: () => _openImage(context, fllMapImageUrl),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                fllMapImageUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.zoom_out_map,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImage(BuildContext context, String imageUrl) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => PhotoViewScreen(imageUrl: imageUrl),
    ));
  }
}


class PhotoViewScreen extends StatelessWidget {
  final String imageUrl;

  PhotoViewScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Zoom')),
      body: Container(
        child: PhotoView(
          imageProvider: AssetImage(imageUrl),
        ),
      ),
    );
  }
}
