const uuidv4 = require('uuid/v4');
var moment = require('moment');
var AWS = require('aws-sdk');

var CONSTANTS = require('./constants');
var dbDAO = require('./dbDAO');

// export the class
module.exports = ArticleHandler;

function ArticleHandler(){
}

function prepareTimelineParameters(filters){

  let UpToDate =  moment(filters.upToDate).utc().format("YYYY-MM-DD HH:mm:ss 'GMT+0000'");

  let paramters = {
    Language : filters.language,
    UpToDate : UpToDate,
    KeywordsFilter: filters.keywords ? "and Keywords LIKE '%" + filters.keywords  + "%' "  :   ''
  };

  return paramters ;
}

function prepareAddingParameters(article)
{
  let type = '';
  let articleContent = {};

  console.log('article : ', JSON.stringify(article));

  if(article.body.feelings) {
    type = "feelings";
    articleContent = article.body.feelings ;
  }
  else if (article.body.feedback){
    type = "feedback";
    articleContent = article.body.feedback ;
  }
  else if (article.body.milestone){
    type = "milestone";
    articleContent = article.body.milestone ;
  }
  console.log('articleContent : ', JSON.stringify(articleContent));
  console.log('type : ', type);

  let paramters = {
    ArticleID:  uuidv4(),
    UserID : article.sub,
    OriginalLanguage: article.language,
    Language: article.language,
    Type: type,
    Story: articleContent.story,
    EntityType: articleContent.type ? articleContent.type : null,
    EntityName: articleContent.name ? articleContent.name : null,
    TimeStamp: moment().utc().format("YYYY-MM-DD HH:mm:ss 'GMT+0000'")
  };

  return paramters ;
}

async function translateArticle(parameters)
{
    let source, destination;
    let enStory, frStory, arStory;

    //Translate to English
    console.log("------------------------------------------------------------------------------->> English");
    source = parameters.OriginalLanguage ;
    destination = "en";

    if(source !== "en") {
      enStory = await translate(source, destination, parameters.Story);
    }
    else {
      enStory = parameters.Story ;
    }
    console.log("Story: ", enStory);
    let enKeywords = await extractKeywords(enStory);
    console.log("Keywords: ", enKeywords);
    let enParamters = JSON.parse(JSON.stringify(parameters)) ;
    enParamters.Story = enStory ;
    enParamters.Keywords = enKeywords ;
    enParamters.Language = 'en';
    console.log('enParamters : ', JSON.stringify(enParamters));

    console.log("------------------------------------------------------------------------------->> French");
    destination = "fr";
    if(source !== "fr") {
         frStory = await translate("en", destination, enStory);
    }
    else {
      frStory = parameters.Story ;
    }
    console.log("Story: ", frStory);
    let frKeywords = await translate("en", destination, enKeywords);
    console.log("Keywords: ", frKeywords);
    let frParamters = JSON.parse(JSON.stringify(parameters)) ;
    frParamters.Story = frStory ;
    frParamters.Keywords = frKeywords ;
    frParamters.Language = 'fr';
    console.log('frParamters : ', JSON.stringify(frParamters));

    console.log("------------------------------------------------------------------------------->> Arabic");
    destination = "ar";
    if(source !== "ar") {
         arStory = await translate("en", destination, enStory);
    }
    else {
      arStory = parameters.Story ;
    }
    console.log("Story: ", arStory);
    let arKeywords = await translate("en", destination, enKeywords);
    console.log("Keywords: ", arKeywords);
    let arParamters = JSON.parse(JSON.stringify(parameters)) ;
    arParamters.Story = arStory ;
    arParamters.Keywords = arKeywords ;
    arParamters.Language = 'ar';
    console.log('arParamters : ', JSON.stringify(arParamters));

    let translatedParamters = {
      arParamters : arParamters ,
      frParamters: frParamters,
      enParamters: enParamters
    };
    console.log('translatedParamters : ', JSON.stringify(translatedParamters));
    return translatedParamters;
}

function extractKeywords(text, callback)
{
  return new Promise( callback => {

    let params = {
      LanguageCode: "en",
      Text: text
    };

    var comprehend = new AWS.Comprehend({region: 'us-east-1'});
    comprehend.detectEntities(params, function (err, data) {
      if (err){
        console.log(err, err.stack); // an error occurred
      }
      else{
        console.log(data);           // successful response

        let keywords = "";
        data.Entities.forEach(function(entity){
          keywords += " " + entity.Text + " - ";
        });

        callback(keywords);
      }
    });
  });
}



function translate(source, destination, text, callback)
{
  return new Promise( callback => {

    let params = {
      SourceLanguageCode: source,
      TargetLanguageCode: destination,
      Text: text
    };

    var translate = new AWS.Translate({region: 'us-east-1'});
    translate.translateText(params, function (err, data) {
      if (err){
        console.log(err, err.stack); // an error occurred
      }
      else{
        console.log(data);           // successful response
        callback(data.TranslatedText);
      }
    });
  });
}


ArticleHandler.prototype.addArticle = async function (article, callback) {

  console.log("------------------------------------------------------------------------------->> addArticle");
  let paramters = prepareAddingParameters(article);
  console.log('Original paramters : ', JSON.stringify(paramters));

  console.log("------------------------------------------------------------------------------->> translateArticle");
  let translatedParamters = await translateArticle(paramters);


  var dbDAOObj = new dbDAO();
  await dbDAOObj.openConnection();

  console.log("------------------------------------------------------------------------------->> Save Arabic Post");
  let arfnResult = await dbDAOObj.insertNewArticle(translatedParamters.arParamters);
  console.log('arfnResult : ', JSON.stringify(arfnResult));

  console.log("------------------------------------------------------------------------------->> Save English Post");
  let enfnResult = await dbDAOObj.insertNewArticle(translatedParamters.enParamters);
  console.log('enfnResult : ', JSON.stringify(arfnResult));

  console.log("------------------------------------------------------------------------------->> Save Frensh Post");
  let frfnResult = await dbDAOObj.insertNewArticle(translatedParamters.frParamters);
  console.log('frfnResult : ', JSON.stringify(arfnResult));

  //await dbDAOObj.closeConnection();


  console.log("------------------------------------------------------------------------------->> Done");
  callback(frfnResult);

};


function prepareAddCommentParameters(comment)
{
  console.log('comment : ', JSON.stringify(comment));

  let paramters = {
    CommentID:  uuidv4(),
    ArticleID: comment.articleID,
    UserID : comment.sub,
    OriginalLanguage: comment.language,
    Language: comment.language,
    Comment: comment.body.comment,
    TimeStamp: moment().utc().format("YYYY-MM-DD HH:mm:ss 'GMT+0000'")
  };

  return paramters ;
}

ArticleHandler.prototype.addComment = async function (article, callback) {

  console.log("------------------------------------------------------------------------------->> addComment");
  let paramters = prepareAddCommentParameters(article);
  console.log('Original paramters : ', JSON.stringify(paramters));

  console.log("------------------------------------------------------------------------------->> translateArticle");
  let translatedComment = await translateComment(paramters);


  var dbDAOObj = new dbDAO();
  await dbDAOObj.openConnection();

  console.log("------------------------------------------------------------------------------->> Save Arabic Comment");
  let arfnResult = await dbDAOObj.insertNewComment(translatedComment.arParamters);
  console.log('arfnResult : ', JSON.stringify(arfnResult));

  console.log("------------------------------------------------------------------------------->> Save English Comment");
  let enfnResult = await dbDAOObj.insertNewComment(translatedComment.enParamters);
  console.log('enfnResult : ', JSON.stringify(arfnResult));

  console.log("------------------------------------------------------------------------------->> Save Frensh Comment");
  let frfnResult = await dbDAOObj.insertNewComment(translatedComment.frParamters);
  console.log('frfnResult : ', JSON.stringify(arfnResult));

  //await dbDAOObj.closeConnection();



  callback(frfnResult);

};

ArticleHandler.prototype.getTimeline = async function (filters, callback) {

  console.log("------------------------------------------------------------------------------->> getTimeline");
  let paramters = prepareTimelineParameters(filters);
  console.log('paramters : ', JSON.stringify(paramters));

  console.log("------------------------------------------------------------------------------->> Read from DB");
  var dbDAOObj = new dbDAO();
  await dbDAOObj.openConnection();
  let fnResult = await dbDAOObj.getTimeline(paramters);
  console.log('after DB read fnResult : ', JSON.stringify(fnResult));
  //await dbDAOObj.closeConnection();
  console.log('after DB close connection : ', JSON.stringify(fnResult));

  callback(fnResult);

};


async function translateComment(parameters)
{
    let source, destination;
    let enComment, frComment, arComment;

    //Translate to English
    console.log("------------------------------------------------------------------------------->> English");
    source = parameters.OriginalLanguage ;
    destination = "en";

    if(source !== "en") {
      enComment = await translate(source, destination, parameters.Comment);
    }
    else {
      enComment = parameters.Comment ;
    }
    console.log("Comment: ", enComment);
    let enParamters = JSON.parse(JSON.stringify(parameters)) ;
    enParamters.Comment = enComment ;
    enParamters.Language = 'en';
    console.log('enParamters : ', JSON.stringify(enParamters));

    console.log("------------------------------------------------------------------------------->> French");
    destination = "fr";
    if(source !== "fr") {
         frComment = await translate("en", destination, enComment);
    }
    else {
      frComment = parameters.Comment ;
    }
    console.log("Comment: ", frComment);
    let frParamters = JSON.parse(JSON.stringify(parameters)) ;
    frParamters.Comment = frComment ;
    frParamters.Language = 'fr';
    console.log('frParamters : ', JSON.stringify(frParamters));

    console.log("------------------------------------------------------------------------------->> Arabic");
    destination = "ar";
    if(source !== "ar") {
         arComment = await translate("en", destination, enComment);
    }
    else {
      arComment = parameters.Comment ;
    }
    console.log("Comment: ", arComment);
    let arParamters = JSON.parse(JSON.stringify(parameters)) ;
    arParamters.Comment = arComment ;
    arParamters.Language = 'ar';
    console.log('arParamters : ', JSON.stringify(arParamters));

    let translatedParamters = {
      arParamters : arParamters ,
      frParamters: frParamters,
      enParamters: enParamters
    };
    console.log('translatedParamters : ', JSON.stringify(translatedParamters));
    return translatedParamters;
}

function prepareGetCommentsParameters(filters){

  let paramters = {
    Language : filters.language,
    ArticleID: filters.articleID
  };

  return paramters ;
}

ArticleHandler.prototype.getComments = async function (comment, callback) {

  console.log("------------------------------------------------------------------------------->> getComments");
  let paramters = prepareGetCommentsParameters(comment);
  console.log('paramters : ', JSON.stringify(paramters));

  console.log("------------------------------------------------------------------------------->> Read from DB");
  var dbDAOObj = new dbDAO();
  await dbDAOObj.openConnection();
  let fnResult = await dbDAOObj.getComments(paramters);
  //await dbDAOObj.closeConnection();
  console.log('fnResult : ', JSON.stringify(fnResult));


  callback(fnResult);

};
