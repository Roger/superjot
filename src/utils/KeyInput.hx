package utils;

import com.haxepunk.math.Vector;

typedef KeyInput = {
    var mousePosition:Vector;
    var timeStamp:Float;

    // keys
    var left:Bool;
    var right:Bool;
    var up:Bool;
    var down:Bool;
    var shoot:Bool;

    var force:Bool;
    var replay:Bool;
}
