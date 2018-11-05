import 'dart:convert';
import 'dart:convert' show utf8;

class Comment {
  final String articleID;
  final String userID;
  final String commentID;
  final String language;
  final String originalLanguage;
  final String timeStamp;

  final String comment;





  Comment({this.articleID, this.userID, this.commentID, this.comment, this.language, this.originalLanguage, this.timeStamp});

  factory Comment.fromJson(Map<String, dynamic> json) {
    String commentData = utf8.decode((json['Comment'])['data'].cast<int>()).toString();


    return Comment(
      articleID: json['ArticleID'],
      userID: json['UserID'],
      language: json['Language'],
      originalLanguage: json['OriginalLanguage'],
      commentID: json['CommentID'],
      comment: commentData,

      timeStamp: json['TimeStamp'],
    );
  }
}