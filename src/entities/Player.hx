package entities;

import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.utils.Input;


class Player extends CustomEntity
{
    public function new(x:Float, y:Float, name:String="player")
    {
        super(x+18, y+16, name);

        image = new Image("graphics/player.png");

        image.centerOrigin();
        entityMask = new Imagemask(image);
        entityMask.parent = this;
        graphic = image;

        velocity = 0;
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

        entityMask.update();

        handleInput();

        //moveBy(0, velocity, coll);
        moveAtAngle(angle, acceleration, coll);
        super.update();
    }

    private var velocity:Float;
    private var acceleration:Float;
    private var entityMask:Mask;

    private static inline var maxVelocity:Float = 3;
    private static inline var speed:Float = 3;
    private static inline var drag:Float = 0.4;
}
