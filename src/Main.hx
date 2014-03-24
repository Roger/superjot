import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Main extends Engine
{
    public function new ()
    {
        //super(640, 480, 60);
        super();
    }

    override public function init()
    {
        // defines left and right as arrow keys and WASD controls
        Input.define("left", [Key.LEFT, Key.A]);
        Input.define("right", [Key.RIGHT, Key.D]);
        Input.define("up", [Key.UP, Key.W]);
        Input.define("down", [Key.DOWN, Key.S]);
        Input.define("shoot", [Key.SPACE, Key.Q]);

    #if debug
        HXP.console.enable();
    #end
        HXP.scene = new scenes.GameScene();
    }

    public static function main()
    {
        new Main();
    }

}
