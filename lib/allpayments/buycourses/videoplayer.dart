import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  String link ="";
  SamplePlayer({required this.link});
  @override
  _SamplePlayerState createState() => _SamplePlayerState(link);
}

class _SamplePlayerState extends State<SamplePlayer> {
  var link;
  var flickManager;
  _SamplePlayerState(this.link);
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network(link),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager
      ),
    );
  }
}