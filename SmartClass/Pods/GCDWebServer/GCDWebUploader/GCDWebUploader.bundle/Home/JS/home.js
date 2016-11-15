/**
 * Created by moyanyuan on 16/8/3.
 */
myAPP.controller('home-controller', function ($scope,$http,$window,informationService) {

    $http.get("getPaperList?callback=JSON_CALLBACK").success(function (data) {
        if (data['papers'] == "") {
            alert("老师没有发布任何试卷!");
        } else {
            $scope.textList = data["papers"];
        }
    }).error(function (status) {
        switch (status) {
            case 404:
                alert("没有连接到服务器");
                break;
        }
    });

    $scope.goToTest = function ($event) {
        var id = informationService.getID();
        var name = informationService.getName();
        var text = angular.element($event.target).siblings(".testTitle").text();
        var storage = window.localStorage;
        storage.setItem("stuID",id);
        storage.setItem("stuName",name);
        storage.setItem("title",text);
        $window.location.href  = "TestPage/HTML/testPage.html";
    }
});