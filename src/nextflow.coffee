
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

  nextObject.next = (err) =>
    if err? and err instanceof Error and errorFunc?
      errorFunc(err)
      return

    if current is null
      current = keys[0]
      try
        funcs[0].apply(nextObject, arguments)
      catch error
        if errorFunc?
          errorFunc(error)
        else
          throw error
    else
      idx = keys.indexOf(current)
      idx += 1
      current = keys[idx]
      try
        funcs[idx].apply(nextObject, arguments)
      catch error
        if errorFunc?
          errorFunc(error)
        else
          throw error

  nextObject.next()
###




