util = require('testutil')
next = require('../lib/nextflow')

describe 'next()', ->
  it "should sequentially execute the functions", (done) ->
    vals = []
    x = 0

    flow =
      1: ->
        vals.push(1)
        @next()
      2: ->
        vals.push(2)
        x = Math.random()
        @next(x)
      3: (num) ->
        vals.push(num)
        @next()
      4: ->
        vals.push(4)
        @next()
      5: ->
        T vals[0] is 1
        T vals[1] is 2
        T vals[2] is x
        T vals[3] is 4
        done()

    next(flow)

