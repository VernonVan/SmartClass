/**
 * Created by moyanyuan on 16/9/1.
 */
var adminAPP = angular.module('teacher',['ngTouch','ngRoute']);
adminAPP.controller('admin-controller',function($http,$scope,$location){

    $scope.tabAction = function($event){
        var tabIndex = angular.element($event.target).parents('.tab').index();
        switch (tabIndex) {
            case 0:{
                $location.path('/ResourcesTable');
                break;
            }
            case 1:{
                $location.path('/PPTShow');
                break;
            }
            case 2:{
                $location.path('/PPTShow');
                break;
            }
        }
        //$scope.returnHTMLURL();

        angular.element($event.target).parents('.tab').css('background-color','white');
        angular.element($event.target).parents('.tab').find('.colorSpan').css('background-color','rgb(32,184,253)');
        angular.element($event.target).parents('.tab').find('.key').find('label').css('color','rgb(32,184,253)');
        angular.element($event.target).parents('.tab').siblings('.tab').css('background-color','');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.colorSpan').css('background-color','');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.key').find('label').css('color','rgb(170,170,170)');
    };
}).controller('root-controller',function(){}).config(function($routeProvider){
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
        templateUrl: '../../ResourcesTable/HTML/resource.html'
    });
});