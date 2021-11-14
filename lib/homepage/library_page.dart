import 'dart:io';
import 'package:daniknews/upload/article/pick_file.dart';
import 'package:daniknews/upload/video/upload_video_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/select_category_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  File? image;
  late String title;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> selectImageFromGallery() async {
    title = 'noTitle';
    var selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage == null) return;

    setState(() {
      image = File(selectedImage.path);
      title = selectedImage.path.split('/image_picker').last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [

            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectCategories()),
                  );
                },
                child: const Text("select category")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PickImage()),
                  );
                },
                child: const Text("Pick Video")),
            ElevatedButton(
                onPressed: () async {
                  await selectImageFromGallery().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadVideoPage(image, title),
                      ),
                    ),
                  );
                },
                child: Icon(Icons.upload_rounded))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget> [

              CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
                radius: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
