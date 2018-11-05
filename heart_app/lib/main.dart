import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        //primarySwatch: Colors.blue,

        primaryColor:Color(0xFFEF9A9A),
        accentColor:Color(0xFFE57373),
        highlightColor: Color(0xFFEF5350),
        //: Color(0xFFFFEBEE), //Colors.white
      ),
      home: new MyHomePage(title: 'From Heart to Heart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      body: new Container(
        child: LoginScreen(
          backgroundColor1: Color(0xFFEF9A9A), //0xFF444152
          backgroundColor2: Color(0xFFE57373), //0xFF6f6c7d
          highlightColor: Color(0xFFEF5350), //0xfff65aa3
          foregroundColor: Color(0xFFFFEBEE), //Colors.white
          logo: new AssetImage("assets/images/full-bloom.png"),
        ),
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
