import 'package:flutter/material.dart';
//import '../ui/simple_round_button.dart';
import 'timeline.dart';
import 'signup.dart';
import '../wrappers/aws.dart';


class LoginScreen extends StatefulWidget  {
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;
  final AssetImage logo;





  LoginScreen({Key k, this.backgroundColor1, this.backgroundColor2, this.highlightColor, this.foregroundColor, this.logo});
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginScreen> {

  TextEditingController _emailEditor;
  TextEditingController _passwordEditor;

  @override
  void initState() {
    _emailEditor = new TextEditingController();
    _passwordEditor = new TextEditingController();
  }

  void _signIn(BuildContext context)
  {
    AWS awsWrapper = new AWS();
    awsWrapper.cognitoLogin(userEmail: _emailEditor.text, password: _passwordEditor.text).then((token) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            TimelineScreen(
              backgroundColor1: widget.backgroundColor1,
              backgroundColor2: widget.backgroundColor2,
              highlightColor: widget.highlightColor,
              foregroundColor: widget.foregroundColor,
              awsWrapper: awsWrapper
            )),
      );
    });
  }

  void _signUp(BuildContext context)
  {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          SignUpScreen(
              backgroundColor1: widget.backgroundColor1,
              backgroundColor2: widget.backgroundColor2,
              highlightColor: widget.highlightColor,
              foregroundColor: widget.foregroundColor,
          )),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.centerLeft,
          end: new Alignment(1.0, 0.0), // 10% of the width, so there are ten blinds.
          colors: [widget.backgroundColor1, widget.backgroundColor2], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 70.0, bottom: 50.0),
            child: Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(
                      "From Heart to Heart ...",
                      style: TextStyle(color: widget.foregroundColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0),
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
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                      color: widget.highlightColor,
                      onPressed: () {_signIn(context);},
                      child: Text(
                        "Log In",
                        style: TextStyle(color: widget.foregroundColor),
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
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    color: Colors.transparent,
                    onPressed: () => {},
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(color: widget.foregroundColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //new Expanded(child: Divider(),),

          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 6.0, ),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    color: Colors.transparent,
                    onPressed: () {_signUp(context);},
                    child: Text(
                      "Don't have an account? Create One",
                      style: TextStyle(color: widget.foregroundColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}