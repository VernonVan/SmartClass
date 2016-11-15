/**
 * Created by moyanyuan on 16/9/1.
 */
var adminAPP = angular.module('teacher',['ngTouch','ngRoute']);
adminAPP.controller('admin-controller',function($http,$scope,$location){

    $scope.tabAction = function($event){
        var tabIndex = angular.element($event.target).parents('.tab').index();
        var obj = {
            firstFlag: true,
            secondFlag: true
        };
        switch (tabIndex) {
            case 0:{
                obj['firstFlag'] = true;
                obj['secondFlag'] = true;
                $location.path('/ResourcesTable');
                break;
            }
            case 1:{
                obj['firstFlag'] = false;
                obj['secondFlag'] = false;
                $location.path('/PPTShow');
                break;
            }
            case 2:
            {
                obj['firstFlag'] = false;
                obj['secondFlag'] = false;
                $location.path('/ImportStudent');
                break;
            }
        }
        $scope.$emit('to-root',obj);

        angular.element($event.target).parents('.tab').css('background-color','white');
        angular.element($event.target).parents('.tab').find('.colorSpan').css('background-color','rgb(32,184,253)');
        angular.element($event.target).parents('.tab').find('.key').find('label').css('color','rgb(32,184,253)');
        angular.element($event.target).parents('.tab').siblings('.tab').css('background-color','');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.colorSpan').css('background-color','');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.key').find('label').css('color','rgb(170,170,170)');
    };
}).controller('button-controller',function($scope){

    $scope.second = true;
    $scope.first = true;

    $scope.$on('to-button', function (event,obj) {
        $scope.second = obj['secondFlag'];
        $scope.first = obj['firstFlag'];
    });

}).controller('root-controller',function($scope){

    $scope.$on('to-root', function (event,obj) {
        $scope.$broadcast('to-button', obj);
    });

}).config(function($routeProvider){
    $routeProvider.when('/PPTShow', {
        templateUrl: '../../PPTShow/HTML/showppt.html'
    });
    $routeProvider.when('/ResourcesTable', {
        templateUrl: '../../ResourcesTable/HTML/resource.html'
    });
    $routeProvider.when('/ImportStudent', {
        templateUrl: '../../ImportStudent/HTML/importStudent.html'
    });

    $routeProvider.otherwise({
        templateUrl: '../../ResourcesTable/HTML/resource.html'
    });
});