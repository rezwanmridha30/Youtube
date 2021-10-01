import 'package:flutter/material.dart';
import 'package:my_youtube_api/models/videos_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
   VideoPlayerScreen({required this.item });
   final Item item;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late bool _isPlayerReady;
  @override
  void initState() {
    super.initState();
    
    _isPlayerReady =false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.item.snippet.resourceId.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true
      ),
      )..addListener(_listener);
    
  }
  void _listener(){
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen){

    }
  }

  @override
  void deactivate(){
    _controller.pause();
    super.deactivate();    
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.snippet.title),
        ),
      body: Container(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,

          onReady: (){
            print('Player is ready.');

            _isPlayerReady = true;
          },
          ),
      ),
      
    );
  }
}