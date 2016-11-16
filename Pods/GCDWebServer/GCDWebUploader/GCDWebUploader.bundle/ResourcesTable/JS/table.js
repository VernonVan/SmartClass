/**
 * Created by moyanyuan on 16/9/8.
 */

var _path = null;
var _pendingReloads = [];
var _reloadingDisabled = 0;
var resourcesCount = 0;
var PPTCount = 0;
var li = "";
var url = window.location.href;

function formatFileSize(bytes) {
    if (bytes >= 1000000000) {
        return (bytes / 1000000000).toFixed(2) + ' GB';
    }
    if (bytes >= 1000000) {
        return (bytes / 1000000).toFixed(2) + ' MB';
    }
    return (bytes / 1000).toFixed(2) + ' KB';
}

function _disableReloads() {
    _reloadingDisabled += 1;
}

function _enableReloads() {
    _reloadingDisabled -= 1;

    if (_pendingReloads.length > 0) {
        fresh(_pendingReloads.shift());
    }
}

function fresh(path){

    if (_reloadingDisabled) {
        if ($.inArray(path, _pendingReloads) < 0) {
            _pendingReloads.push(path);
        }
        return;
    }

    _disableReloads();

    if(path == "/PPT") {

        $.ajax({
            url: '/list',
            type: 'GET',
            data: {path: path},
            dataType: 'json',
            cache: true
        }).fail(function (jqXHR, textStatus, errorThrown) {
            alert("获取资源失败!");
        }).done(function (data, textStatus, jqXHR) {

            if(path != _path) {
                _path = "/PPT";
            }
            PPTCount = data.length;

            $.each(data, function (index, item) {

                var newLi = "";
                if(url.indexOf("admin") == -1) {
                    newLi = $('<li class="resourceItem"><span class="resourceTitle"></span> <span class="downloadCell">下载</span> <span class="uploading"></span> </li>');
                }else {
                    newLi = $('<li class="resourceItem"><span class="resourceTitle"></span> <span class="downloadCell">下载</span> <span class="deleteCell">删除</span> <span class="uploading"></span> </li>');
                }
                newLi[0].childNodes[0].innerHTML = item['name'];
                $('.resourceList').append(newLi);

                $('.deleteCell').on('touch click', function(event){
                    if(event.handled !== true) {
                        var deletePath = "/PPT/"+$(this).siblings('.resourceTitle')[0].innerHTML;
                        $.ajax({
                            url: 'delete',
                            type: 'POST',
                            data: {path: deletePath},
                            dataType: 'json'
                        }).fail(function (jqXHR, textStatus, errorThrown) {
                            alert("删除失败!");
                        }).always(function () {
                            reload();
                        });
                        event.handled = true;
                    } else {
                        return false;
                    }
                });

                $('.downloadCell').on('touch click', function(event){
                    if(event.handled !== true) {
                        var downloadPath = "/PPT/"+$(this).siblings('.resourceTitle')[0].innerHTML;
                        setTimeout(function () {
                            window.location = "download?path=" + encodeURIComponent(downloadPath);
                        }, 0);
                        event.handled = true;
                    } else {
                        return false;
                    }
                });

            });
        }).always(function() {
            _enableReloads();
        });
    }else {
        $.ajax({
            url: '/list',
            type: 'GET',
            data: {path: path},
            dataType: 'json',
            cache: true
        }).fail(function (jqXHR, textStatus, errorThrown) {
            alert("获取资源失败!");
        }).done(function (data, textStatus, jqXHR) {

            if(path != _path) {
                _path = "/Resource";
            }
            resourcesCount = data.length;

            $.each(data, function (index, item) {

                var newLi = "";
                if(url.indexOf("admin") == -1) {
                    newLi = $('<li class="resourceItem"><span class="resourceTitle"></span> <span class="downloadCell">下载</span> <span class="uploading"></span> </li>');
                }else {
                    newLi = $('<li class="resourceItem"><span class="resourceTitle"></span> <span class="downloadCell">下载</span> <span class="deleteCell">删除</span> <span class="uploading"></span> </li>');
                }
                newLi[0].childNodes[0].innerHTML = item['name'];
                $('.resourceList').append(newLi);

                $('.deleteCell').on('touch click', function(event){
                    if(event.handled !== true) {
                        var deletePath = "/Resource/"+$(this).siblings('.resourceTitle')[0].innerHTML;
                        $.ajax({
                            url: 'delete',
                            type: 'POST',
                            data: {path: deletePath},
                            dataType: 'json'
                        }).fail(function (jqXHR, textStatus, errorThrown) {
                            alert("删除失败!");
                        }).always(function () {
                            reload();
                        });
                        event.handled = true;
                    } else {
                        return false;
                    }
                });

                $('.downloadCell').on('touch click', function(event){
                    if(event.handled !== true) {
                        var downloadPath = "/Resource/"+$(this).siblings('.resourceTitle')[0].innerHTML;
                        setTimeout(function () {
                            window.location = "download?path=" + encodeURIComponent(downloadPath);
                        }, 0);
                        event.handled = true;
                    } else {
                        return false;
                    }
                });
            });
        }).always(function() {
            _enableReloads();
        });
    }
}

function reload(){
    $('.downloadCell').each(function(){
        $(this).remove();
    });
    $('.deleteCell').each(function(){
        $(this).remove();
    });
    $('.resourceTitle').each(function(){
        $(this).remove();
    });
    $('.resourceItem').each(function(){
        $(this).remove();
    });

    fresh("/PPT");
    fresh("/Resource");
}

$('#upload').on('touch click',function(event){
    event.stopPropagation();
});

$('#upload').fileupload({
    dropZone: $(document),
    pasteZone: null,
    autoUpload: true,
    sequentialUploads: true,

    url: '/upload',
    type: 'POST',
    dataType: 'json',

    start: function (e) {
    },

    stop: function (e) {
        $('.uploading').css('display','none');
    },

    add: function (e, data) {

        var file = data.files[0];
        var type = file['name'].split(".").pop();
        var types = ["ppt","pptx","Ppt","pps"];
        var list = $('.resourceList');
        var liHeight = parseInt(list.children("li").css('height'));

        if(types.indexOf(type) == -1) {

            data.formData = {
                path: "/Resource"
            };
            var createResourceItem = createResourceItem = $('<li class="resourceItem"><span class="resourceTitle"></span> <span class="downloadCell">下载</span> <span class="deleteCell">删除</span> <span class="uploading" style="display: block"></span></li>');
            createResourceItem[0].childNodes[0].innerHTML = file['name'];
            createResourceItem.appendTo(list);
            li = createResourceItem;
            resourcesCount++;
            list.scrollTop((PPTCount+resourcesCount)*liHeight);

        }else {

            data.formData = {
                path: "/PPT"
            };
            var createPPTItem = createPPTItem = $('<li class="resourceItem"><span class="resourceTitle"></span> <span class="downloadCell">下载</span> <span class="deleteCell">删除</span> <span class="uploading" style="display: block"></span></li>');
            createPPTItem[0].childNodes[0].innerHTML = file['name'];
            list.scrollTop((PPTCount+1)*liHeight);
            createPPTItem.appendTo(list);
            li = createPPTItem;
            PPTCount++;
            list.scrollTop((PPTCount+resourcesCount)*liHeight);
        }
        data.submit();

        $('.downloadCell').on('touch click', function(event){
            if(event.handled !== true) {
                alert("in");
                var path = $(this).parent().parent().data("path");
                setTimeout(function () {
                    window.location = "download?path=" + encodeURIComponent(path);
                }, 0);
                event.handled = true;
            } else {
                return false;
            }
        });
    },

    progress: function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        var width = progress + "%";
        li.find('.uploading').css('width',width);
    },

    done: function (e, data) {
        reload();
    },

    fail: function (e, data) {
    },

    always: function (e, data) {
    }

});

$('#refresh').on('touch click', function(event){
    if(event.handled !== true) {
        reload();
        event.handled = true;
    } else {
        return false;
    }
});

reload();