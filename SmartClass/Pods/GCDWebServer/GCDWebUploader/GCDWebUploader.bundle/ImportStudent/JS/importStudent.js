/**
 * Created by moyanyuan on 16/9/20.
 */
var X = XLSX;
var XW = {
    msg: 'xlsx',
    rABS: './xlsxworker2.js',
    norABS: './xlsxworker1.js',
    noxfer: './xlsxworker.js'
};

var rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";

var use_worker = typeof Worker !== 'undefined';

var transferable = use_worker;

var wtf_mode = false;

function fixdata(data) {
    var o = "", l = 0, w = 10240;
    for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
    o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));//处理剩下不整w长
    return o;
}

function ab2str(data) {
    var o = "", l = 0, w = 10240;
    for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint16Array(data.slice(l * w, l * w + w)));
    o += String.fromCharCode.apply(null, new Uint16Array(data.slice(l * w)));
    return o;
}

function s2ab(s) {
    var b = new ArrayBuffer(s.length * 2), v = new Uint16Array(b);
    for (var i = 0; i != s.length; ++i) v[i] = s.charCodeAt(i);
    return [v, b];
}

function xw_noxfer(data, cb) {
    var worker = new Worker(XW.noxfer);
    worker.onmessage = function (e) {
        switch (e.data.t) {
            case 'ready':
                break;
            case 'e':
                console.error(e.data.d);
                break;
            case XW.msg:
                cb(JSON.parse(e.data.d));
                break;
        }
    };
    var arr = rABS ? data : btoa(fixdata(data));
    worker.postMessage({d: arr, b: rABS});
}

function xw_xfer(data, cb) {
    var worker = new Worker(rABS ? XW.rABS : XW.norABS);
    worker.onmessage = function (e) {
        switch (e.data.t) {
            case 'ready':
                break;
            case 'e':
                console.error(e.data.d);
                break;
            default:
                xx = ab2str(e.data).replace(/\n/g, "\\n").replace(/\r/g, "\\r");
                console.log("done");
                cb(JSON.parse(xx));
                break;
        }
    };
    if (rABS) {
        var val = s2ab(data);
        worker.postMessage(val[1], [val[1]]);
    } else {
        worker.postMessage(data, [data]);
    }
}

function xw(data, cb) {
    transferable = false;
    if (transferable) xw_xfer(data, cb);
    else xw_noxfer(data, cb);
}

function get_radio_value(radioName) {
    var radios = document.getElementsByName(radioName);
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked || radios.length === 1) {
            return radios[i].value;
        }
    }
}

function to_json(workbook) {
    var result = {};
    workbook.SheetNames.forEach(function (sheetName) {
        var roa = X.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
        if (roa.length > 0) {
            result[sheetName] = roa;
        }
    });
    return result;
}

//输出数据
function process_wb(wb) {
    //dataStr = JSON.stringify(to_json(wb), 2, 2);
    var dataObj = to_json(wb);
    $.post('/studentList',dataObj);
    alert("导入成功...");
    //console.log(dataObj);
    $('#studentTable').empty();
    var head = $('<tr><th style="border-bottom: 1px solid rgb(228,228,228)">学号</th><th style="border-bottom: 1px solid rgb(228,228,228)">姓名</th><th style="border-bottom: 1px solid rgb(228,228,228)">学校</th><th style="border-bottom: 1px solid rgb(228,228,228)">专业</th></tr>');
    head.appendTo('#studentTable');
    $.each(dataObj['table'],function(index,item){
        var row = $('<tr></tr>');
        $.each(item,function(k,v){
            var cell = $('<td></td>');
            cell.text(v);
            cell.appendTo(row);
        });
        row.appendTo('#studentTable');
    });
}

var xlf = document.getElementById('import');
function handleFile(e) {
    rABS = false;
    use_worker = false;
    var files = e.target.files;
    var f = files[0];
    {
        var reader = new FileReader();
        var name = f.name;
        var type = name.split(".").pop();
        var types = ["xlsx"];
        if(types.indexOf(type) != -1) {
            reader.onload = function (e) {
                if (typeof console !== 'undefined') console.log("onload", new Date(), rABS, use_worker);
                var data = e.target.result;
                if (use_worker) {
                    xw(data, process_wb);
                } else {
                    var wb;
                    if (rABS) {
                        wb = X.read(data, {type: 'binary'});
                    } else {
                        var arr = fixdata(data);
                        wb = X.read(btoa(arr), {type: 'base64'});
                    }
                    process_wb(wb);
                }
            };
            if (rABS) reader.readAsBinaryString(f);
            else reader.readAsArrayBuffer(f);
            $('.importError').css('display','none');
        }else {
            $('.importError').css('display','block');
        }
    }
}

if (xlf.addEventListener) xlf.addEventListener('change', handleFile, false);