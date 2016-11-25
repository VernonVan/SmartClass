/**
 * Created by moyanyuan on 16/8/5.
 */
angular.module('page', ['radialIndicator', 'ngTouch'])
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
    .controller('root-controller', function ($scope) {

        $scope.$on('to-root', function (event, msg) {
            $scope.$broadcast('to-child', msg);
        });

        $scope.$on('want-answers', function () {
            $scope.$broadcast('get-answers');
        });

        $scope.$on('to-rootForHead', function (event, progress) {
            $scope.$broadcast('to-head', progress);
        });
        $scope.$on('to-rootForLength', function (event, l) {
            $scope.$broadcast('to-headL', l);
        });

        $scope.$on('to-rootForAlert', function () {
            $scope.$broadcast('to-alert');
        });

        $scope.$on('to-rootForCheck', function () {
            $scope.$broadcast('to-check');
        });

    })
    .controller('head-controller', function ($scope,userService) {

        $scope.index = 0;
        $scope.pro = 0;
        $scope.length = 0;

        $scope.optionsDialogAction = function () {
            angular.element('.options').slideDown();
        };

        $scope.$on('to-child', function (event, obj) {
            $scope.index = userService.getIndex();
        });

        $scope.$on('to-head', function (event, progress) {
            $scope.pro = progress;
        });

        $scope.$on('to-headL', function (event, l) {
            $scope.length = l;
        });

    })
    .controller('page-controller', function ($scope, $http, userService) {

        $scope.isSelected = [false, false, false, false, false, false];

        var backgroundColors = [];
        var booleanArr = [];
        var colors = [];
        var tags = [];
        var types = ["单选","多选","判断"];

        var installBackgroundColorArray = function () {
            for (var j = 0; j < $scope.testDataLength; j++) {
                var temp = [false, false, false, false, false, false];
                booleanArr.push(temp);
                tags.push(0);
            }
        };

        $scope.$on('to-child', function (event, obj) {
            isWhich(obj['type']);
            $scope.type = questionTypes[obj['type']];
            $scope.questionText = obj['topic'];
            $scope.optionFirstText = obj['A'];
            $scope.optionSecondText = obj['B'];
            $scope.optionThirdText = obj['C'];
            $scope.optionFourthText = obj['D'];
            $scope.isSelected = booleanArr[userService.getIndex()];
        });

        var dealAnswers = function () {
            var array = [];
            var checkArray = [];
            var temp1 = ['A', 'B', 'C', 'D'];
            var temp2 = "";
            var temp3 = {
                A: "说法正确",
                B: "说法错误"
            };
            var flag = false;
            var e = 0;
            var score = 0;
            for (var t = 0; t < $scope.testDataLength; t++) {

                var check = {
                    tag: false,
                    type: "",
                    title: "",
                    correct: [],
                    select: [],
                    index: 0
                };

                temp2 = "";
                check['title'] = $scope.testData[t]['topic'];
                check['type'] = types[$scope.testData[t]['type']];
                check['index'] = $scope.testData[t]['index'];

                if ($scope.testData[t]['type'] == 2) {
                    for (var p = 4; p < 6; p++) {
                        if (booleanArr[t][p] == true) {
                            temp2 = temp2 + temp1[p % 4];
                        }
                    }
                    check['correct'].push(temp3[$scope.testData[t]['answer']]);
                    if(temp2 != "") {
                        check['select'].push(temp3[temp2]);
                    }
                } else {
                    var a = $scope.testData[t]['answer'].split("");
                    for(var i = 0 ;i < a.length ;i++) {
                        check['correct'].push($scope.testData[t][a[i]]);
                    }
                    for (var r = 0; r < 4; r++) {
                        if (booleanArr[t][r] == true) {
                            temp2 = temp2 + temp1[r];
                            check['select'].push($scope.testData[t][temp1[r]]);
                        }
                    }
                }
                if (temp2 != "") {
                    e++;
                    if (temp2 == $scope.testData[t]['answer']) {
                        score = score + $scope.testData[t]['score'];
                        array.push($scope.testData[t]['index']);
                        check['tag'] = true;
                    }else {
                    }
                }else {
                    check['select'].push(null);
                }
                checkArray.push(check);
            }//end for
            if (e == $scope.testData.length) {
                flag = true;
            }
            array.push(flag);
            array.push(score);
            var storage = window.localStorage;
            storage.setItem("result",JSON.stringify(checkArray));
            return array;
        };

        $scope.$on('get-answers', function () {
            var bag = dealAnswers();
            userService.setSelectAnswers(bag);
            userService.setCompleteTag(bag[bag.length - 2]);
        });

        $scope.obj = radialIndicator('#indicatorContainer', {
            radius: 80,
            barColor: '#00E8A4',
            barBgColor: '#DDDDDD',
            barWidth: 10,
            fontColor: '#00E8A4',
            initValue: "0",
            fontWeight: 'normal',
            fontSize: 20,
            format: function (value) {
                return '已完成' + value + '题';
            }
        });

        $scope.obj.option('maxValue', $scope.testDataLength);
        var progress = 0;

        var questionTypes = ["单选", "多选", "判断"];
        $scope.testData = [];
        $scope.testIndexs = [];
        $scope.isChoice = false;
        $scope.isJudge = false;

        function initialize() {
            for (var i = 0; i < $scope.testDataLength; i++) {
                $scope.testIndexs.push(i+1);
            }
        }

        function isWhich(d) {
            if (d == 0 || d == 1) {
                $scope.isChoice = true;
                $scope.isJudge = false;
            } else {
                $scope.isChoice = false;
                $scope.isJudge = true;
            }
        }

        var paper_name = {
            "name": userService.getInformation()['title']
        };

        $scope.f = false;
        $scope.$on('to-infoConfirm',function() {
            $scope.f = true;
        });
        $http.post('requestPaper',paper_name).success(function (data) {
            if (data == "" && $scope.f == true) {
                alert("老师还没发布试卷!");
            } else {
                console.log(data);
                $scope.testData = data['questions'];
                var t = data['questions'][0]['type'];
                $scope.type = questionTypes[t];
                isWhich(t);
                $scope.questionText = data['questions'][0]['topic'];
                $scope.optionFirstText = data['questions'][0]['A'];
                $scope.optionSecondText = data['questions'][0]['B'];
                $scope.optionThirdText = data['questions'][0]['C'];
                $scope.optionFourthText = data['questions'][0]['D'];
                $scope.testDataLength = data['questions'].length;
                var l = $scope.testDataLength;

                $scope.$emit('to-rootForLength', l);

                userService.install(data['questions']);
                userService.setQuestionsCount($scope.testDataLength);

                initialize();
                installBackgroundColorArray();

                $scope.obj.option('maxValue', $scope.testDataLength);
                $scope.obj.value(0);
            }
        });

        $scope.dismissDialog = function () {
            angular.element('.options').slideUp();
        };

        $scope.selectAction = function ($event) {
            var index = userService.getIndex();
            var p = angular.element($event.target).parents('.selection').index();
            if ($scope.type == '单选') {
                if ($scope.isSelected[p] == false) {
                    $scope.isSelected[p] = true;
                    for (var i = 0; i < 4; i++) {
                        if (i != p) {
                            $scope.isSelected[i] = false;
                        }
                    }
                    if (tags[index] == 0) {
                        tags[index] = tags[index] + 1;
                        progress = progress + 1;
                    }
                }
            }
            else if ($scope.type == '判断') {
                if ($scope.isSelected[p] == false) {
                    if (p == 4) {
                        $scope.isSelected[p] = true;
                        $scope.isSelected[p + 1] = false;
                    } else {
                        $scope.isSelected[p] = true;
                        $scope.isSelected[p - 1] = false;
                    }
                    if (tags[index] == 0) {
                        tags[index] = tags[index] + 1;
                        progress = progress + 1;
                    }
                }
            } else {
                if ($scope.isSelected[p] == false) {
                    $scope.isSelected[p] = true;
                    if (tags[index] == 0) {
                        progress = progress + 1;
                    }
                    tags[index] = tags[index] + 1;
                } else {
                    $scope.isSelected[p] = false;
                    tags[index] = tags[index] - 1;
                    if (tags[index] == 0) {
                        progress = progress - 1;
                    }
                }
            }
            booleanArr[index] = $scope.isSelected;
            $scope.obj.value(progress);
            $scope.$emit('to-rootForHead', progress);
            if (tags[index] == 0) {
                angular.element('.optionLi').eq(index).css('border', '0');
            } else {
                angular.element('.optionLi').eq(index).css('border', '2px solid white');
            }
        };

        $scope.optionLiAction = function ($event) {
            userService.setIndex(angular.element($event.target).index());
            var item = $scope.testData[angular.element($event.target).index()];
            $scope.$emit('to-root', item);
            isWhich(item['type']);
            $scope.type = questionTypes[item['type']];
            $scope.questionText = item['topic'];
            $scope.optionFirstText = item['A'];
            $scope.optionSecondText = item['B'];
            $scope.optionThirdText = item['C'];
            $scope.optionFourthText = item['D'];
            $scope.backgroundColor = backgroundColors[angular.element($event.target).index()];
            $scope.color = colors[angular.element($event.target).index()];
            $scope.dismissDialog();
        };

    })
    .controller('submit-controller', function ($scope, $http, userService,$location,$window) {

        $scope.back = function () {
            if (userService.getIndex() == 0) {
                alert("之前已无题目~");
            } else {
                userService.setIndex(userService.goBack());
                var obj = userService.getDataItem();
                $scope.$emit('to-root', obj);
            }
        };

        $scope.next = function () {
            if (userService.getIndex() == userService.getQuestionsCount() - 1) {
                alert("之后已无题目~");
            } else {
                userService.setIndex(userService.goNext());
                var obj = userService.getDataItem();
                $scope.$emit('to-root', obj);
            }
        };

        $scope.submit = function () {
            $scope.$emit('to-rootForAlert');
        };

        $scope.$on('to-check',function(){

            $scope.$emit('want-answers');
            var result = userService.getSelectAnswers();

            if (userService.getCompleteTag() == false) {
                alert("题目未全部做完!" + "分数:" + result[result.length - 1]);
            } else {
                alert("考试结束!" + "分数:" + result[result.length - 1]);
            }

            var score = result[result.length-1];

            var testData = {
                "student_number": userService.getInformation()['id'],
                "student_name": userService.getInformation()['name'],
                "paper_name": userService.getInformation()['title'],
                "result": result,
                "score": score
            };

            $http.post('resultData', testData)
                .success(function (data) {
                    $window.location.href = "../HTML/checkout.html";
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
        });

    })
    .controller('alert-controller',function($scope){
        $scope.$on('to-alert',function(){
            angular.element('.outer').css('display','block');
        });

        $scope.dismiss = function(){
            angular.element('.outer').css('display','none');
        };

        $scope.check = function(){
            $scope.$emit('to-rootForCheck');
        };
    })
    .factory('userService', function () {
        var index = 0;
        var questionsCount = 0;
        var pageData = [];
        var correctAnswers = [];
        var cTag = false;
        var selectAnswers = [];

        var storage = window.localStorage;
        var title = storage.getItem("title");
        var id = storage.getItem("stuID");
        var name = storage.getItem("stuName");
        storage.removeItem("title");
        storage.removeItem("stuID");
        storage.removeItem("stuName");

        return {
            install: function (data) {
                pageData = data;
            },
            getInformation: function(){
                return {
                    title: title,
                    id: id,
                    name: name
                }
            },
            getIndex: function () {
                return index;
            },
            setIndex: function (newIndex) {
                index = newIndex;
            },
            goNext: function () {
                index = index + 1;
                return index;
            },
            goBack: function () {
                index = index - 1;
                return index;
            },
            setQuestionsCount: function (sum) {
                questionsCount = sum;
            },
            getQuestionsCount: function () {
                return questionsCount;
            },
            getDataItem: function () {
                return pageData[index];
            },
            setCompleteTag: function (tag) {
                cTag = tag;
            },
            getCompleteTag: function () {
                return cTag;
            },
            getCorrectAnswers: function () {
                for (var k = 0; k < pageData.length; k++) {
                    correctAnswers.push(pageData[k]['answer']);
                }
                return correctAnswers;
            },
            setSelectAnswers: function (answers) {
                selectAnswers = answers;
            },
            getSelectAnswers: function () {
                return selectAnswers;
            }
        }

    });
