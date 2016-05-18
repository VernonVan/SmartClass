angular.module('starter.controllers',[])

.controller('main-controller', function($scope, $http){

	$scope.qusetions = [];
	$scope.select = [ ['A','B','C','D'], [], ['T','F'] ];
	$scope.answer = [];
	
    // 从test.txt中读取试卷
	$http.get('test.txt?callback=JSON_CALLBACK')
        .success(function(data){
			$scope.data = {
				'title' : data['name'],
				'exam' : data['questions']
			};
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

	// 单选的逻辑
	$scope.singleChoice = function(questionIndex, choiceIndex){
		$scope.answer[questionIndex] = [];
		$scope.answer[questionIndex][choiceIndex] = true;
	}
	

    // post学生的考试结果
	$scope.send = function(){

		$scope.student_number = document.getElementById("studentNumber").value;
		$scope.student_name = document.getElementById("studentName").value;
		var date = new Date().toJSON().slice(0,10);

		if(!$scope.student_number){
			alert("请先输入学号");
			return;
		}

		if(!$scope.student_name){
			alert("请先输入姓名");
			return;
		}

		console.log("answer");
		console.log($scope.answer);

		// 计算得分
		var score  = 0;
		for(var i = 0; i < $scope.data.exam.length; ++i){
			// 计算单选题和判断题的得分
			if($scope.data.exam[i]['type'] == 0 || $scope.data.exam[i]['type'] == 2){
				var answerIndex = $scope.data.exam[i]['answer'].charCodeAt()-65;
				if($scope.answer[i][answerIndex] == true) {
					score += $scope.data.exam[i]['score'];
				}
				// 计算多选题的得分
			} else if($scope.data.exam[i]['type'] == 1) {
				var answers = $scope.data.exam[i]['answer'];
				var answerIndexs = [];
				for(var j = 0; j < answers.length; j++){
					answerIndexs[j] = answers.charAt(j).charCodeAt()-65;
				}
				var isRightAnswer = true;
				for(var k = 0; k < 4; k++) {
					if(contains(answerIndexs, k) == true) {
						if($scope.answer[i][k] != true){
							isRightAnswer = false;
							break;
						}
					} else {
						if($scope.answer[i][k] == true){
							isRightAnswer = false;
							break;
						}
					}
				}
				if(isRightAnswer == true) {
					score += $scope.data.exam[i]['score'];
				}
			}
		}

		console.log("date:%s", date);
		console.log("score:%d", score);

		$scope.submit = {
			"paper_title" : $scope.data.title,
			"student_number" : $scope.student_number,
			"student_name" : $scope.student_name,
			"score" : score,
			"date" : date
		};

		$http.post('post_answer',$scope.submit)
            .success(function(data){
                alert("考试完成\n你的分数:" + score);
            })
            .error(function(data,status,headers){
                switch(status){
                    case 404:alert("没有连接到服务器");break;
				    case 403:alert("重复提交");break;
                }
            });

	}  // $scope.send

	function contains(array, obj)
	{
		var i = array.length;
		while (i--) {
			if (array[i] === obj) {
				return true;
			}
		}
		return false;
	}

});
