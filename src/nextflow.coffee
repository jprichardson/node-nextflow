
class NextFlow
  constructor: (@nextObject) ->
    @keys = []
    @funcs = []
    @current = null
    @errorFunc = null

    @_checkForErrorFunction()

    for key,val of @nextObject
      if @nextObject.hasOwnProperty(key)
        @keys.push(key)
        @funcs.push(val)
        do (key, val) => 
          @[key] = ->
            @current = key
            val.apply(@, arguments)
  
  error: =>
    if @errorFunc?
      @errorFunc.apply(@, arguments)
    else
      throw new Error('Error function not set.')      

  next: (err) =>
    if err? and err instanceof Error and @errorFunc?
      @errorFunc(err)
      return

    if @current is null
      @current = @keys[0]
      try
        @funcs[0].apply(@, arguments)
      catch error
        if @errorFunc?
          @errorFunc(error)
        else
          throw error
    else
      idx = @keys.indexOf(@current)
      idx += 1
      @current = @keys[idx]
      try
        @funcs[idx].apply(@, arguments)
      catch error
        if @errorFunc?
          @errorFunc(error)
        else
          throw error
      

  _checkForErrorFunction: ->
    for key,val of @nextObject
      if @nextObject.hasOwnProperty(key)
        if key.toLowerCase() is 'error'
          @errorFunc = val
          delete @nextObject[key]
          


next = (nextObject) ->
  if typeof nextObject isnt 'object'
    throw new Error('next() function expected object.')

  nf = new NextFlow(nextObject)
  nf.next()

module.exports = next