package utils;

import com.haxepunk.math.Vector;

import entities.CustomEntity;
import entities.Bullet;


typedef Frame = {
    var actions:Array<Action>;
}

class Recording
{
    public static var slowRate:Float = 0.005;
    public static var frames:Array<Frame> = [];
    public static var actionsToPush:Array<Action> = [];

    public static function add(action:String, entity:Dynamic)
    {
        var entity:CustomEntity = cast(entity, CustomEntity);
        var action:Action = {
            action: action,
            type: entity.type,
            name: entity.name,
            angle: entity.angle,
            position: new Vector(entity.x, entity.y)
        };
        if(entity.type == "bullet") action.target = cast(entity, Bullet).target;
        actionsToPush.push(action);
    }

    // sync in update only
    public static function update()
    {
        if(actionsToPush.length > 0) {
            var frame:Frame = {actions: actionsToPush.copy()};
            frames.push(frame);
            actionsToPush = [];
        }
    }

    public static function print()
    {
        for(frame in frames) {
            trace("------");
            trace(frame.actions);
        }
    }
}
