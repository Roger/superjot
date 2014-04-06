package entities;

import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Polygon;

import scenes.GameScene;

class Enemy extends CustomEntity
{
    public function new(x:Float, y:Float, name:String=null)
    {
        image = new Image("graphics/enemy.png");
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

        elapsed = (10 * HXP.random)/20;

        type = "enemy";
    }

    public override function update()
    {
        elapsed += HXP.elapsed;
        elapsed += (10 * HXP.random) / (80/HXP.rate);

        var player = world.getInstance("player");
        if(player == null){
            return;
        }
        this.angle = HXP.angle(this.x, this.y, player.x, player.y);
        image.angle = angle;

        cast(mask, Polygon).angle = angle;
        mask.update();

        if(elapsed >= 2) {
            scene.add(new Bullet(x, y, angle, "player"));
            elapsed = 0;
        }
        super.update();
    }

    private var elapsed:Float = 0;
    private var velocity:Float;
    private var acceleration:Float;

    private static inline var maxVelocity:Float = 3;
    private static inline var speed:Float = 3;
    private static inline var drag:Float = 0.4;

    private var timeFlowing:Bool = false;
}
