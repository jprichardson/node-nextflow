
module.exports = (nextObject) ->
  if typeof nextObject isnt 'object'
    throw new Error('next() function expected object.')

  keys = []
  funcs = []
  current = null
  errorFunc = null

  Object.keys(nextObject).forEach (key) =>
    if (key.toLowerCase() is 'error')
      errorFunc = nextObject[key]
      delete nextObject[key]
      nextObject['error'] = errorFunc

  for key,val of nextObject
    if nextObject.hasOwnProperty(key)
      keys.push(key)
      funcs.push(val)
      do (key, val) => 
        nextObject[key] = =>
          current = key
          val.apply(nextObject, arguments)

  tryIt = (callback) ->
    try
      callback()
    catch error
      if errorFunc
        errorFunc(error)
      else
        throw error

      

  nextObject.next = (err) =>
    if err? and err instanceof Error and errorFunc?
      errorFunc(err)
      return

    args = Array.prototype.slice.call(arguments, 0)

    if current is null
      current = keys[0]
      tryIt ->
        funcs[0].apply(nextObject, args)
     
    else
      idx = keys.indexOf(current)
      idx += 1
      current = keys[idx]
      tryIt ->
        funcs[idx].apply(nextObject, args)
     

  nextObject.next()
###




