tutil = require('testutil')
next = require('../lib/nextflow')
util = require('util')
fs = require('fs-extra')
path = require('path-extra')

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

  it 'should execute the functions specified by the label', (done) ->
    vals = []
    x = 0

    flow =
      a1: ->
        vals.push(1)
        @a2()
      a2: ->
        vals.push(2)
        x = Math.random()
        @a3(x)
      a3: (num) ->
        vals.push(num)
        @a4()
      a4: ->
        vals.push(4)
        @a5()
      a5: ->
        T vals[0] is 1
        T vals[1] is 2
        T vals[2] is x
        T vals[3] is 4
        done()

    next(flow)


  it 'should execute the functions by label or by the function next', (done) ->
    vals = []
    x = 0
    y = 0

    flow =
      a1: ->
        vals.push(1)
        @a2()
      a2: ->
        vals.push(2)
        x = Math.random()
        @a3(x)
      a3: (num) ->
        vals.push(num)
        y = Math.random()
        @next(y)
      a4: (num) ->
        vals.push(num)
        @a5()
      a5: ->
        T vals[0] is 1
        T vals[1] is 2
        T vals[2] is x
        T vals[3] is y
        done()

    next(flow)

  it 'should execute the next callback', (done) ->
    dir = path.tempdir()
    fs.mkdir dir, (err) ->
      T err is null

      flow =
        first: ->
          fs.exists dir, @next
          #@next(itDoes)
        second: (itDoes) ->
          T itDoes
          done()
      next(flow)




