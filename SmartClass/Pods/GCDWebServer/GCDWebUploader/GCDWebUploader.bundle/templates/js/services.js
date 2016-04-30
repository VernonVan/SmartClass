angular.module('starter.services', [])


.factory('Books',function($http){
	//获取书信息
	var books = $http.get('/testApp2/www/bookInfo.txt').success(function(data){
	    return data;
	})
	
		return{
		get:function(){
			return books;
		},
		getBook:function(index){
			return books[index];
		}
	}
	
	
}) ;
