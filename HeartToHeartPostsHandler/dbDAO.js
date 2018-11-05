var mysql = require('mysql');
var stringFormat = require('string.format');

var enviroment = require('./enviroment');
var CONSTANTS = require('./constants');

// export the class
module.exports = dbDAO;


//hearts_articles Table: ArticleID(PK), UserID(PK), Language(PK), OriginalLanguage, TimeStamp, Story, EntityType, EntityName, Keywords
let INSERT_NEW_ARTICLE = 'INSERT INTO hearts_articles SET ? ';
let SELECT_TIMELINE = 'select * from hearts_articles where Language = "{Language}" and TimeStamp < "{UpToDate}" {KeywordsFilter} order by TimeStamp desc ';

//hearts_comments Table: CommentID(PK), ArticleID, UserID, Language(PK), OriginalLanguage, TimeStamp, Comment
let INSERT_NEW_COMMENT = 'INSERT INTO hearts_comments SET ? ';
let SELECT_COMMENTS = 'select * from hearts_comments where Language = "{Language}" and ArticleID = "{ArticleID}" order by TimeStamp desc ';

// Constructor
function dbDAO() {
  // always initialize all instance properties
  this.connection = mysql.createConnection({
      host: enviroment.DB_HOST,
      user: enviroment.DB_USER,
      password: enviroment.DB_PSWD,
      database: enviroment.DB_SCHEMA
  });
}

dbDAO.prototype.openConnection = function (callback) {
  return new Promise( callback => {
    var connection = this.connection;
    connection.connect(
        function (connectErr) {
            console.log(' open connection error : ' + JSON.stringify(connectErr));
            callback();
        }
    );
  });

};

dbDAO.prototype.closeConnection = function (callback) {
    return new Promise( callback => {
      this.connection.end(
          function (err) {
              // The connection is terminated now
              if( err )
                  console.log(' dbDAO closeConnection error : ' + JSON.stringify(err));
          });
    });
};

dbDAO.prototype.insertNewArticle = async function (para, callback) {
    return new Promise( callback => {
      console.log('Inside insertNewArticle fn');
      var fnResult = {};

      var connection = this.connection;

      var query = connection.query(INSERT_NEW_ARTICLE, para,
        function (queryErr, queryResult) {

          if (!queryErr) {
            fnResult.statusCode = CONSTANTS.SUCCESS_RESPONSE;
            fnResult.updatedAt = new Date();
          }
          else {
              fnResult.statusCode = CONSTANTS.ERROR_RESPONSE;
              fnResult.error_description = queryErr.stack;
          }

          console.log('insertNewArticle fnResult : ' + JSON.stringify(fnResult));
          callback(fnResult);
        }
      );
    });
};


dbDAO.prototype.getTimeline  = async function (para, callback) {
  return new Promise( callback => {
    console.log('inside getTimeline fn');

    var connection = this.connection;
    var selectQuery = SELECT_TIMELINE.format(para);
    console.log('selectQuery : ' + selectQuery);

    connection.query(selectQuery,
        function (queryErr, queryResult) {
            var fnResult = {};

            if (!queryErr) {
                fnResult.statusCode = CONSTANTS.SUCCESS_RESPONSE;
                fnResult.articlesArray = queryResult;
            }
            else {
                console.log('queryErr : ' + JSON.stringify(queryErr));
                fnResult.statusCode = CONSTANTS.ERROR_RESPONSE;
                fnResult.error_description = queryErr.stack;
            }
            console.log('getTimeline fnResult : ' + JSON.stringify(fnResult));
            callback(fnResult);
        }
    );
  });
};

dbDAO.prototype.getComments  = async function (para, callback) {
  return new Promise( callback => {
    console.log('inside getComments fn');

    var connection = this.connection;
    var selectQuery = SELECT_COMMENTS.format(para);
    console.log('selectQuery : ' + selectQuery);

    connection.query(selectQuery,
        function (queryErr, queryResult) {
            var fnResult = {};

            if (!queryErr) {
                fnResult.statusCode = CONSTANTS.SUCCESS_RESPONSE;
                fnResult.commentsArray = queryResult;
            }
            else {
                console.log('queryErr : ' + JSON.stringify(queryErr));
                fnResult.statusCode = CONSTANTS.ERROR_RESPONSE;
                fnResult.error_description = queryErr.stack;
            }
            console.log('getComments fnResult : ' + JSON.stringify(fnResult));
            callback(fnResult);
        }
    );
  });
};


dbDAO.prototype.insertNewComment = async function (para, callback) {
    return new Promise( callback => {
      console.log('Inside insertNewComment fn');
      var fnResult = {};

      var connection = this.connection;

      var query = connection.query(INSERT_NEW_COMMENT, para,
        function (queryErr, queryResult) {

          if (!queryErr) {
            fnResult.statusCode = CONSTANTS.SUCCESS_RESPONSE;
            fnResult.updatedAt = new Date();
          }
          else {
              fnResult.statusCode = CONSTANTS.ERROR_RESPONSE;
              fnResult.error_description = queryErr.stack;
          }

          console.log('insertNewComment fnResult : ' + JSON.stringify(fnResult));
          callback(fnResult);
        }
      );
    });
};
