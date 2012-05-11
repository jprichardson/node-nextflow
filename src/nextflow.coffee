
class NextFlow
  constructor: (@nextObject) ->
    #@keys = _(@nextObject).keys()
    @keys = []
    for key,val of @nextObject
      if @nextObject.hasOwnProperty(key)
        @keys.push(key)

  next: ->
    key = @keys.shift()
    #console.log "\n#{key} Count: #{@keys.length}"
    if key?
      func = @nextObject[key]
      func.apply(@, arguments)

next = (nextObject) ->
  nf = new NextFlow(nextObject)
  nf.next()

module.exports = next