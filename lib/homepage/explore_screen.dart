import 'package:daniknews/services/user_preferences.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<String> myCategory = [];
  List color = [
    Colors.purple[200],
    Colors.blue[200],
    Colors.amber[200],
    Colors.pink[200],
    Colors.teal[200],
    Colors.blueGrey[200],
    Colors.orange[300],
    Colors.deepPurple[200],
    Colors.lightGreen[300]
  ];

  @override
  void initState() {
    myCategory = UserPreferences.getCategories() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return myCategory.isEmpty
              ? Center(
                  child: Text('Please Select Category'),
                )
              : GridView.builder(
                  itemCount: myCategory.length,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          myCategory[index],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: color[index],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
