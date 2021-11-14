import 'package:daniknews/homepage/homepage.dart';
import 'package:daniknews/services/user_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: reddish,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.white,
  ));

  runApp(DanikNews());
}

class DanikNews extends StatelessWidget {
  const DanikNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: reddish,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: Homepage()//WriteArticlePage() //PreviewArticle()//SelectCategories(),
        );
  }
}





const MaterialColor reddish = MaterialColor(
  0xFFC62828,
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFF44336),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  },
);
