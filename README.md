Node.js - NextFlow
==================

A simple control-flow library for Node.js targetted towards CoffeeScript developers. It's JavaScript friendly too.



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

### Regarding Async

There's been some comments made towards my criticism of `async`. Justifiably so. When, I wrote NextFlow, I wasn't aware of 
async's waterfall and object passing capabilities. However, these methods still have their warts. I still believe that NextFlow is a lightweight library compared to async's do everything approach, I also think that NextFlow's syntax is much more pleasing, even for JavaScript development.



Installation
------------

    npm install nextflow



Usage
-----


#### Sequentially, calling the `next()` function, pass arguments to `next()` if you'd like:

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


#### Call functions by the label, pass arguments too:

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


#### Call either `next()` or call the label:

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

#### Error Handling 

Handle errors in one function. Label it `error:`, `ERROR:` or `ErRoR`. Case doesn't matter.

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

Manually call the error function if you want

```coffee
next flow = 
  error: (err) ->
    console.log err.message #"I feel like calling an error."
  a1: ->
    @error(new Error("I feel like calling an error."))
```



JavaScript Friendly
------------------

Example pulled from [Rock][rock]. Also uses [BatchFlow][batchflow].

```javascript
next({
    ERROR: function(err) {
        console.error(err);
    },
    isRepoPathLocal: function() {
        fs.exists(repoPath, this.next);
    },
    copyIfLocal: function(itsLocal) {
        if (itsLocal) {
            fs.copy(repoPath, projectPath, this.gitDirExist);
        } else {
            this.next();
        }
    },
    execGit: function() {
        exec(util.format("git clone %s %s", repoPath, projectPath), this.next);
    },
    gitDirExist: function(params) {
        fs.exists(path.join(projectPath, '.git'), this.next);
    },
    removeGitDir: function(gdirExists) {
        if (gdirExists)
            fs.remove(path.join(projectPath, '.git'), this.next);
        else
            this.next();
    },
    checkRockConf: function() {
        fs.exists(projectRockConf, this.next);
    },
    loadRockConf: function(rockConfExists) {
        if (rockConfExists)
            fs.readFile(projectRockConf, this.next);
        else
            this.next();
    },
    walkFiles: function(err, data) {
        var files = [], self = this; ignoreDirs = [];

        if (data) {
            projectRockObj = JSON.parse(data.toString());
            ignoreDirs = projectRockObj.ignoreDirs;
            if (ignoreDirs) {
                for (var i = 0; i < ignoreDirs.length; ++i) {
                    ignoreDirs[i] = path.resolve(projectPath, ignoreDirs[i]);
                }
            } else {
                ignoreDirs = [];
            }
        }

        walker(projectPath)
          .filterDir(function(dir, stat) { 
            if (dir === projectRockPath)
                return false;
            else
                if (ignoreDirs.indexOf(dir) >= 0) 
                    return false;
                else
                    return true;
          })
          .on('file', function(file) { files.push(file) })
          .on('end', function() { self.next(files); });
    },
    tweezeFiles: function(files) {
        tweezers.readFilesAndExtractUniq(files, this.next);
    },
    promptUser: function(err, tokenObj) {
        var replacements = {}, self = this;

        var rl = readline.createInterface({input: process.stdin, output: process.stdout})
        
        batch(tokenObj.tokens).seq().each(function(i, token, done) { 
            if (_(getSystemTokens()).keys().indexOf(token) === -1) {
                rl.question(token + ': ', function(input){
                    replacements[token] = input.trim();
                    done();
                });
            } else {
                replacements[token] = getSystemTokens()[token];
                done();
            }
        }).end(function(){
            rl.close();
            endCallback();
        });
    }
});
```


Browser Compatibility
---------------------

I haven't made this browser compatible just yet, but you can do so with a simple modification of attaching `next` to the `window` object. Although, I caution you to test thoroughly, as this module depends upon stability of insertion order into the objects. If this is violated, you're going to have problems. It's my understanding that this is not part of the ECMA standard despite most browsers adhering to this.

Read this discussion for more information: 
http://code.google.com/p/v8/issues/detail?id=164



License
-------

MIT Licensed

Copyright (c) 2012 JP Richardson

[1]: https://github.com/caolan/async
[2]: https://github.com/creationix/step
[3]: https://github.com/substack/node-seq
[rock]: https://github.com/rocktemplates/rock
[batchflow]: https://github.com/jprichardson/node-batchflow



