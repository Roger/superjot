package entities;

import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;


class Player extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x+18, y+16);

        //image = new Spritemap("graphics/player.png", 9, 16);
        //image.scale = 2;
        //image.add("idle", [0]);
        //// we set a speed to the walk animation
        //image.add("walk", [1, 2, 3, 2], 12);
        //// tell the image to play the idle animation
        //image.play("idle");

        image = Image.createRect(16, 16, 0xFFFFFF);
        //image = new Image("graphics/you.png");

        image.centerOrigin();
        entityMask = new Imagemask(image);
        entityMask.assignTo(this);
        graphic = image;

        //setHitbox(32, 32);

        // defines left and right as arrow keys and WASD controls
        Input.define("left", [Key.LEFT, Key.A]);
        Input.define("right", [Key.RIGHT, Key.D]);
        Input.define("up", [Key.UP, Key.W]);
        Input.define("down", [Key.DOWN, Key.S]);

        Input.define("shoot", [Key.SPACE, Key.Q]);

        velocity = 0;
        type = "player";
        name = "player";
    }

    private function handleInput()
    {
        acceleration = 0;

        if (Input.check("up"))
        {
            acceleration = 1;
        }

        if (Input.check("down"))
        {
            acceleration = -1;
        }

        if (Input.pressed("shoot"))
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
        move();

        //moveBy(0, velocity, coll);
        moveAtAngle(angle, velocity, coll);
        super.update();
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
