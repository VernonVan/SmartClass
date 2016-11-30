
var myAPP = angular.module('starter', ['ngTouch', 'ngRoute']);

myAPP.factory('informationService',function(){
    var studentID = "";
    var studentName = "";
    var title = "";

    return {
        setID: function(id){
            studentID = id;
        },
        isLogin: function() {
              if(studentID == "") {
              return false;
              }else
              {
              return true;
              }
        },
        setName: function(name){
            studentName = name;
        },
        getID: function(){
            return studentID;
        },
        getName: function(){
            return studentName;
        },
        setTitle: function(t){
            title = t;
        },
        getTitle: function(){
            return title;
        }
    };
});

myAPP.factory('questionService',function(){
    var qList = [];

    return {
        setList: function(list){
            qList.push(list);
        },
        getList: function(){
            return qList;
        }
    };
});

myAPP.config(function ($routeProvider) {
    $routeProvider.when('/Home', {
        templateUrl: '../../Home/HTML/home.html'
    });
    $routeProvider.when('/PPTShow', {
        templateUrl: '../../PPTShow/HTML/showppt.html'
    });
    $routeProvider.when('/ResourcesTable', {
        templateUrl: '../../ResourcesTable/HTML/resource.html'
    });
    $routeProvider.when('/StudentQuestion', {
        templateUrl: '../../StudentQuestion/HTML/question.html'
    });

    $routeProvider.otherwise({
        templateUrl: '../../Home/HTML/home.html'
    });
});

