exports.createObjectURL = function(blob){
    return function(){
        return window.URL.createObjectURL(blob);
    };
};