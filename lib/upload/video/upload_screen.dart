import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daniknews/services/firestore_api.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:io';

class UploadScreen extends StatefulWidget {
  const UploadScreen(this.image, this.title, {Key? key}) : super(key: key);
  final File? image;
  final String title;

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with SingleTickerProviderStateMixin {
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
        .set({
      'url': downloadUrl,
      'category' : videoCategory
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title),
          ),
          image != null
              ? Image.file(
                  image!,
                  height: 300,
                  width: 300,
                )
              : const FlutterLogo(),
          buildChoiceChips(),
          ElevatedButton(
            onPressed: isCategorySelected
                ? () {
                    uploadVideo(videoCategory, image, title);
                  }
                : null,
            child: const Text("Upload"),
          ),
          task != null ? uploadProgressIndicator(task!) : Container(),
        ],
      ),
    );
  }

  Widget buildChoiceChips() {
    return Wrap(
        children: List.generate(_categories.length, (index) {
      return ChoiceChip(
        label: Text(_categories[index]),
        selected: _categoryIndex == index,
        selectedColor: Colors.red,
        onSelected: (bool selected) {
          setState(() {
            _categoryIndex = selected ? index : 0;
            videoCategory = _categories[_categoryIndex];
            isCategorySelected = true;
          });
          //FirebaseApi().createVideoCollection(videoCategory);
        },
        backgroundColor: Colors.grey,
        labelStyle: const TextStyle(color: Colors.white),
      );
    }));
  }

  Widget uploadProgressIndicator(firebase_storage.UploadTask task) {
    return StreamBuilder<firebase_storage.TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            progress = (snap.bytesTransferred / snap.totalBytes).toDouble();
            final downloadProgress = (progress * 100).toStringAsFixed(2);
            return SizedBox(
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
