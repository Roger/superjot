package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import utils.KeyInput;
import utils.Recording;


class CustomEntity extends Entity
{
    public function new(x:Float, y:Float, sname:String=null)
    {
        if(sname == null) {
            sname = "randname-" + Math.random();
        }

        this.name = sname;
        super(x, y); // workaround.. Entity.new reset name..
        this.name = sname;
        //lastX = x;
        //lastY = y;
    }

    public override function moveBy(x:Float, y:Float, solidType:Dynamic = null, sweep:Bool = false)
    {
        _moveX += x;
        _moveY += y;
        x = Math.round(_moveX);
        y = Math.round(_moveY);
        _moveX -= x;
        _moveY -= y;
        if (solidType != null)
        {
            var signX:Int, signY:Int, e:Entity;
            if (x != 0 || y != 0)
            {
                var collideX = (collidable && (sweep || collideTypes(solidType, this.x + x, this.y) != null));
                var collideY = (collidable && (sweep || collideTypes(solidType, this.x, this.y + y) != null));

                if(collideX || collideY)
                {
                    signX = x > 0 ? 1 : -1;
                    signY = y > 0 ? 1 : -1;

                    while (true)
                    {
                        if(x != 0){
                            if ((e = collideTypes(solidType, this.x + signX, this.y)) != null)
                            {
                                if (moveCollideX(e)) break;
                                else this.x += signX;
                            }
                            else
                            {
                                this.x += signX;
                            }
                            x -= signX;
                        }


                        if(y != 0) {
                            if ((e = collideTypes(solidType, this.x, this.y + signY)) != null)
                            {
                                if (moveCollideY(e)) break;
                                else this.y += signY;
                            }
                            else
                            {
                                this.y += signY;
                            }
                            y -= signY;
                        }

                        if(x == 0 && y == 0) {
                            break;
                        }
                    }
                }

                if(!collideX) {
                    this.x += x;
                }
                if(!collideY) {
                    this.y += y;
                }
            }
        }
        else
        {
            this.x += x;
            this.y += y;
        }
    }

    public override function update()
    {
        super.update();
        var slowRate:Float = 0.005;
        _elapsed +=  HXP.elapsed;
        if(_elapsed >= slowRate/HXP.rate) {
            _elapsed -= slowRate/HXP.rate;
             Recording.add("move", this);
             lastX = x;
             lastY = y;
             lastAngle = angle;
        }
    }

    public function updateAngle(angle:Float)
    {
        image.angle = angle;
    }

    private var lastX:Float = 0;
    private var lastY:Float = 0;
    private var lastAngle:Float = 0;
    public var angle:Float;
    private var image:Image;
    private var _elapsed:Float = 0;
}
