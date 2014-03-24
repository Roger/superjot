package entities;

import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.graphics.Image;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

import com.haxepunk.HXP;


class CustomEmitter extends Emitter
{
    private function handleInput()
    {
        timeFlowing = false;
        if (Input.check("up") || Input.check("down"))
        {
            timeFlowing = true;
        }
    }
    override public function update()
    {
        handleInput();

        if(timeFlowing) {
            super.update();
            elapsed = 0;
        } else {
            elapsed += HXP.fixed ? 1 / HXP.assignedFrameRate : HXP.elapsed;
            if(elapsed >= 1) {
                super.update();
                elapsed = 0;
            }
        }
    }
    private var timeFlowing:Bool = false;
    private var elapsed:Float = 0;
}

class Explosion extends Entity
{
    public function new(x:Float, y:Float, color:Int)
    {
        super(x, y);
        this.color = color;
    }

    public function explode(angle:Float, size:Int)
    {

        _emitter = new CustomEmitter("graphics/particle.png", size, size);
        graphic = _emitter;

        _emitter.newType("explode", [0]);
        _emitter.setMotion("explode", // name
                           angle, // angle
                           20, // distance
                           0.5, // duration
                           30,  // ? angle range
                           0, // ? distance range
                           0, // ? Duration range
                           Ease.quadOut // ? Easing
                          );

        _emitter.setAlpha("explode", 10, 0);
        _emitter.setColor("explode", color, color);
        _emitter.setGravity("explode", 0, 0);

        for(i in 0...10) {
            _emitter.emitInCircle("explode", this.originX, this.originY, 10);
        }
    }

    private var _emitter:Emitter;
    private var color:Int;
}

class Trail extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
    }

    override public function update()
    {
        super.update();
        elapsed += HXP.fixed ? 1 / HXP.assignedFrameRate : HXP.elapsed;
    }

    private var timeFlowing:Bool = false;
    private var elapsed:Float = 0;
}

class Bullet extends Entity
{
    public function new(x:Float, y:Float, angle:Float, target:String)
    {
        super(x, y);
        coll =  [target, "solid", "bullet"];

        this.angle = angle;
        this.target = target;
        image = Image.createRect(4, 2, 0xffffff);
        image.centerOrigin();
        image.angle = angle;
        entityMask = new Imagemask(image);
        entityMask.assignTo(this);

        graphic = image;

        moveAtAngle(angle, acceleration, coll);
        type = "bullet";
    }

    private function handleInput()
    {
        acceleration = 0.005;

        if (Input.check("up") || Input.check("down") || Input.check("shoot"))
        {
            acceleration = 10;
        }
    }

    public override function moveCollideX(e:Entity)
    {
        return moveCollide(e);
    }

    public override function moveCollideY(e:Entity)
    {
        return moveCollide(e);
    }

    private function moveCollide(e:Entity)
    {
        if(e.type == target) {
            scene.remove(e);
            var explosion:Explosion = new Explosion(e.x, e.y, 0xff0000);
            this.scene.add(explosion);
            explosion.explode(angle, 4);
        } else if(e.type == "bullet") {
            scene.remove(e);
            var explosion:Explosion = new Explosion(e.x, e.y, 0xdadada);
            this.scene.add(explosion);
            explosion.explode(angle, 2);
        }

        if(target == "player") {
            scene.end();
        }
        scene.remove(this);
        return true;
    }

    public override function update()
    {
        handleInput();
        moveAtAngle(angle, acceleration, coll);
        super.update();
    }

    private var coll:Array<String>;
    private var angle:Float;
    private var acceleration:Float = 10;
    private var image:Image;
    private var entityMask:Mask;
    private var target:String;
}
