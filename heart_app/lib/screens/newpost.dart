import 'package:flutter/material.dart';
import '../wrappers/aws.dart';

class NewPost extends StatefulWidget {
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;
  final AWS   awsWrapper;
  //final bool  rDirection;

  NewPost(
      {this.backgroundColor1, this.backgroundColor2, this.highlightColor, this.foregroundColor, this.awsWrapper});

  @override
  _NewPostState createState() => new _NewPostState();
}

class _NewPostState extends State<NewPost> {

  List<String> _categories = <String>['', 'from heart', 'feedback', 'milestone'];
  List<String> _entities = <String>['', 'hospital', 'clinic', 'doctor', 'lab'];
  TextEditingController feelingsEditor, milestoneEditor, feedbackEditor, entityNameEditor;

  String _category = 'from heart';
  String _entity = '';

  Widget _formWidget ;


  /*File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }*/

  @override
  void initState() {
    feelingsEditor = new TextEditingController();
    milestoneEditor = new TextEditingController();
    feedbackEditor = new TextEditingController();
    entityNameEditor = new TextEditingController();
  }

  void _savePost()
  {
    String body ;
    switch (_category)
    {
      case 'from heart':
        { body = '{"feelings":{"story":"${feelingsEditor.text}"}}'; }
        break;
      case 'feedback':
        { body = '{"feedback":{"type":"$_entity", "name":"${entityNameEditor.text}", "story":"${feedbackEditor.text}"}}'; }
        break;
      case 'milestone':
        { body = '{"milestone":{"story":"${milestoneEditor.text}"}}'; }
        break;
      default:
        break;
    }

    widget.awsWrapper.savePost(body);
    Navigator.pop(context);
  }

  Widget _buildTypeSelectionForm()
  {
    return new ListView(
      padding: const EdgeInsets.only(top: 60.0, bottom: 50.0, left: 10.0, right: 10.0),
      children: <Widget>[


        new InputDecorator(
          decoration: const InputDecoration(
            icon: const Icon(Icons.favorite_border),
            labelText: 'Category',
          ),
          isEmpty: _category == 'from heart',
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              value: _category,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _category = newValue;
                });
              },
              items: _categories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildHeartForm()
  {
    return new ListView(
      padding: const EdgeInsets.only(top: 60.0, bottom: 50.0, left: 10.0, right: 10.0),
      children: <Widget>[


        new TextFormField(
          controller: feelingsEditor,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(2.00),
            hintText: "From heart to heart, enter your story or advise ... ",
          ),
          //textAlign: widget.rDirection ? TextAlign.right : TextAlign.left,
          maxLines: 20,
        ),

        /*new Row(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(left: 40.0, top: 20.0),
              child: new FlatButton(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: const Text(
                  'Image',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                color: widget.highlightColor,
                onPressed: () => {},
              ),
            ),

            new TextFormField(
              decoration: const InputDecoration(
                //icon: const Icon(Icons.person),
                contentPadding: EdgeInsets.all(2.00),
              ),
              enabled: false,
              maxLines: 1,
            ),

          ],
        ),*/

        new Container(
          //padding: const EdgeInsets.only(left: 40.0, top: 20.0),
          child: new FlatButton(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 10.0),
            child: const Text(
              'Post',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            color: widget.highlightColor,
            onPressed: _savePost,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackForm()
  {
    return new ListView(
      padding: const EdgeInsets.only(top: 60.0, bottom: 50.0, left: 10.0, right: 10.0),
      children: <Widget>[


        new InputDecorator(
          decoration: const InputDecoration(
            //icon: const Icon(Icons.),
            labelText: 'Entity',
          ),
          isEmpty: _entity == '',
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              value: _entity,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _entity = newValue;
                });
              },
              items: _entities.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),
        ),

        new TextFormField(
          controller: entityNameEditor,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 40.0, horizontal: 2.0),
            hintText: "Entity Name",
          ),
        ),

        new TextFormField(
          controller: feedbackEditor,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 40.0, horizontal: 2.0),
            hintText: "From heart to heart, enter your feedback ... ",
          ),
          //textAlign: widget.rDirection ? TextAlign.right : TextAlign.left,
          maxLines: 10,
        ),


        new Container(
          padding: const EdgeInsets.only(left: 2.0, top: 10.0),
          child: new FlatButton(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 2.0),
            child: const Text(
              'Post',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            color: widget.highlightColor,
            onPressed: _savePost,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneForm()
  {
    return new ListView(
      padding: const EdgeInsets.only(top: 60.0, bottom: 50.0, left: 10.0, right: 10.0),
      children: <Widget>[


        new TextFormField(
          controller: milestoneEditor,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(2.00),
            hintText: "From heart to heart, tell us about your milestone ... ",
          ),
          //textAlign: widget.rDirection ? TextAlign.right : TextAlign.left,
          maxLines: 20,
        ),

        /*new Row(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(left: 40.0, top: 20.0),
              child: new FlatButton(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: const Text(
                  'Image',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                color: widget.highlightColor,
                onPressed: () => {},
              ),
            ),

            new TextFormField(
              decoration: const InputDecoration(
                //icon: const Icon(Icons.person),
                contentPadding: EdgeInsets.all(2.00),
              ),
              enabled: false,
              maxLines: 1,
            ),

          ],
        ),*/

        new Container(
          //padding: const EdgeInsets.only(left: 40.0, top: 20.0),
          child: new FlatButton(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 10.0),
            child: const Text(
              'Post',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            color: widget.highlightColor,
            onPressed: _savePost,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    switch (_category)
    {
      case 'from heart':
        { _formWidget = _buildHeartForm(); }
        break;
      case 'feedback':
        { _formWidget = _buildFeedbackForm(); }
        break;
      case 'milestone':
        { _formWidget = _buildMilestoneForm(); }
        break;
      default:
        { _formWidget = _buildTypeSelectionForm(); }
        break;

    }

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
      child: _formWidget
     ),
    );

  }
}