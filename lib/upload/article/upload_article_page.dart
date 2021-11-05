import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daniknews/homepage/upload_page.dart';
import 'package:daniknews/services/firestore_api.dart';
import 'package:daniknews/upload/article/preview_article.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:io';

class UploadArticlePage extends StatefulWidget {
  const UploadArticlePage(
      {required this.image,
      required this.title,
      required this.headline,
      required this.description,
      Key? key})
      : super(key: key);

  final File? image;
  final String? title;
  final String headline;
  final String description;

  @override
  _UploadArticlePageState createState() => _UploadArticlePageState();
}

class _UploadArticlePageState extends State<UploadArticlePage>
    with SingleTickerProviderStateMixin {

  final firestore = FirebaseFirestore.instance;

  //late GlobalKey<ScaffoldState> _globalKey;
  late int _categoryIndex;
  late String category;
  late List<String> _categories;
  late File fileUpload;
  bool isCategorySelected = false;
  firebase_storage.UploadTask? task;
  late double progress;
  //File? image;
  late final String title;

  @override
  void initState() {
    super.initState();

    //image = widget.image;
    title = widget.title ?? '';

    //_globalKey = GlobalKey<ScaffoldState>();
    _categoryIndex = 0;
    category = 'unspecified';
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

  Future uploadArticle(category, image, title, headline, description) async {
    if (widget.image == null &&
        title.isEmpty &&
        widget.headline.isEmpty) {
      return;
    } else {
      task = FirestoreApi.uploadArticle(
        category,
        image,
        title,
        headline,
        description,
      );
      setState(() {});
      if (task == null) return;

      final taskSnapshot = await task!.whenComplete(() {});
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await firestore.collection('videos').doc(title).set({
        'url': downloadUrl,
        'category': category,
        'headline': widget.headline,
        'description': widget.description,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //key: _globalKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // widget.image != null
            //     ? Image.file(
            //         widget.image!,
            //         height: 200,
            //         width: 200,
            //       )
            //     : Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: const Icon(Icons.add_circle_outline, size: 100, color: Colors.black54,),
            //     ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(widget.headline, style: TextStyle(fontSize: 16),),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(widget.description, style: TextStyle(fontSize: 12),),
            // ),


            buildChoiceChips(),
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: size.width / 2 - 20,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewArticle(image: widget.image, title: title, headline: widget.headline, description: widget.description)));
                    },
                    child: Text('cancel'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isCategorySelected
                      ? () {
                          uploadArticle(category, widget.image, title,
                              widget.headline, widget.description);
                        }
                      : null,
                  child: const Text("Upload"),
                ),
              ],
            ),
            task != null ? uploadProgressIndicator(task!) : Container(),
          ],
        ),
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
            category = _categories[_categoryIndex];
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
