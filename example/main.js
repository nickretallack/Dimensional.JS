require([
    "cs!dimensional"
], function(dimensional){
    var Unit = dimensional.Unit

    var say = function(message){
        html = '<p>' + message + '<p>'
        document.body.innerHTML += html
    }

    say("500cm/s^2 / 10m = " + Unit(500, 'cm/s^2').over(Unit(10, 'm')).show())
    say("12cm * 30m + 1km^2 = " + Unit(50,'cm').times(Unit(30,'m')).plus(Unit(1, 'km^2')).show())
    say("5m/s * 52s = " + Unit(5,'m/s').times(Unit(52,'s')).show())
    say("1/(25m/s^2) = " + Unit(25,'m/s^').reciprocal().show())
    say("0.1mi + 5ft + 20in + 300cm = " + Unit(0.1,'mi').plus(Unit(5,'ft')).plus(Unit(20,'in')).plus(Unit(300,'cm')).show())
})
