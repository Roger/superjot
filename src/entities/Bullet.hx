package entities;

import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.graphics.Image;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import com.haxepunk.HXP;

import utils.Recording;


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

class Bullet extends CustomEntity
{
    public function new(x:Float, y:Float, angle:Float, target:String, name:String=null)
    {
        super(x, y, name);

        coll =  [target, "solid", "bullet"];

        this.angle = angle;
        this.target = target;
        var color:Int = 0xcc0000;
        if(target == "enemy") {
            color = 0xffffff;
        }
        image = Image.createRect(4, 2, color);
        image.centerOrigin();
        image.angle = angle;
        entityMask = new Imagemask(image);
        entityMask.parent = this;

        graphic = image;

        moveAtAngle(angle, acceleration, coll);
        type = "bullet";
    }

    private function handleInput()
    {
        acceleration = 10;

        if (Input.check("up") || Input.check("down") || Input.pressed("shoot") || Input.mousePressed)
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
            if(target == "player") {
                scene.end();
            }

            Recording.add("explode", this, target);
        } else if(e.type == "bullet" && cast(e, Bullet).target != this.target) {
            scene.remove(e);
            var explosion:Explosion = new Explosion(e.x, e.y, 0xdadada);
            this.scene.add(explosion);
            explosion.explode(angle, 2);
            Recording.add("explode", this, "bullet");
        } else if(e.type == "solid") {
            var explosion:Explosion = new Explosion(x, y, 0xdadada);
            this.scene.add(explosion);
            explosion.explode(angle, 2);
            Recording.add("explode", this, "bullet");
        } else if(e.type == "bullet") {
            return false;
        }

        scene.remove(this);
        return true;
    }

    public override function update()
    {
        acceleration = 500 * HXP.elapsed;
        moveAtAngle(angle, acceleration, coll);
        super.update();
    }

    private var coll:Array<String>;
    private var acceleration:Float = 10;
    private var entityMask:Mask;
    public var target:String;
}
