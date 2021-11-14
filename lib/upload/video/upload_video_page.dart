import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daniknews/homepage/homepage.dart';
import 'package:daniknews/services/firestore_api.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage(this.image, this.title, {Key? key}) : super(key: key);
  final File? image;
  final String title;

  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? videoPlayerController;
  var timeStamp = DateTime.now().microsecondsSinceEpoch.toString();
  final firestore = FirebaseFirestore.instance;

  late GlobalKey<ScaffoldState> _globalKey;
  late int _categoryIndex;
  late String videoCategory;
  late List<String> _categories;
  late File fileUpload;
  bool isCategorySelected = false;
  firebase_storage.UploadTask? task;
  late double progress;
  File? image;
  late String title;

  @override
  void initState() {
    super.initState();

    image = widget.image;
    title = widget.title;

    videoPlayerController = VideoPlayerController.file(image!)
      ..initialize()
      ..play();

    _globalKey = GlobalKey<ScaffoldState>();
    _categoryIndex = 0;
    videoCategory = 'unspecified';
    _categories = [
      "Unspecified",
      "Bollywood",
      "Business",
      "Education",
      "Entertainment",
      "International",
      "Politics",
      "Sports",
      "Technology",
    ];
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  Future uploadVideo(videoCategory, image, title) async {
    if (image == null) return;

    task = FirestoreApi.uploadVideo(videoCategory, image, title);
    setState(() {});
    if (task == null) return;

    final taskSnapshot = await task!.whenComplete(() {});
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    await firestore
        .collection('videos')
        .doc(title)
        .set({'url': downloadUrl, 'category': videoCategory});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? InkWell(
                    onTap: () {
                      setState(() {
                        if (videoPlayerController!.value.isPlaying) {
                          videoPlayerController!.pause();
                        } else {
                          videoPlayerController!.play();
                        }
                      });
                    },
                    child: SizedBox(
                      height: 400,
                      child: VideoPlayer(
                        videoPlayerController!,
                        //aspectRatio: videoPlayerController!.value.aspectRatio,
                      ),
                    ),
                  )

                // Image.file(
                //         image!,
                //         height: 300,
                //         width: 300,
                //       )
                : const FlutterLogo(),
            SizedBox(height: 20),
            buildChoiceChips(),
            SizedBox(height: 20),
            task != null
                ? uploadProgressIndicator(task!)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Homepage(),
                              ),
                            );
                          },
                          child: Text('cancel'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: ElevatedButton(
                          onPressed: isCategorySelected
                              ? () {
                                  uploadVideo(videoCategory, image, title);
                                }
                              : null,
                          child: const Text("Upload"),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildChoiceChips() {
    return Wrap(
      children: List.generate(
        _categories.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: ChoiceChip(
              label: Text(_categories[index]),
              selected: _categoryIndex == index,
              selectedColor: Colors.red[100],
              backgroundColor: Colors.grey[200],
              padding: EdgeInsets.all(12.0),
              labelStyle: const TextStyle(color: Colors.black),
              onSelected: (bool selected) {
                setState(() {
                  _categoryIndex = selected ? index : 0;
                  videoCategory = _categories[_categoryIndex];
                  isCategorySelected = true;
                });
                //FirebaseApi().createVideoCollection(videoCategory);
              },
            ),
          );
        },
      ),
    );
  }

  Widget uploadProgressIndicator(firebase_storage.UploadTask task) {
    return StreamBuilder<firebase_storage.TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            progress = (snap.bytesTransferred / snap.totalBytes).toDouble();
            final downloadProgress = (progress * 100).toStringAsFixed(2);

            return Column(
              children: [
                SizedBox(
                  width: 125,
                  height: 125,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      progress == 0.00
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.amber),
                              backgroundColor: Colors.amberAccent,
                              strokeWidth: 10,
                            )
                          : CircularProgressIndicator(
                              value: progress,
                              valueColor: AlwaysStoppedAnimation(
                                  progress == 1 ? Colors.green : Colors.orange),
                              backgroundColor: Colors.amberAccent,
                              strokeWidth: 10,
                            ),
                      Center(
                        child: progress == 1
                            ? const Icon(
                                Icons.check_rounded,
                                size: 55,
                                color: Colors.green,
                              )
                            : Text(
                                downloadProgress + '%',
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.orange),
                              ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                progress == 1
                    ? SizedBox(
                        height: 55,
                        width: 250,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage()),
                            );
                          },
                          child: Text('Go to Homepage'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            );
          } else {
            return SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: const [
                  CircularProgressIndicator(
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation(Colors.amber),
                  ),
                  Center(
                    child: Text('Connecting...'),
                  )
                ],
              ),
            );
          }
        });
  }
}
