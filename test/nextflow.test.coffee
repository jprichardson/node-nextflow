tutil = require('testutil')
next = require('../lib/nextflow')
util = require('util')
fs = require('fs-extra')
path = require('path-extra')

describe 'next()', ->
  it "should sequentially execute the functions", (done) ->
    vals = []
    x = 0

    next flow =
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

    

  it 'should execute the functions specified by the label', (done) ->
    vals = []
    x = 0

    next flow =
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

    


  it 'should execute the functions by label or by the function next', (done) ->
    vals = []
    x = 0
    y = 0

    next flow =
      a1: ->
        vals.push(1)
        @a2()
      a2: ->
        vals.push(2)
        x = 'a2'#Math.random()
        @a3(x)
      a3: (num) ->
        vals.push(num)
        y = 'a3'#Math.random()
        @next(y)
      a4: (num) ->
        vals.push(num)
        @a5()
      a5: ->
        console.dir(vals)
        T vals.length == 4
        T vals[0] is 1
        T vals[1] is 2
        T vals[2] is x
        T vals[3] is y
        done()

    

  it 'should execute the next callback', (done) ->
    dir = path.tempdir()
    fs.mkdir dir, (err) ->
      flow =
        first: ->
          fs.exists dir, @next
          #@next(itDoes)
        second: (itDoes) ->
          T itDoes
          done()
      next(flow)



  it 'should throw an error if the parameter is not an object', (done) ->
    flow = -> #<-- notice, the function arrow SHOULD NOT be here
      1: ->
        console.log "Hi, I'll never be executed. =("
        @next()
      2: ->
        console.log 'Please fix me.'
        done() #<---- will never get here

    try 
      next(flow)
    catch err
      T err.message.toLowerCase().indexOf('expected object') >= 0
      done()


  it 'should execute the error function if it exists and an error is passed into the first parameter', (done) ->
    next flow = 
      error: (err) ->
        T err?
        T err.message is 'some error'
        done()
      a1: ->
        @next()
      a2: ->
        @next(new Error('some error'))
       
  it 'should execute the error function if it exists an an error is thrown', (done) ->
    next flow =
      error: (err) ->
        T err?
        T err.message is 'some error'
        done()
      a1: ->
        throw new Error('some error')

  it 'should manually call the error function if it exists', (done) ->
    next flow = 
      error: (err) ->
        T err?
        T err.message is 'manually called'
        done()
      a1: ->
        @error(new Error('manually called'))

  it 'should go to the next method with parameters', (done) ->
    next flow = 
      error: (err) ->
        T err?
        T err instanceof Error
        done(new Error('this shouldnt be called'))
      1: ->
        @next('hi')
      2: (msg) ->
        T msg is 'hi'
        done()

  it 'should have the proper this scope when executing named functions', (done) ->
    obj = 
      doSomething: (callback) ->
        callback()
    
    next flow =
      a1: ->
        @next()
      a2: ->
        obj.doSomething(@a3)
      a3: ->
        done()

  it 'this should be the same as the variable', (done) ->
    next flow =
      a1: ->
        T flow == @
        done()







