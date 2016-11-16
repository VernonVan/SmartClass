/**
 * Created by moyanyuan on 16/9/10.
 */
angular.module('check',['ngTouch'])
    .directive('action', function () {
        return function (scope, element, attrs) {

            element.bind('touchstart click', function (event) {

                event.preventDefault();
                event.stopPropagation();
                scope.$event = event;

                scope.$apply(attrs['action']);
            });
        };
    })
    .controller('check-controller',function($scope,checkoutService){

        $scope.result = checkoutService.getResult();
        $scope.color = function (flag) {
            if (flag) {
                return "color: rgb(80,203,252);"
            } else {
                return "color: rgb(235,79,56);"
            }
        };

        $scope.show = true;

        $scope.checkDetail = function(){
            $scope.show = false;
        }
}).factory('checkoutService',function(){
    var storage = window.localStorage;
    var result = eval("(" + storage.getItem("result") + ")");
    return {
        getResult: function(){
            return result;
        }
    };
});