(function() {
  var NextFlow, next;

  NextFlow = (function() {

    function NextFlow(nextObject) {
      var key, val, _ref;
      this.nextObject = nextObject;
      this.keys = [];
      _ref = this.nextObject;
      for (key in _ref) {
        val = _ref[key];
        if (this.nextObject.hasOwnProperty(key)) this.keys.push(key);
      }
    }

    NextFlow.prototype.next = function() {
      var func, key;
      key = this.keys.shift();
      if (key != null) {
        func = this.nextObject[key];
        return func.apply(this, arguments);
      }
    };

    return NextFlow;

  })();

  next = function(nextObject) {
    var nf;
    nf = new NextFlow(nextObject);
    return nf.next();
  };

  module.exports = next;

}).call(this);
