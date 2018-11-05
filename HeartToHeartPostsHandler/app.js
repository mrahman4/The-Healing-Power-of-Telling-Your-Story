var ArticleHandler = require('./ArticleHandler');
var CONSTANTS = require('./constants');


exports.handler = (event, context, callback) => {

    console.log('Received event:', JSON.stringify(event));
    console.log('Received context:', JSON.stringify(context));


    var articletHandlerObj = new ArticleHandler();

    switch (event.type) {

        case 'add_article':
          //add request & search for avilable volunteer
          var article = event;
          articletHandlerObj.addArticle(article,
                function(addArticleResult){
                  console.log('addArticleResult :', JSON.stringify(addArticleResult));
                    if (addArticleResult.statusCode === CONSTANTS.SUCCESS_RESPONSE){
                        //res.status(200).send(addArticleResult);
                        //return callback(addArticleResult);
                        return context.succeed(addArticleResult);
                    }
                    else{
                        //res.status(403).send(JSON.stringify(addArticleResult));
                        return context.fail(JSON.stringify(addArticleResult));
                    }
                }
          );
          break;

        case 'get_timeline':
          //mark volunteer as avilable and search for requester
          let filter = event;
          articletHandlerObj.getTimeline(filter,
                function(getTimelineResult){
                  console.log('getTimelineResult2 :', JSON.stringify(getTimelineResult));
                    if (getTimelineResult.statusCode === CONSTANTS.SUCCESS_RESPONSE){
                        console.log('sucess');
                        //res.status(200).send(getTimelineResult);
                        //return callback(getTimelineResult);
                        return context.succeed(getTimelineResult);
                    }
                    else{
                        //res.status(403).send(JSON.stringify(getTimelineResult));
                        console.log('fail');
                        return context.fail(JSON.stringify(getTimelineResult));
                    }
                    console.log('done');
                }
          );
          break;

        case 'add_comment':
          let comment = event;
          articletHandlerObj.addComment(comment,
                function(addCommentResult){
                  console.log('addCommentResult :', JSON.stringify(addCommentResult));
                    if (addCommentResult.statusCode === CONSTANTS.SUCCESS_RESPONSE){
                        //res.status(200).send(addCommentResult);
                        //return callback(addCommentResult);
                        return context.succeed(addCommentResult);
                    }
                    else{
                        //res.status(403).send(JSON.stringify(addCommentResult));
                        return context.fail(JSON.stringify(addCommentResult));
                    }
                }
          );
          break;

          case 'get_comments':
            //mark volunteer as avilable and search for requester
            let commentFilter = event;
            articletHandlerObj.getComments(commentFilter,
                  function(getCommentsResult){
                    console.log('getCommentsResult :', JSON.stringify(getCommentsResult));
                      if (getCommentsResult.statusCode === CONSTANTS.SUCCESS_RESPONSE){
                          //res.status(200).send(getCommentsResult);
                          //return callback(getCommentsResult);
                          return context.succeed(getCommentsResult);
                      }
                      else{
                          //res.status(403).send(JSON.stringify(getCommentsResult));
                          return context.fail(JSON.stringify(getCommentsResult));
                      }
                  }
            );
            break;

        default:
            console.log("Unsupported request");

            var fnResult = {
                statusCode: CONSTANTS.ERROR_RESPONSE,
            };
            return context.fail(JSON.stringify(fnResult));
            break;
        }

};
