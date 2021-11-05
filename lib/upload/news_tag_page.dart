import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daniknews/services/firebase_api.dart';
import 'dart:io';

class NewsTagPage extends StatefulWidget {
  const NewsTagPage({Key? key}) : super(key: key);

  @override
  _NewsTagPageState createState() => _NewsTagPageState();
}

class _NewsTagPageState extends State<NewsTagPage> {

  late GlobalKey<ScaffoldState> _globalKey;
  late int tagIndex;
  late String videoTag;
  late List<String> tag;
  late File fileUpload;
  late String title;

  @override
  void initState() {
    super.initState();

    _globalKey = GlobalKey<ScaffoldState>();
    tagIndex = 0;
    videoTag = 'unspecified';
    tag = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: buildTagChips(),
          ),
          ElevatedButton(
            onPressed: () {
              //FirestoreServices().addVideo(fileUpload, title);
            },
            child: Text("Upload"),
          )
        ],
      ),
    );
  }

  Widget buildTagChips() {
    return Wrap(
        children: List.generate(tag.length, (index) {
      return ChoiceChip(
        label: Text(tag[index]),
        selected: tagIndex == index,
        selectedColor: Colors.red,
        onSelected: (bool selected) {
          setState(() {
            tagIndex = selected ? index : 0;
            videoTag = tag[tagIndex];
            //FirestoreServices().uploadVideo(videoTag);
          });
        },
        backgroundColor: Colors.grey,
        labelStyle: TextStyle(color: Colors.white),
      );
    }));
  }
}
