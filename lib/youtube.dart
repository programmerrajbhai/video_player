import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrendingVideosPage extends StatefulWidget {
  @override
  _TrendingVideosPageState createState() => _TrendingVideosPageState();
}

class _TrendingVideosPageState extends State<TrendingVideosPage> {
  List videos = [];
  String selectedCategory = '10'; // Default category (Music)

  // Fetch Trending Videos Based on Selected Category
  Future<void> fetchTrendingVideos() async {
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&videoCategoryId=$selectedCategory&regionCode=US&maxResults=50&key=AIzaSyCbUcLeYWzSM-bBw7mmoYgMoYPvspjGDYI';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        videos = data['items'];


      });
    } else {
      throw Exception('Failed to load trending videos');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTrendingVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trending YouTube Videos')),
      body: Column(
        children: [
          // Dropdown for Selecting Category
          DropdownButton<String>(
            value: selectedCategory,
            items: [
              DropdownMenuItem(value: '10', child: Text('Music')),
              DropdownMenuItem(value: '17', child: Text('WWE')),
              DropdownMenuItem(value: '20', child: Text('Gaming')),
              DropdownMenuItem(value: '27', child: Text('Quran Recitation')),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                  fetchTrendingVideos();
                });
              }
            },
          ),
          Expanded(
            child: videos.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                final title = video['snippet']['title'];
                final thumbnailUrl =
                video['snippet']['thumbnails']['high']['url'];

                final videoId = video['id'] is Map ? video['id']['videoId'] : video['id'];
                print(videoId+"");


                return ListTile(
                  leading: Image.network(thumbnailUrl),
                  title: Text(title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(videoId: videoId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ YouTube Video Player
class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  VideoPlayerScreen({required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(autoPlay: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YouTube Video')),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TrendingVideosPage(),
  ));
}
