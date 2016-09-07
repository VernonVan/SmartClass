/**
 * Created by moyanyuan on 16/7/27.
 */
var myAPP = angular.module('starter', ['ngTouch', 'ngRoute']);
myAPP.controller('main-controller', function ($scope, $location) {

    $scope.tabAction = function ($event) {
        var tabIndex = angular.element($event.target).parents('.tab').index();
        switch (tabIndex) {
            case 0:
            {
                $location.path('/Home');
                break;
            }
            case 1:
            {
                $location.path('/ResourcesTable');
                break;
            }
            case 2:
            {
                $location.path('/PPTShow');
                break;
            }
            case 3:
            {
                $location.path('/StudentQuestion');
                break;
            }
        }
        //$scope.returnHTMLURL();

        angular.element($event.target).parents('.tab').css('background-color', 'white');
        angular.element($event.target).parents('.tab').find('.colorSpan').css('background-color', 'rgb(32,184,253)');
        angular.element($event.target).parents('.tab').find('.key').find('label').css('color', 'rgb(32,184,253)');
        angular.element($event.target).parents('.tab').siblings('.tab').css('background-color', '');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.colorSpan').css('background-color', '');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.key').find('label').css('color', 'rgb(170,170,170)');
    };

});

myAPP.controller('root-controller', function ($scope) {

    $scope.$on('to-root', function (event, obj) {
        $scope.$broadcast('to-showAlert', obj);
    });

});

myAPP.controller('alert-controller', function ($scope, $http, $window) {

    var title = "";

    $scope.$on('to-showAlert', function (event, obj) {
        if (obj['msg']) {
            angular.element('.outer').css('display', 'block');
        }
        title = obj['title'];
    });

    function confirm() {
        $http.get('').success(function(data){
            if(data['message'] == true) {
                $window.location.href  = "TestPage/HTML/testPage.html";
            }else {
                alert("信息填写不准确,请确认后再提交...");
            }
        });
    }

    $scope.send = function () {

        var id = angular.element('.id').val();
        var name = angular.element('.name').val();

        if (id == "" || name == "") {
            alert("信息未填完整，请确认后再核实！");
        } else {
            var confirmData = {
                "student_number": id,
                "student_name": name
            };

            var storage = window.localStorage;
            storage.setItem("stuID",id);
            storage.setItem("stuName",name);
            storage.setItem("title",title);

            $http.get('confirmID', confirmData)
                .success(function (data) {
                    console.log(data);
                    //confirm();
                })
                .error(function (data, status) {
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
    };

    $scope.dismiss = function () {
        angular.element('.outer').css('display', 'none');
    }
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