Node.js - NextFlow
==================

A simple control-flow library for Node.js targetted towards CoffeeScript developers.



Why?
----

Take a look at the most prominent JavaScript control flow libraries: [Async.js][1], [Step][2], [Seq][3]. If you were to use these libraries in CoffeeScript, your code would be an ugly mess.

### Async.js / CoffeeScript

```coffee
async = require('async')

async.series(
  (->
    #first function
  ),
  (->
    #second function
  )
)

```

### Step / CoffeeScript

```coffee
Step = require('step')

Step(
  (->
    #first function
  ),
  (->
    #second function
  )
)
```

### Seq / CoffeeScript

```coffee
Seq = require('seq')

Seq().seq(->
  #first function
).seq(->
  #second function
)
```

Yuck. If you're programming in JavaScript, all of them are very usable solutions. Also, to be fair, they do a lot more than NextFlow. But NextFlow looks much nicer with CoffeeScript programs.



Usage
-----

Install:

    npm install --production nextflow

Can be used in the browser too.

Execute sequentially, calling the `next()` function:

```coffee
next = require('nextflow')

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
    console.log vals[0] #is 1
    console.log vals[1] #is 2
    console.log vals[2] #is x
    console.log vals[3] #is 4


```

Call functions by the label:

```coffee
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
    console.log vals[0] #is 1
    console.log vals[1] #is 2
    console.log vals[2] #is x
    console.log vals[3] #is 4

```

Call either `next()` or call the label:

```coffee
vals = []
x = 0
y = 0

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
    y = Math.random()
    @next(y)
  a4: (num) ->
    vals.push(num)
    @a5()
  a5: ->
    console.log vals[0] #is 1
    console.log vals[1] #is 2
    console.log vals[2] #is x
    console.log vals[3] #is y


```

Handle errors in one function:

```coffee
next flow = 
  error: (err) ->
    console.log err.message
  1: ->
    throw new Error('some error')
```

Handle errors by passing them as first params of the @next callback:

```coffee
next flow = 
  error: (err) ->
    console.log err.message #ENOENT, open '/tmp/this_file_hopefully_does_not_exist'
  1: ->
    nonExistentFile = '/tmp/this_file_hopefully_does_not_exist'
    fs.readFile nonExistentFile, @next
```



License
-------

MIT Licensed

Copyright (c) 2012 JP Richardson

[1]: https://github.com/caolan/async
[2]: https://github.com/creationix/step
[3]: https://github.com/substack/node-seq



