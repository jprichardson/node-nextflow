
module.exports = function next(nextObject) {
  if (typeof nextObject !== 'object') throw new Error('next() function expected object.')
  
  var keys = []
    , funcs = []
    , current = null
    , errorFunc = null;
    
  Object.keys(nextObject).forEach(function(key) {
    if (key.toLowerCase() === 'error') {
      errorFunc = nextObject[key]
      delete nextObject[key]
      nextObject['error'] = errorFunc
    } else { //all other methods other than error
      var val = nextObject[key]
      
      keys.push(key);
      funcs.push(val);
      
      (function(key, val) {
        return nextObject[key] = function() {
          current = key;
          return val.apply(nextObject, arguments);
        };
      })(key, val);
    }
  })
    
  function tryIt(callback) {
    try {
      callback()
    } catch (error) {
      if (errorFunc)
        errorFunc(error)
      else 
        throw error
    }
  }
    
  nextObject.next = function(err) {
    if (err && err instanceof Error && errorFunc) return errorFunc(err)
      
    var args = Array.prototype.slice.call(arguments, 0)
      , idx = -1

    if (current === null) {
      current = keys[0];
      tryIt(function() {
        funcs[0].apply(nextObject, args);
      })
    } else {
      idx = keys.indexOf(current)
      idx += 1
      current = keys[idx]
      tryIt(function() {
        funcs[idx].apply(nextObject, args)
      })
    }
  }
    
    nextObject.next()
}

