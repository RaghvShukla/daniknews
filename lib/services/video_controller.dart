import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoController extends StatefulWidget {
  const VideoController({Key? key, required this.videoController})
      : super(key: key);
  final VideoPlayerController videoController;

  @override
  _VideoControllerState createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  @override
  void initState() {
    widget.videoController
      ..initialize()
      ..play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return videoCard();
  }

  Widget videoCard() {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.videoController.value.isPlaying) {
            widget.videoController.pause();
          } else {
            widget.videoController.play();
          }
        });
      },
      child: AspectRatio(
          aspectRatio: widget.videoController.value.aspectRatio,
          child: VideoPlayer(widget.videoController)),
    );
  }
}
