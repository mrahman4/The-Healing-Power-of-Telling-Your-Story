import 'package:flutter/material.dart';
import '../wrappers/aws.dart';
import '../models/story.dart';
import '../models/comment.dart';
import '../screens/newcomment.dart';

class OldPost extends StatefulWidget {
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;
  final AWS   awsWrapper;
  final Story storyInfo;
  List<Comment> _commentsArray;

  OldPost(
      {this.backgroundColor1, this.backgroundColor2, this.highlightColor, this.foregroundColor, this.awsWrapper, this.storyInfo});

  @override
  _OldPostState createState() => new _OldPostState();
}

class _OldPostState extends State<OldPost> {

  TextEditingController feelingsEditor, commentEditor;

  @override
  void initState() {
    feelingsEditor = new TextEditingController();
    commentEditor = new TextEditingController();

    feelingsEditor.text = widget.storyInfo.story;

    _getComments();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  void _getComments()
  {
    widget.awsWrapper.getComments(widget.storyInfo.articleID).then((
        List<Comment> comments) {
      print(comments);
      setState(() {
        widget._commentsArray = comments;
      }
      );
    });
  }

  void _addComment() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewComment(
        backgroundColor1: widget.backgroundColor1,
        backgroundColor2: widget.backgroundColor2,
        highlightColor: widget.highlightColor,
        foregroundColor: widget.foregroundColor,
        awsWrapper: widget.awsWrapper,
        storyInfo: widget.storyInfo,
      )),
    ).then((Object result){
      _getComments();
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
                  new Expanded(
                    child: new TextFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(2.00),
                      ),
                      maxLines: 15,
                      enabled: false,
                      controller: feelingsEditor,

                    ),
                  ),
                ],
              ),
            ),

            new Container(
                margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: new FlatButton(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 4.0),
                color: widget.highlightColor,
                onPressed: _addComment,
                child: Text(
                  "add supportive comment",
                  style: TextStyle(color: widget.foregroundColor),
                ),
              ),
            ),

            /*new Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: widget.foregroundColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),

              child: new Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  new Expanded(
                    child: new TextField(
                      controller: commentEditor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter supportive comment .. ',

                      ),
                    ),
                  ),


                  new FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    color: widget.highlightColor,
                    onPressed: _addComment,
                    child: Text(
                      "add supportive comment",
                      style: TextStyle(color: widget.foregroundColor),
                    ),
                  ),
                ],
              ),
            ),*/

            _viewComments(),


          ],
        ),

      ),
    );

  }

  Widget _viewComments() {

    return Container(
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.centerLeft,
          end: new Alignment(2.0, 0.0), // 10% of the width, so there are ten blinds.
          colors: [widget.backgroundColor1, widget.backgroundColor2], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new SafeArea(
          top: false,
          bottom: false,
          child:  new Form(
            autovalidate: true,
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (widget._commentsArray != null) ? widget._commentsArray.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return _makeCard(index);
              },
            ),
          ),
        ),
      ),
    );

  }

  Widget _makeCard(int index)
  {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 14.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: widget.backgroundColor2),
        child: _makeListTile(index),
      ),
    );
  }

  Widget _makeListTile(int index)
  {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      subtitle: Text(
        widget._commentsArray[index].comment,
        style: TextStyle(color: widget.foregroundColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
