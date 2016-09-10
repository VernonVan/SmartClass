/**
 * Created by moyanyuan on 16/8/3.
 */
var myyAPP2 = angular.module('starter');
myyAPP2.controller('home-controller', function ($scope, $http, $window) {

    $http.get("getPaperList?callback=JSON_CALLBACK").success(function (data) {
        //alert(data);
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
        var msg = true;
        var text = angular.element($event.target).siblings(".testTitle").text();
        var obj = {
            "msg": msg,
            "title": text
        };
        //console.log(obj);
        $scope.$emit('to-root', obj);
        //angular.element('.goToCell').css('disabled','true');
    }
});