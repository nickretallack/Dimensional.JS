Dimensional JavaScript
=====================

This simple library lets you add, subtract, multiply, and divide physical quantities with dimensions in space and time, like meters and seconds.  You can add different units together and conversions will be applied automatically (5m + 20cm = 5.2m), or it will throw an exception if your dimensions don't match (5m + 12s = a problem).  If you multiply or divide quantities, the result will show up with proper dimensions (5m / 12s = 0.5m/s).  It can handle as many dimensios as you want (5m^2/s^3 * 2s^5 = 10m^2 s^2).

Try it!
-------

Open example/index.html to see it run before your eyes!  As you can see, it's a [RequireJS](http://requirejs.org/) module written in [CoffeeScript](http://jashkenas.github.com/coffee-script/) and everything you need is included in the example directory.  If for some reason you don't like CoffeeScript or RequireJS, you can run the CoffeeScript compiler or the RequireJS build tool on it to get a regular old JavaScript file to play with.

Extensible
----------

It works with whatever units and dimensions are specified in conversions.coffee.  Feel free to add your own, like grams, bytes, hertz, etc.  I'll add more soon too.  Unfortunately, there's no support yet for aggregate units like liters that express several dimensions at once.  If you can find a good way to support these, please fork and do so!
