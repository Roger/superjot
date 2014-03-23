import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{
    public function new ()
    {
        //super(640, 480, 60);
        super();
    }

    override public function init()
    {
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
