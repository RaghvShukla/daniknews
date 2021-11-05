import 'package:daniknews/upload/article/write_article_page.dart';
import 'package:daniknews/upload/video/upload_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? image;
  late String? title;

  Future<void> selectImageFromGallery() async {
    title = 'noTitle';
    var selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadScreen(image, title!),
        ),
      );

      setState(() {
        image = File(selectedImage.path);
        title = selectedImage.path.split('/image_picker').last;
      });
    }
    ;
    return;
  }

  Future<void> selectVideoFromGallery() async {
    title = 'noTitle';
    var selectedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (selectedVideo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadScreen(image, title!),
        ),
      );

      setState(() {
        image = File(selectedVideo.path);
        title = selectedVideo.path.split('/image_picker').last;
      });
    }
    ;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //await selectImageFromGallery();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WriteArticlePage(
                          desc: '',
                          head: '',
                        ),
                      ),
                    );
                  },
                  child: Text('upload Article'),
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () async {
                    await selectVideoFromGallery();
                  },
                  child: Text('upload Video'),
                ),
              ],
            ),
          )),
    );
  }
}
