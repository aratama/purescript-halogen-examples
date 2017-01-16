exports.requestAnimationFrame = function(callback){
    return function(){
        window.requestAnimationFrame(callback);
    }
}

exports.now = function(){
    return performance.now();
}