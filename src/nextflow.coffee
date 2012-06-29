
class NextFlow
  constructor: (@nextObject) ->
    @keys = []
    @funcs = []
    @current = null
    for key,val of @nextObject
      if @nextObject.hasOwnProperty(key)
        @keys.push(key)
        @funcs.push(val)
        do (key, val) => 
          @[key] = ->
            @current = key
            val.apply(@, arguments)
          

  next: =>
    if @current is null
      @current = @keys[0]
      @funcs[0].apply(@, arguments)
    else
      idx = @keys.indexOf(@current)
      idx += 1
      @current = @keys[idx]
      @funcs[idx].apply(@, arguments)


next = (nextObject) ->
  if typeof nextObject isnt 'object'
    throw new Error('next() function expected object.')

  nf = new NextFlow(nextObject)
  nf.next()

module.exports = next