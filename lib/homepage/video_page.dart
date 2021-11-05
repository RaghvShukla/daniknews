import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daniknews/services/user_preferences.dart';
import 'package:video_player/video_player.dart';
//import 'package:cached_video_player/cached_video_player.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<String>? myCategory = [];
  VideoPlayerController? videoPlayerController;
  //late CachedVideoPlayerController cachedVideoPlayerController;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    myCategory = UserPreferences.getCategories() ?? [];
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('videos').snapshots(),
          builder: (_, snapshot){
            return PageView.builder(
              //itemCount: snapshot.data.siz,
                itemBuilder: (_, index){
                  return Center(
                    child: Text('hello'),
                  );
                });
          },
        )

        // child: FutureBuilder<List<String>>(
        //   future: getData(),
        //   builder: (_, snapshots) {
        //     // return ListView.builder(
        //     //   itemCount: snapshots.data!.length,
        //     //     itemBuilder: (_, index) {
        //     //   return Padding(
        //     //     padding: const EdgeInsets.all(30.0),
        //     //     child: Text(snapshots.data![index]),
        //     //   );
        //     // });
        //     return PageView.builder(
        //         scrollDirection: Axis.vertical,
        //         controller: pageController,
        //         itemCount: snapshots.data!.length,
        //         itemBuilder: (_, index) {
        //           // return CachedVideoPlayer(CachedVideoPlayerController.network(
        //           //     snapshots.data![index])
        //           //   ..dataSource
        //           //   ..initialize()
        //           //   ..play()
        //           //   ..setLooping(true),
        //           // );
        //
        //           return CachedNetworkImage(
        //             imageUrl: snapshots.data![index],
        //             placeholder: (context, url) =>
        //                 const CircularProgressIndicator(),
        //           );
        //
        //           //   VideoPlayer(
        //           //   VideoPlayerController.network(snapshots.data![index])
        //           //     ..dataSource
        //           //     ..initialize()
        //           //     ..play()
        //           //     ..setLooping(true),
        //           // );
        //         });
        //   },
        // ),
      ),
    );
  }

  // Widget buildVideoPage(){
  //   return PageView.builder(
  //       itemBuilder: (_, index){
  //         return Center(
  //           child: VideoPlayerController.network(dataSource),
  //         )
  //       }
  //   );
  // }



  // List<String> dataList = [];
  // Future<List<String>> getData() async {
  //   for (var category in myCategory!) {
  //     FirebaseFirestore.instance
  //         .collection('news')
  //         .doc('videos')
  //         .collection(category)
  //         .snapshots()
  //         .listen((querySnapshot) {
  //       for (var doc in querySnapshot.docs) {
  //         dataList.add(doc.data()['url']);
  //       }
  //     });
  //   }
  //   return dataList;
  // }
}
