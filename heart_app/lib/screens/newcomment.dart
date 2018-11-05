import 'package:flutter/material.dart';
import '../wrappers/aws.dart';
import '../models/story.dart';

class NewComment extends StatefulWidget {
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;
  final AWS   awsWrapper;
  final Story storyInfo;

  NewComment(
      {this.backgroundColor1, this.backgroundColor2, this.highlightColor, this.foregroundColor, this.awsWrapper, this.storyInfo});

  @override
  _NewCommentState createState() => new _NewCommentState();
}

class _NewCommentState extends State<NewComment> {

  TextEditingController commentEditor;

  @override
  void initState() {
    commentEditor = new TextEditingController();
  }


  void _saveComment() {

    widget.awsWrapper.saveComment(widget.storyInfo.articleID,'{"comment":"${commentEditor.text}"}').then((String ouput){
      Navigator.pop(context);
    });


  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Container(
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
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: new ListView(
            padding: const EdgeInsets.only(top: 60.0, bottom: 50.0, left: 10.0, right: 10.0),
            children: <Widget>[

              new TextFormField(
                controller: commentEditor,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(2.00),
                  hintText: "Add supportive comment ... ",
                ),
                maxLines: 20,
              ),

              new Container(
                //padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new FlatButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: const Text(
                    'Save Comment',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  color: widget.highlightColor,
                  onPressed: _saveComment,
                ),
              ),
            ],
          ),
      ),
    );

  }

}
