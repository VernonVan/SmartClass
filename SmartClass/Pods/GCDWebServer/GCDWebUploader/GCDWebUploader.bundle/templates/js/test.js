angular.module('starter',[]).controller('main-controller', function($scope, $http){

                                                    $scope.qusetions = [];
                                                    $scope.select = [[],[],[]];
                                                    $scope.answer = [];
                                                    var scopes = [];
                                                    var correctQuestion = [];
                                                    
                                                    var singleChoicesCount = 0;
                                                    var multipleChoicesCount = 0;
                                                    var judgeChoicesCount = 0;
                                                    var items = ['A','B','C','D'];
                                                    
                                                    $scope.single = function($event){
                                                    var s = 0;
                                                    if(angular.element($event.target).parent().parent().parent().parent().hasClass('singleList')) {
                                                    s = 0;
                                                    }else if(angular.element($event.target).parent().parent().parent().parent().hasClass('multipleList')) {
                                                    s = 1;
                                                    }else {
                                                    s = 2;
                                                    }
                                                    var imageArray = angular.element($event.target).css('background-image').split('/');
                                                    if(imageArray[imageArray.length-1].substr(0,imageArray[imageArray.length-1].length-2) == "green.png") {
                                                    angular.element($event.target).css('background-image','url(RESOURCES/IMG/grey.png)');
                                                    angular.element($event.target).parent().siblings('li').find('.icon').css('background-image','url(RESOURCES/IMG/grey.png)');
                                                    removeAnswer(angular.element($event.target).parent().parent().parent().index(),angular.element($event.target).parent().index(),s);
                                                    } else if(imageArray[imageArray.length-1].substr(0,imageArray[imageArray.length-1].length-2) == "grey.png") {
                                                    angular.element($event.target).css('background-image','url(RESOURCES/IMG/green.png)');
                                                    angular.element($event.target).parent().siblings('li').find('.icon').css('background-image','url(RESOURCES/IMG/grey.png)');
                                                    addAnswer(angular.element($event.target).parent().parent().parent().index(),angular.element($event.target).parent().index(),s)
                                                    }
                                                    };
                                                    
                                                    $scope.multiple = function($event){
                                                    var s = 0;
                                                    if(angular.element($event.target).parent().parent().parent().parent().hasClass('singleList')) {
                                                    s = 0;
                                                    }else if(angular.element($event.target).parent().parent().parent().parent().hasClass('multipleList')) {
                                                    s = 1;
                                                    }else {
                                                    s = 2;
                                                    }
                                                    var imageArray = angular.element($event.target).css('background-image').split('/');
                                                    if(imageArray[imageArray.length-1].substr(0,imageArray[imageArray.length-1].length-2) == "green.png") {
                                                    angular.element($event.target).css('background-image','url(RESOURCES/IMG/grey.png)');
                                                    removeAnswer(angular.element($event.target).parent().parent().parent().index(),angular.element($event.target).parent().index(),s);
                                                    } else if(imageArray[imageArray.length-1].substr(0,imageArray[imageArray.length-1].length-2) == "grey.png") {
                                                    angular.element($event.target).css('background-image','url(RESOURCES/IMG/green.png)');
                                                    addAnswer(angular.element($event.target).parent().parent().parent().index(),angular.element($event.target).parent().index(),s);
                                                    }
                                                    };
                                                    
                                                    function addAnswer(index,currentIndex,sign){
                                                    switch (sign) {
                                                    case 0:{
                                                    $scope.select[0][index] = items[currentIndex];
                                                    break;
                                                    }
                                                    case 1:{
                                                    $scope.select[1][index][currentIndex] = items[currentIndex];
                                                    break;
                                                    }
                                                    case 2:{
                                                    $scope.select[2][index] = items[currentIndex];
                                                    break;
                                                    }
                                                    }
                                                    }
                                                    
                                                    function removeAnswer(index,currentIndex,sign){
                                                    switch (sign) {
                                                    case 0:{
                                                    $scope.select[0][index] = 'F';
                                                    break;
                                                    }
                                                    case 1:{
                                                    $scope.select[1][index][currentIndex] = 'E';
                                                    break;
                                                    }
                                                    case 2:{
                                                    $scope.select[2][index] = 'R';
                                                    break;
                                                    }
                                                    }
                                                    }
                                                    
                                                    function result() {
                                                    var scope = 0;
                                                    for(var j1=0;j1<singleChoicesCount;j1++) {
                                                    if($scope.select[0][j1] == $scope.answer[j1]) {
                                                    scope = scope + scopes[j1];
                                                    correctQuestion.push(j1);
                                                    }
                                                    }
                                                    for(var j2=0;j2<multipleChoicesCount;j2++) {
                                                    $scope.select[1][j2] = $scope.select[1][j2].join("");
                                                    if($scope.select[1][j2] == $scope.answer[j1+j2]) {
                                                    scope = scope + scopes[j1+j2];
                                                    correctQuestion.push(j1+j2);
                                                    }
                                                    }
                                                    for(var j3=0;j3<judgeChoicesCount;j3++) {
                                                    if($scope.select[2][j3] == $scope.answer[j1+j2+j3]) {
                                                    scope = scope + scopes[j1+j2+j3];
                                                    correctQuestion.push(j1+j2+j3);
                                                    }
                                                    }
                                                    return scope;
                                                    }
                                                    
                                                    //从test.txt中读取试卷
                                                    //$scope.questions[0]为单选
                                                    //$scope.questions[1]为多选
                                                    //$scope.questions[2]为判断
                                                    $http.get('test.txt').success(function(data){
                                                                                  $scope.data = {
                                                                                  'title' : data['name'],
                                                                                  'exam' : data['questions']
                                                                                  };
                                                                                  $scope.questions = [];
                                                                                  for(var t = 0; t < 3; ++t){
                                                                                  $scope.questions[t] = [];
                                                                                  }
                                                                                  
                                                                                  for(var i = 0; i<$scope.data.exam.length; ++i){
                                                                                  switch($scope.data.exam[i]['type']){
                                                                                  //case 0:$scope.questions[0].push($scope.data.exam[i]);break;
                                                                                  //case 1:$scope.questions[1].push($scope.data.exam[i]);break;
                                                                                  //case 2:$scope.questions[2].push($scope.data.exam[i]);break;
                                                                                  case 0: {
                                                                                  $scope.questions[0].push($scope.data.exam[i]);
                                                                                  $scope.answer.push($scope.data.exam[i].answer);
                                                                                  $scope.select[0].push('');
                                                                                  scopes.push($scope.data.exam[i].score);
                                                                                  singleChoicesCount++;
                                                                                  break;
                                                                                  }
                                                                                  case 1: {
                                                                                  $scope.questions[1].push($scope.data.exam[i]);
                                                                                  $scope.answer.push($scope.data.exam[i].answer);
                                                                                  $scope.select[1].push(['','','','']);
                                                                                  scopes.push($scope.data.exam[i].score);
                                                                                  multipleChoicesCount++;
                                                                                  break;
                                                                                  }
                                                                                  case 2: {
                                                                                  $scope.questions[2].push($scope.data.exam[i]);
                                                                                  $scope.answer.push($scope.data.exam[i].answer);
                                                                                  $scope.select[2].push('');
                                                                                  scopes.push($scope.data.exam[i].score);
                                                                                  judgeChoicesCount++;
                                                                                  break;
                                                                                  }
                                                                                  }
                                                                                  }
                                                                                  return data;
                                                                                  }).error(function(data,status){
                                                                                           switch(status){
                                                                                           case 404:alert("还没有开始考试！！！");return;
                                                                                           }
                                                                                           //console.log(data);
                                                                                           });
                                                    
                                                    // post学生的考试结果
                                                    $scope.send = function(){
                                                    
                                                    var r = result();
                                                    var studentNumber = angular.element('#account').val();
                                                    var studentName = angular.element('#name').val();
                                                    
                                                    if(studentName == "" || studentNumber == "") {
                                                    alert("信息填写未完整,请确认后再提交!!!");
                                                    }
                                                    
                                                    alert(studentName + " " + studentNumber);
                                                    
                                                    $scope.submit = {
                                                    "paper_title" : $scope.data.title,
                                                    "student_number" : studentNumber,
                                                    "student_name" : studentName,
                                                    "score" : r,
                                                    "correctQuestions": correctQuestion
                                                    };
                                                    
                                                    $http.post('post_answer',$scope.submit)
                                                    .success(function(data){
                                                             alert("考试完成\n你的分数:" + r);
                                                             })
                                                    .error(function(data,status,headers){
                                                           switch(status){
                                                           case 404:alert("没有连接到服务器");break;
                                                           case 403:alert("重复提交");break;
                                                           }
                                                           });
                                                    
                                                    };  // $scope.send
                                                    
                                                    function contains(array, obj) {
                                                    var i = array.length;
                                                    while (i--) {
                                                    if (array[i] === obj) {
                                                    return true;
                                                    }
                                                    }
                                                    return false;
                                                    }

});
