package entities;

import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.masks.Circle;
import com.haxepunk.graphics.Image;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import com.haxepunk.HXP;

import utils.Recording;


class Bullet extends CustomEntity
{
    public function new(x:Float, y:Float, angle:Float, target:String, name:String=null)
    {

        super(x, y, name);

        coll =  [target, "solid", "bullet"];

        this.target = target;

        var color:Int = 0xcc0000;
        if(target == "enemy") {
            color = 0xffffff;
        }

        image = Image.createRect(4, 2, color);

        this.angle = angle;
        graphic = image;
        image.centerOrigin();
        image.angle = angle;

        mask = new Circle(3, cast(image.x - 3), cast(image.y - 3));

        moveAtAngle(angle, 2, coll, true);

        type = "bullet";

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
            this.active = false;
        } else if(e.type == "solid") {
            var explosion:Explosion = new Explosion(x, y, 0xdadada);
            this.scene.add(explosion);
            explosion.explode(angle, 2);
            Recording.add("explode", this, "bullet");
            this.active = false;
        } else if(e.type == "bullet") {
            return false;
        }

        scene.remove(this);
        this.active = false;
        return true;
    }

    public override function update()
    {
        acceleration = (500 * HXP.elapsed);
        if(Recording.slowRate != HXP.rate) {
            acceleration /= 5;
            if(this.active) moveAtAngle(angle, acceleration, coll);
            if(this.active) moveAtAngle(angle, acceleration, coll);
            if(this.active) moveAtAngle(angle, acceleration, coll);
            if(this.active) moveAtAngle(angle, acceleration, coll);
        }
        if(this.active) moveAtAngle(angle, acceleration, coll);

        super.update();
    }

    private var coll:Array<String>;
    private var acceleration:Float = 10;
    public var target:String;
}
