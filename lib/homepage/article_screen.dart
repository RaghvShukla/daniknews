import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SizedBox(
            width: orientation == Orientation.portrait ? null : 500,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/img.jpg',
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Text(
                            "hello this is demo or dummy text of news article we need more content like this",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: FlutterLogo(
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("the times of india")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 22,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 20),
                                Icon(
                                  Icons.share,
                                  size: 22,
                                ),
                                SizedBox(width: 20),
                                Icon(
                                  Icons.messenger_outline,
                                  size: 22,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/img.jpg',
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Text(
                            "hello this is demo or dummy text of news article we need more content like this",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: FlutterLogo(
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("the times of india")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 22,
                                ),
                                SizedBox(width: 20),
                                Icon(
                                  Icons.share,
                                  size: 22,
                                ),
                                SizedBox(width: 20),
                                Icon(
                                  Icons.messenger_outline,
                                  size: 22,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/img.jpg',
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Text(
                            "hello this is demo or dummy text of news article we need more content like this",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: FlutterLogo(
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("the times of india")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 22,
                                ),
                                SizedBox(width: 20),
                                Icon(
                                  Icons.share,
                                  size: 22,
                                ),
                                SizedBox(width: 20),
                                Icon(
                                  Icons.messenger_outline,
                                  size: 22,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
