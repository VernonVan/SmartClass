angular.module('starter.controllers',[])

.controller('main-controller',function($scope, $http){

	$scope.select = [
		['A','B','C','D'],
		[],
		['T','F']
	];
	$scope.answer = [];
	$scope.qusetions = [];
	$scope.concreteAnswer = [];
	$scope.order = {
		'head':9999,
		'tail':0
	};
	
    // 从test.txt中读取试卷
	$http.get('test.txt?callback=JSON_CALLBACK')
        .success(function(data){
			$scope.data = {
				'title' : data['name'],
				'exam' : data['questions']
			};
			console.log($scope.data.title);
			$scope.questions = [];
			for(var i = 0; i < 3; ++i){
				$scope.questions[i] = [];
			}

			for(var i = 0; i<$scope.data.exam.length; ++i){
				switch($scope.data.exam[i]['type']){
					case 0:$scope.questions[0].push($scope.data.exam[i]);break;
					case 1:$scope.questions[1].push($scope.data.exam[i]);break;
					case 2:$scope.questions[2].push($scope.data.exam[i]);break;
				}
			}
			return data;
		})
		.error(function(data,status){
			switch(status){
				case 404:alert("还没有开始考试！！！");return;
			}
		});
    
	
	$scope.show = function(pindex,index,type){
		if(type == 0 || type == 2){
		    if($scope.concreteAnswer[pindex] == $scope.select[type][index]){
                $scope.concreteAnswer[pindex] = "";
                return;
            }
            $scope.concreteAnswer[pindex] = $scope.select[type][index];
            for(var i = 0;i < 4 ; i ++){
                if(i != index){
                    if($scope.answer[pindex][i])
                        $scope.answer[pindex][i] = false;
                }
            }
		} else if(type == 1) {
            if (!$scope.concreteAnswer[pindex]) {
                $scope.concreteAnswer[pindex] = [];
            }
            $scope.concreteAnswer[pindex][index] = !$scope.concreteAnswer[pindex][index];
            $scope.order['head'] = $scope.order['head'] > pindex ? pindex : $scope.order['head'];
            $scope.order['tail'] = $scope.order['tail'] < pindex ? pindex : $scope.order['tail'];
        }
	}
    
    // post学生的考试结果
	$scope.send = function(){
		if($scope.concreteAnswer.length < $scope.data.exam.length){
			alert('试卷没有完成');
			return;
		}

		var string  = [];
		for(var i = 0; i < $scope.concreteAnswer.length;  ++i){
			if(i < $scope.order['head'] || i > $scope.order['tail']) {
                string[i] = $scope.concreteAnswer[i];
            } else{
				string[i] = '';
				for(var j = 0 ; j < 4 ; j ++){
					string[i] = !$scope.concreteAnswer[i][j] ? string[i] : string[i]+$scope.select[0][j];
				}
			}
		}
		for(var i = 0; i < $scope.concreteAnswer.length; ++i){
			if(string[i] == "" || string[i] == undefined){
				alert('试卷没有完成');
				return;
			}
		}
		console.log(string);

		$scope.student_number = document.getElementById("in").value;
		if(!$scope.student_number){
			alert("请输入学号");
			return;
		}

		$scope.submit = {
			"paper_title":$scope.data.title,
			"answers":string,
			"student_number":$scope.student_number
		};

		$http.post('post_answer',$scope.submit)
            .success(function(data){
                alert("提交成功");
            })
            .error(function(data,status,headers){
                switch(status){
                    case 404:alert("没有连接到服务器");break;
				    case 403:alert("重复提交");break;
                }
            });

	}  // $scope.send

});
