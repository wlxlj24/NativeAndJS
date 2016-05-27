
function testInJS(message) {
    log(message);
}



$(function(){
 log('必包函数内')
 var str = native.jsGetNativeStringData();
 log('必包函数内 string: ' + str)

 })();