import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(YtVideoPlayer());
}

class YtVideoPlayer extends StatefulWidget {
  const YtVideoPlayer({super.key});

  @override
  State<YtVideoPlayer> createState() => _YtVideoPlayerState();
}

class _YtVideoPlayerState extends State<YtVideoPlayer> {
  final videoUrl = 'https://www.youtube.com/embed/YF-lONFneXg';
  late YoutubePlayerController youtubePlayerController;

  @override
  void initState() {
    // TODO: implement initState

    final videoID = YoutubePlayer.convertUrlToId(videoUrl);

    youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoID!, flags: YoutubePlayerFlags(autoPlay: false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Youtube Player',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            YoutubePlayer(
              controller: youtubePlayerController,
              showVideoProgressIndicator: true,
              onReady: (){
                debugPrint('Ready');
              },

            )
          ],
        ),
      ),
    );
  }
}
