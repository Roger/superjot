package entities;

import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Imagemask;

class Enemy extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        image = Image.createRect(16, 16, 0xFF0000);
        //image.centerOrigin();

        entityMask = new Imagemask(image);
        entityMask.assignTo(this);

        graphic = image;

        velocity = 0;
        type = "enemy";
    }

    public override function moveCollideX(e:Entity)
    {
        return false;
    }

    public override function moveCollideY(e:Entity)
    {
        return false;
    }

    private var velocity:Float;
    private var acceleration:Float;
    private var angle:Float;
    private var image:Image;
    private var entityMask:Mask;

    private static inline var maxVelocity:Float = 3;
    private static inline var speed:Float = 3;
    private static inline var drag:Float = 0.4;
}
