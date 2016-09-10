/**
 * Created by moyanyuan on 16/7/26.
 */
"use strict";
angular.module("ngTouch", [])
    .directive("ngTouchstart", function () {
        return {
            controller: ["$scope", "$element", function ($scope, $element) {

                $element.bind("touchstart", onTouchStart);
                function onTouchStart(event) {
                    var method = $element.attr("ng-touchstart");
                    $scope.$apply(method);
                }

            }]
        }
    })
    .directive("ngTouchmove", function () {
        return {
            controller: ["$scope", "$element", function ($scope, $element) {

                $element.bind("touchstart", onTouchStart);
                function onTouchStart(event) {
                    event.preventDefault();
                    $element.bind("touchmove", onTouchMove);
                    $element.bind("touchend", onTouchEnd);
                }
                function onTouchMove(event) {
                    var method = $element.attr("ng-touchmove");
                    $scope.$apply(method);
                }
                function onTouchEnd(event) {
                    event.preventDefault();
                    $element.unbind("touchmove", onTouchMove);
                    $element.unbind("touchend", onTouchEnd);
                }

            }]
        }
    })
    .directive("ngTouchend", function () {
        return {
            controller: ["$scope", "$element", function ($scope, $element) {

                $element.bind("touchend", onTouchEnd);
                function onTouchEnd(event) {
                    var method = $element.attr("ng-touchend");
                    $scope.$apply(method);
                }

            }]
        }
    });