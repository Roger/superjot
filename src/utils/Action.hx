package utils;

import com.haxepunk.math.Vector;

typedef Action = {
    var name:String; // id
    var type:String; // class
    var angle:Float; // angle of entity
    var action:String; // new, destroy, move
    var position:Vector; // position of entity
    @:optional var target:String;
}
