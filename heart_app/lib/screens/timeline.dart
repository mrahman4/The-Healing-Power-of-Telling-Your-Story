import 'package:flutter/material.dart';
import 'newpost.dart';
import '../wrappers/aws.dart';
import '../models/story.dart';
import 'oldpost.dart';

class TimelineScreen extends StatefulWidget {

  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;
  final AWS   awsWrapper;
  List<Story> _articlesArray;

  TimelineScreen({Key k, this.backgroundColor1, this.backgroundColor2, this.highlightColor, this.foregroundColor, this.awsWrapper});

  @override
  _TimelineState createState() => new _TimelineState();

}

class _TimelineState extends State<TimelineScreen> {

  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Timeline ...");
  TextEditingController _searchQueryEditor ;
  bool _IsSearching;


  @override
  void initState(){
    super.initState();
    _searchQueryEditor = new TextEditingController();
    _IsSearching = false;
    _loadTimeline();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  void _loadTimeline () async{
    widget.awsWrapper.getTimeline(_searchQueryEditor.text,new DateTime.now().millisecondsSinceEpoch).then((List<Story> stories){
      print(stories);
      setState((){
        widget._articlesArray = stories ;
        }
      );
    });

  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  Widget _buildBar(context){
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: widget.foregroundColor,);
                this.appBarTitle = new TextField(
                  controller: _searchQueryEditor,
                  style: new TextStyle(
                    color: widget.foregroundColor,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: widget.foregroundColor),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: widget.foregroundColor)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
        ]
    );
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: widget.foregroundColor,);
      this.appBarTitle =
      new Text("Timeline ...", style: new TextStyle(color: widget.foregroundColor),);
      _IsSearching = false;
      //_searchQueryEditor.clear();
      _loadTimeline ();
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: _buildBar(context),
        body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: new Alignment(1.0, 0.0), // 10% of the width, so there are ten blinds.
            colors: [widget.backgroundColor1, widget.backgroundColor2], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Stack(
              children:  <Widget>[
                _viewStory(),

                new Positioned(
                  top: 30.0,
                  right: 16.0,
                  child: new Column(
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: _addNewStory,
                          backgroundColor: widget.backgroundColor1,
                          child: new Icon(Icons.favorite_border),
                        ),
                        /*FloatingActionButton(
                          onPressed: ()=>{},
                          backgroundColor: widget.backgroundColor1,
                          child: new Icon(Icons.search),
                        ),*/
                      ],
                    )
                ),

              ],
        ),
      )
    );
  }

  void _addNewStory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPost(
        backgroundColor1: widget.backgroundColor1,
        backgroundColor2: widget.backgroundColor2,
        highlightColor: widget.highlightColor,
        foregroundColor: widget.foregroundColor,
        awsWrapper: widget.awsWrapper
      )),
    )
    .then((Object result){
      _loadTimeline();
      print("result from addpage ${result.toString()}");
    });
  }

  void _displayStory(index){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OldPost(
          backgroundColor1: widget.backgroundColor1,
          backgroundColor2: widget.backgroundColor2,
          highlightColor: widget.highlightColor,
          foregroundColor: widget.foregroundColor,
          awsWrapper: widget.awsWrapper,
          storyInfo: widget._articlesArray[index],
      )),
    )
        .then((Object result){
      _loadTimeline();
      print("result from addpage ${result.toString()}");
    });
  }


  Widget _viewStory() {

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
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: new SafeArea(
              top: false,
              bottom: false,
              child:  new Form(
                autovalidate: true,
                child: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (widget._articlesArray != null) ? widget._articlesArray.length : 0,
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
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: widget.backgroundColor2),
        child: _makeListTile(index),
      ),
    );
  }

  Widget _makeListTile(int index)
  {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        /*leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: widget.backgroundColor1))),
          child: Icon(Icons.autorenew, color: widget.foregroundColor),
        ),*/
        title: Text(
          _shortStory(index),
          style: TextStyle(color: widget.foregroundColor, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        onTap: (){_displayStory(index);},
        /*subtitle: Row(
          children: <Widget>[
            Text(
                widget._articlesArray[index].keywords,
                style: TextStyle(color: widget.foregroundColor))
          ],
        ),*/
        trailing: Icon(
            Icons.keyboard_arrow_right,
            color: widget.foregroundColor,
            size: 30.0,
        ));
  }

  String _shortStory(int index)
  {
    String story = widget._articlesArray[index].story.length > 240 ? widget._articlesArray[index].story.substring(0,237): widget._articlesArray[index].story ;
    return story +" ...";

  }
}