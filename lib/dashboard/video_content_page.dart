import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class VideoSection extends StatefulWidget {
  @override
  _VideoSectionState createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  List<Map<String, String>> staticVideos = [
    {
      'title': 'Inspirational Journey',
      'url': 'https://youtu.be/2Sm0gy-q8SI?si=Hpp7xBUaPV1IX87H',
      'thumbnail': 'assets/images/video1.jpg',
    },
    {
      'title': 'The Path to Success',
      'url': 'https://youtu.be/wni1vh35wxY?si=UspVaxObOM5Umn65',
      'thumbnail': 'assets/images/video2.jpg',
    },
    {
      'title': 'Mindful Moments',
      'url': 'https://youtu.be/D97zRAqseyY?si=Pz_S5Ix7humxO9kc',
      'thumbnail': 'assets/images/video3.jpg',
    },
    {
      'title': 'Growth and Ambition',
      'url': 'https://youtu.be/bXu-vL9PKy8?si=yP7FO8oBwrPVRb2V',
      'thumbnail': 'assets/images/video4.jpg',
    },
    {
      'title': 'Awakening the Mind',
      'url': 'https://youtu.be/g_uFX1Uayew?si=u9OgN67OpzNeWzqC',
      'thumbnail': 'assets/images/video5.jpg',
    },
  ];

  List<Map<String, String>> videos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  // Load saved videos from SharedPreferences
  void _loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? videoData = prefs.getString('videos');
    if (videoData != null) {
      setState(() {
        videos = List<Map<String, String>>.from(json.decode(videoData));
      });
    }
  }

  // Save videos to SharedPreferences
  void _saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('videos', json.encode(videos));
  }

  // Add a new video with custom thumbnail
  void _addNewVideo(String title, String url, String thumbnailPath) {
    setState(() {
      videos.add({
        'title': title,
        'url': url,
        'thumbnail': thumbnailPath,
      });
    });
    _saveVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motivational Videos'),
      ),
      body: ListView.builder(
        itemCount: staticVideos.length + videos.length,
        itemBuilder: (context, index) {
          // Show static videos first, followed by user-added videos
          final video = index < staticVideos.length
              ? staticVideos[index]
              : videos[index - staticVideos.length];

          return GestureDetector(
            onTap: () {
              final url = video['url'];
              if (url != null) {
                _launchURL(url);
              }
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumbnail(video['thumbnail']!),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      video['title']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVideoDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to display the thumbnail (from assets or file)
  Widget _buildThumbnail(String thumbnail) {
    if (thumbnail.startsWith('assets/')) {
      return Image.asset(
        thumbnail,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(thumbnail),
        fit: BoxFit.cover,
      );
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to show a dialog box for adding a new video
  void _showAddVideoDialog(BuildContext context) {
    String title = '';
    String url = '';
    String? thumbnailPath;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add a New Video'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Video Title'),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'YouTube URL'),
                    onChanged: (value) {
                      url = value;
                    },
                  ),
                  SizedBox(height: 10),
                  thumbnailPath == null
                      ? TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Select Thumbnail'),
                    onPressed: () async {
                      final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          thumbnailPath = pickedFile.path;
                        });
                      }
                    },
                  )
                      : Image.file(
                    File(thumbnailPath!),
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    if (title.isNotEmpty && url.isNotEmpty && thumbnailPath != null) {
                      _addNewVideo(title, url, thumbnailPath!);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
