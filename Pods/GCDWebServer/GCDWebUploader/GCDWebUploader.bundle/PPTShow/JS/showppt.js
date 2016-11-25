/**
 * Created by moyanyuan on 2016/11/23.
 */
myAPP.controller('showppt-controller',function($scope,$http, $sce) {
    $http.get('/getLiveAddress').success(function(data) {
        console.log(data);
        if(data['isLiving'] == true) {
            $scope.livesrc = data['address'];
        }else {
            console.log("no live");
        }
    }).error(function(status) {
        switch (status) {
            case 404:
                alert("没有连接到服务器");
                break;
        }
    });
                 
                 $scope.trustSrc = function(src) {
                 return $sce.trustAsResourceUrl(src);
                 };
});
