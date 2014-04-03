package entities;

import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Polygon;
import com.haxepunk.utils.Input;

import flash.geom.Point;


class Player extends CustomEntity
{
    public function new(x:Float, y:Float, name:String="player")
    {
        image = new Image("graphics/player.png");
        var h:Int = image.height;
        var w:Int = image.width;

        super(x+w/2, y+h/2, name);
        graphic = image;
        image.centerOrigin();

        mask = Polygon.createFromArray([
                -h/2, -w/2,
                image.width-w/2, -w/2,
                image.width-w/2, image.height-w/2,
                0-w/2, image.height-w/2]);

        type = "player";
    }

    private function handleInput()
    {
        acceleration = 0;

        if (Input.check("up"))
        {
            acceleration = 100 * HXP.elapsed;
        }

        if (Input.check("down"))
        {
            acceleration = -100 * HXP.elapsed;
        }

        if (Input.pressed("shoot") || Input.mousePressed)
        {
            scene.add(new Bullet(x, y, angle, "enemy"));
        }
    }

    private function move()
    {
        velocity += acceleration * speed;
        if (Math.abs(velocity) > maxVelocity)
        {
            velocity = maxVelocity * HXP.sign(velocity);
        }

        if (velocity < 0)
        {
            velocity = Math.min(velocity + drag, 0);
        }
        else if (velocity > 0)
        {
            velocity = Math.max(velocity - drag, 0);
        }
    }

    public override function update()
    {
        var coll =  ["enemy", "solid"];

        if(this.x == world.mouseX && this.y == world.mouseY)
        {
            return;
        }

        angle = HXP.angle(this.x, this.y, world.mouseX, world.mouseY);
        image.angle = angle;

        cast(mask, Polygon).angle = angle;
        mask.update();

        handleInput();

        //moveBy(0, velocity, coll);
        moveAtAngle(angle, acceleration, coll);
        super.update();
    }

    private var velocity:Float = 0;
    private var acceleration:Float;

    private static inline var maxVelocity:Float = 3;
    private static inline var speed:Float = 3;
    private static inline var drag:Float = 0.4;
}
