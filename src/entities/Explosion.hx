package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.utils.Ease;
import com.haxepunk.graphics.Emitter;

import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

import utils.Recording;


class Explosion extends Entity
{
    public function new(x:Float, y:Float, color:Int)
    {
        super(x, y);
        this.color = color;
    }

    public function explode(angle:Float, size:Int)
    {

        _emitter = new Emitter("graphics/particle.png", size, size);
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

    public override function update()
    {
        super.update();
        if(_emitter.particleCount == 0) {
            scene.remove(this);
        }
    }

    private var _emitter:Emitter;
    private var color:Int;
}

