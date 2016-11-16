/**
 * Created by moyanyuan on 16/9/18.
 */

myAPP.controller('question-controller', function ($scope, questionService) {

    $scope.$on('to-question',function(event,obj){
        $scope.questionList = questionService.getList();
    });

    $scope.questionList = questionService.getList();


}).controller('haveQuestion-controller',function($scope, $http, $filter, informationService ,questionService){

    $scope.sendQuestion = function(){
        var question = angular.element('.text').val();
        if(question == "") {
            alert("提问内容为空,请填写后再提问~");
        }else {
            var questionData = {
                id: informationService.getID(),
                name: informationService.getName(),
                question: question
            };
            $http.post('haveQuestion', questionData).success(function (data) {
                var now = new Date();
                var time = $filter("date")(now, "yyyy-MM-dd HH:mm");
                var item = {
                    t: time,
                    q: question
                };
                questionService.setList(item);
                $scope.$emit('to-rootForAddLi',item);
                angular.element('.text').val("");
            }).error(function (data, status) {
                    switch (status) {
                        case 404:
                            alert("没有连接到服务器");
                            break;
                        case 403:
                            alert("重复提交");
                            break;
                    }
                });
        }
    }
});