package entities;

import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.masks.Polygon;

import scenes.GameScene;

class Enemy extends CustomEntity
{
    public function new(x:Float, y:Float, name:String=null)
    {
        super(x, y, name);

        image = new Image("graphics/enemy.png");
        image.centerOrigin();

        entityMask = new Imagemask(image);
        entityMask.parent = this;

        graphic = image;

        velocity = 0;
        type = "enemy";
    }

    public override function update()
    {
       // if (Input.check("up") || Input.check("down") || Input.pressed("shoot") || Input.mousePressed){
            elapsed += HXP.fixed ? 1 / HXP.assignedFrameRate : HXP.elapsed;

            var player = world.getInstance("player");
            if(player == null){
                return;
            }
            this.angle = HXP.angle(this.x, this.y, player.x, player.y);
            image.angle = angle;
            entityMask.update();

            if(elapsed >= 0.2 + HXP.random) {
                scene.add(new Bullet(x, y, angle, "player"));
                elapsed = 0;
            }
        //}
        super.update();
    }

    public override function moveCollideX(e:Entity)
    {
        return false;
    }

    public override function moveCollideY(e:Entity)
    {
        return false;
    }

    private var elapsed:Float = 0;
    private var velocity:Float;
    private var acceleration:Float;
    private var entityMask:Mask;

    private static inline var maxVelocity:Float = 3;
    private static inline var speed:Float = 3;
    private static inline var drag:Float = 0.4;

    private var timeFlowing:Bool = false;
}
