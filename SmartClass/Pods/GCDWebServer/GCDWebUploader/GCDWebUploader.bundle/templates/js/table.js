
angular.module('starter',[]).controller('main-controller', function($scope, $http)
{
    $scope.send = function(model){
        $scope.submit = {
            'name': model.name
        };
        $http.post('post_paperName',$scope.submit)
            .success(function(){
                console.log("post ok");
                window.location.href = "test.html";
            })
            .error(function(status){
                switch(status){
                    case 404:alert("没有连接到服务器");break;
                }
            });
    }


    $http.get('table.txt?callback=JSON_CALLBACK')
        .success(function(data){
            if(data == "") {
                alert("老师没有发布任何试卷!");
            }else  {
                $scope.models = data;
            }

        })
        .error(function(status){
            switch(status){
                case 404:alert("没有连接到服务器");break;
            }
        });

});

