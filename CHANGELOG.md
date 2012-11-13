0.3.0 / 2012-11-13
------------------
* Rewrote from CoffeeScript to JavaScript.
* Added capability where `this` or `@` is the same as the variable passed into the `next()` function.

0.2.3 / 2012-08-15
------------------
* Fixed bug do to scoping issue when calling a named label from a function outside of nextflow.

0.2.2 / 2012-08-08
------------------
* Fixed regression with came up with the introduction of the `error` method.

0.2.1 / 2012-08-07
------------------
* Added ability to manually call the `error` function.

0.2.0 / 2012-08-06
-----------------
* Added an error handling method.

0.1.2 / 2012-06-29
------------------
* Throws an error if input to `next()` is not an object

0.1.1 / 2012-06-12
------------------
* Bug fix related to `next()` function losing scope of proper `this`

0.1.0 / 2012-06-07
------------------
* Added ability to call function labels directly

0.0.1 / 2012-05-11
------------------
* Initial public release.