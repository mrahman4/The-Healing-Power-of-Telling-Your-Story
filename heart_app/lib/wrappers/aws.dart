import 'dart:async';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:http/http.dart' as http;
import '../models/story.dart';
import '../models/comment.dart';

import 'dart:convert';


class AWS {

  final userPool = new CognitoUserPool('.....', '......');

  AWS();
  String _accessToken, _IdToken, _refresToken;

  Future<List<Comment>> getComments(String postID) async {
    try {
      String endpoint =
          'https://........amazonaws.com/../heart-to-heart/$postID/';
      print(endpoint);

      Map <String, String> header = {
        'Content-Type': 'application/json',
        'Authorization' : _IdToken
      };
      print(_IdToken);

      final response = await http.get(
          endpoint,
          headers: header,
      );

      print(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      List commentsJson = responseJson['commentsArray'];
      return commentsJson.map((m) => new Comment.fromJson(m)).toList();
    }
    catch(e) {
      print(e);
    }

  }


  Future<List<Story>> getTimeline(String filter, int upToDate) async {
    try {
      String endpoint =
          'https://......amazonaws.com/.../heart-to-heart/posts?upToDate=$upToDate&&keywords=$filter';
      print(endpoint);

      Map <String, String> header = {
        'Content-Type': 'application/json',
        'Authorization' : _IdToken
      };
      print(_IdToken);

      final response = await http.get(
        endpoint,
        headers: header,
      );

      print(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      List articlesJson = responseJson['articlesArray'];
      return articlesJson.map((m) => new Story.fromJson(m)).toList();
    }
    catch(e) {
      print(e);
    }

  }

  Future<String> saveComment(String postID, String body) async {
    try{
      String endpoint =
          'https://......amazonaws.com/.../heart-to-heart/$postID';

      Map <String, String> header = {
          'Content-Type': 'application/json',
          'Authorization' : _IdToken
      };

      final response = await http.post(
        endpoint,
        headers: header,
        body: body
      );

      print(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      print(responseJson.toString());
      return "";
      //
      //
      //return responseJson['token'];
    }
    catch(e) {
      print(e);
    }
  }

  Future<String> savePost(String body) async {
    try{
      const endpoint =
          'https://q9529rfww8.execute-api.us-east-1.amazonaws.com/0_1/heart-to-heart/posts/';

      Map <String, String> header = {
        'Content-Type': 'application/json',
        'Authorization' : _IdToken
      };

      final response = await http.post(
          endpoint,
          headers: header,
          body: body
      );

      print(response.body);
      //Map<String, dynamic> responseJson = json.decode(response.body);
      //print(responseJson.toString());
      return "";
      //
      //
      //return responseJson['token'];
    }
    catch(e) {
      print(e);
    }
  }

  Future<void> cognitoSignUp({String userEmail, String password, String language}) async {

    final userAttributes = [
      new AttributeArg(name: 'custom:language', value: language)
    ];

    var data;
    try {
      data = await userPool.signUp(userEmail, password
          , userAttributes: userAttributes);
    } catch (e) {
      print(e);
    }
  }

  Future<void> cognitoLogin({String userEmail, String password}) async {
    final cognitoUser = new CognitoUser(userEmail, userPool);
    final authDetails = new AuthenticationDetails(
        username: userEmail, password: password);

    CognitoUserSession session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
      print("CognitoUserNewPasswordRequiredException : $e");
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
      print("CognitoUserMfaRequiredException : $e");
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
      print("CognitoUserSelectMfaTypeException : $e");
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
      print("CognitoUserMfaSetupException : $e");
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
      print("CognitoUserTotpRequiredException : $e");
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
      print("CognitoUserCustomChallengeException : $e");
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
      print("CognitoUserConfirmationNecessaryException : $e");
    } catch (e) {
      print(e);
    }

    //Cognito Tokens
    //ID Token(custom token?): contains claims about the identity of the authenticated user such as name, email, and phone_number.
    //Access Token (expire in short time): grants access to authorized resources. which sent in Authorize Header.
    //Refresh Token: contains the information necessary to obtain a new ID or access token.

    //jwToken is how above token can be presented


    _accessToken = session.getAccessToken().getJwtToken() ;
    _IdToken = session.getIdToken().getJwtToken();
    _refresToken = session.getRefreshToken().getToken();


    List<CognitoUserAttribute> attributes;
    try {
      attributes = await cognitoUser.getUserAttributes();
    } catch (e) {
      print(e);
    }

    String sub;
    attributes.forEach((attribute) {
      print('attribute ${attribute.getName()} has value ${attribute.getValue()}');
      if( attribute.getName() == 'sub')
        sub = attribute.getValue();
    });
    print(sub);

    return _accessToken;
  }

}

