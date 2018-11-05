import 'package:flutter/material.dart';

import '../wrappers/aws.dart';
import 'timeline.dart';
//import '../ui/simple_round_button.dart';

class SignUpScreen extends StatefulWidget {
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;

  SignUpScreen({Key k,
    this.backgroundColor1,
    this.backgroundColor2,
    this.highlightColor,
    this.foregroundColor}) ;

  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {

  TextEditingController _emailEditor;
  TextEditingController _passwordEditor;
  TextEditingController _repeatedPasswordEditor;


  String _language = 'en';
  List<String> _languages = <String>[
    'en',
    'ar',
    'fr'
  ];


  @override
  void initState() {
    _emailEditor = new TextEditingController();
    _passwordEditor = new TextEditingController();
    _repeatedPasswordEditor = new TextEditingController();
  }

    void _signUp(BuildContext context) {
      AWS awsWrapper = new AWS();
      awsWrapper
        .cognitoSignUp(
            userEmail: _emailEditor.text, password: _passwordEditor.text, language: _language)
        .then((token) {
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TimelineScreen(
                    backgroundColor1: widget.backgroundColor1,
                    backgroundColor2: widget.backgroundColor2,
                    highlightColor: widget.highlightColor,
                    foregroundColor: widget.foregroundColor,
                    awsWrapper: awsWrapper)),
          );*/
        Navigator.pop(context, _emailEditor.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.centerLeft,
          end: new Alignment(1.0, 0.0),
          // 10% of the width, so there are ten blinds.
          colors: [widget.backgroundColor1, widget.backgroundColor2],
          // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[


          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 200.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: widget.foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Padding(
                  padding:
                  EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                  child: Icon(
                    Icons.alternate_email,
                    color: widget.foregroundColor,
                  ),
                ),
                new Expanded(
                  child: TextField(
                    controller: _emailEditor,
                    //obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'email@email.com',
                      hintStyle: TextStyle(color: widget.foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),


          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: widget.foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                  child: Icon(
                    Icons.lock_open,
                    color: widget.foregroundColor,
                  ),
                ),
                new Expanded(
                  child: TextField(
                    controller: _passwordEditor,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: widget.foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),

          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: widget.foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                  child: Icon(
                    Icons.lock_open,
                    color: widget.foregroundColor,
                  ),
                ),
                new Expanded(
                  child: TextField(
                    controller: _repeatedPasswordEditor,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: widget.foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),


          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(

              border: Border(

                bottom: BorderSide(
                    color: widget.foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),

            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Padding(
                  padding:
                  EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                  child: Icon(
                    Icons.language,
                    color: widget.foregroundColor,
                  ),
                ),

                new DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    value: _language,
                    isDense: true,
                    onChanged: (String newValue) {
                      _language = newValue;
                    },
                    items: _languages.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),

                  ),
                ),
              ],
            ),
          ),


          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    color: widget.highlightColor,
                    onPressed: () {
                      _signUp(context);
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: widget.foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            child: Divider(),
          ),
        ],
      ),
    ));
  }
}
