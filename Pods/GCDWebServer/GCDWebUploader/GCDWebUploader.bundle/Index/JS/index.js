/**
 * Created by moyanyuan on 16/7/27.
 */
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

        angular.element($event.target).parents('.tab').css('background-color', 'white');
        angular.element($event.target).parents('.tab').find('.colorSpan').css('background-color', 'rgb(32,184,253)');
        angular.element($event.target).parents('.tab').find('.key').find('label').css('color', 'rgb(32,184,253)');
        angular.element($event.target).parents('.tab').siblings('.tab').css('background-color', '');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.colorSpan').css('background-color', '');
        angular.element($event.target).parents('.tab').siblings('.tab').find('.key').find('label').css('color', 'rgb(170,170,170)');
    };

});

myAPP.controller('root-controller', function ($scope) {
    $scope.$on('to-rootForAddLi', function (event, obj) {
        $scope.$broadcast('to-question', obj);
    });

    $scope.$on('to-rootForInfoConfirm', function () {
        $scope.$broadcast('to-infoConfirm');
    });
});

myAPP.controller('alert-controller', function ($scope, $http, $window,informationService) {

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

            $http.post('confirmID', confirmData)
                .success(function (data) {
                    if(data['isMyStudent']) {
                        informationService.setID(id);
                        informationService.setName(name);
                        angular.element('.outer').css('display', 'none');
                        $scope.$emit('to-rootForInfoConfirm');
                    }else {
                        alert("信息填写不正确,请确认后再提交~");
                    }
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

});