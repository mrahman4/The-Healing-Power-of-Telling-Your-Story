import 'dart:convert';
import 'dart:convert' show utf8;

class Story {
  final String articleID;
  final String userID;
  final String language;
  final String originalLanguage;
  final String timeStamp;
  final String entityType;
  final String entityName;
  final String keywords;
  final String story;
  final String type;




  Story({this.articleID, this.userID, this.language, this.originalLanguage, this.type, this.story, this.keywords, this.entityType, this.entityName, this.timeStamp});

  factory Story.fromJson(Map<String, dynamic> json) {
    String storyData = utf8.decode((json['Story'])['data'].cast<int>()).toString();
    String keywordsData = utf8.decode((json['Keywords'])['data'].cast<int>());

    return Story(
      articleID: json['ArticleID'],
      userID: json['UserID'],
      language: json['Language'],
      originalLanguage: json['OriginalLanguage'],

      type: json['Type'],
      story: storyData,
      keywords: keywordsData,
      entityType: json['EntityType'],
      entityName: json['EntityName'],

      timeStamp: json['TimeStamp'],

    );
  }
}