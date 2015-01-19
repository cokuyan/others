Function.prototype.myBind = function (context) {
  var fn = this;
  
  return function (fn, context) {
    fn.apply(context);
  };

};
