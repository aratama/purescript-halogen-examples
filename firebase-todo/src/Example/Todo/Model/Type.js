exports.readForeignStrMap = function(value){
    return (value !== null && typeof value === "object") ? value : {};
};