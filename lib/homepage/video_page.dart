import 'package:daniknews/services/video_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  PageController pageController = PageController();
  late List<VideoPlayerController> videoPlayerController;

  @override
  void initState() {
    videoPlayerController = <VideoPlayerController>[];

    FirebaseFirestore.instance
        .collection('videos')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        videoPlayerController
            .add(VideoPlayerController.network(element['url']));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videoCard(),
    );
  }

  Widget videoCard() {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoPlayerController.length,
        itemBuilder: (_, index) {
          return VideoController(
            videoController: videoPlayerController[index],
          );
        });
  }
}
