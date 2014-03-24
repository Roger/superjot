package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import entities.Player;
import entities.Bullet;
import entities.Enemy;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

import com.haxepunk.graphics.Text;

class TitleScreen extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        var image:Image = Image.createRect(HXP.screen.width, HXP.screen.height, 0x000000);
        image.alpha = .98;
        graphic = image;

        statusText = new Text();
        superJotText = new Text();
        clickText = new Text();

        statusText.resizable = true;
        statusText.color = 0xff0000;
        statusText.size = 40;
        statusText.richText = "";
        statusText.y = 40;
        statusText.x = HXP.screen.width / 2 - statusText.width/2;

        superJotText.resizable = true;
        superJotText.color = 0xff0000;
        superJotText.size = 80;
        superJotText.richText = "SuperJot";
        superJotText.y = HXP.screen.height / 2;
        superJotText.x = HXP.screen.width / 2 - superJotText.width/2;

        clickText.resizable = true;
        clickText.color = 0xff0000;
        clickText.size = 25;
        clickText.richText = "Click to Start";
        clickText.y = HXP.screen.height - clickText.height;
        clickText.x = HXP.screen.width - clickText.width;

        this.addGraphic(statusText);
        this.addGraphic(superJotText);
        this.addGraphic(clickText);
    }

    public function updateText(text:String)
    {
        statusText.richText = text;
        statusText.x = HXP.screen.width / 2 - statusText.width/2;
    }

     public override function update()
     {
         if(Input.mousePressed)
         {
            visible = false;
         }
         super.update();
     }
    private var superJotText:Text;
    private var clickText:Text;
    private var statusText:Text;
}

class GameScene extends Scene
{

 public function new()
 {
    super();
 }

 public function createMap()
 {
   // load map
   var map = TmxMap.loadFromFile("maps/level"+level+".tmx");
   name = map.properties.resolve("name");

   // create entity map
   var e_map = new TmxEntity(map);

   e_map.loadGraphic("graphics/tileset.png", ["layer"]);

   // loads a grid layer named collision and sets the entity type to walls
   e_map.loadMask("collision", "solid");

   entityList = [];

   for(object in map.getObjectGroup("objects").objects)
   {
     switch(object.type)
     {
        case "platform":
            trace("Platform!");
        case "player":
            var player:Player = new Player(object.x, object.y);
            player.active = false;
            entityList.push(player);
            add(player);
        case "enemy":
            var enemy:Enemy = new Enemy(object.x, object.y);
            enemy.active = false;
            add(enemy);
            entityList.push(enemy);
            numberEnemies++;
        default:
            trace("unknown type: " + object.type);
     }
   }
   return e_map;

 }

 private function addOverlay()
 {
    //overlayText = new Text(" = " + numberEnemies, 0, 0, 0, 0, { color:0x000000, size:30 } );
    overlayText = new Text();
    overlayText.resizable = true;
    overlayText.color = 0x000000;
    overlayText.size = 20;
    updateOvelay();
    var overlay:Entity = new Entity(8, 8, overlayText);
    add(overlay);
    titleScreen = new TitleScreen(0, 0);
    titleScreen.visible = false;
    add(titleScreen);
 }

 private function reload()
 {
     numberEnemies = 0;
     numberKills = 0;
     var map:Entity = createMap();
     removeAll();
     add(map);

     addOverlay();
     updateOvelay();

     deactivateLevel();
     titleScreen.updateText(status);
 }

 private function updateOvelay()
 {
    overlayText.richText = "Enemies: " + numberEnemies + " Kills: " + numberKills + " Best: " + bestKills + " Level: " + name;
 }

 public override function remove<E:Entity>(entity:E):E
 {
     if(entity.type == "enemy") {
        numberEnemies--;
        numberKills++;

        if(bestKills < numberKills) {
            bestKills = numberKills;
        }

        updateOvelay();
        if(numberEnemies == 0)
        {
            level++;
            bestKills = 0;
            status = "won";
            reload();
        }
     } else if(entity.type == "player") {
        status = "lose";
        reload();
     }
     return super.remove(entity);
 }

 private function activateLevel()
 {
    for(entity in entityList) {
        entity.active = true;
    }
    titleScreen.visible = false;
    titleScreen.active = false;
    levelActive = true;
    remove(titleScreen);
 }

 private function deactivateLevel()
 {
    for(entity in entityList) {
        entity.active = false;
    }
    titleScreen.visible = true;
    levelActive = false;
    titleScreen.active = true;
    add(titleScreen);
 }

 public override function update()
 {
     if(!levelActive && Input.mousePressed)
     {
         activateLevel();
     }
     super.update();
 }

 public override function begin()
 {
    var map:Entity = createMap();
    add(map);
    addOverlay();
    titleScreen.visible = true;
 }

 private var name:String = "";
 private var status:String = "";
 private var titleScreen:TitleScreen;
 private var overlayText:Text;
 private var numberEnemies:Int = 0;
 private var numberKills:Int = 0;
 private var bestKills:Int = 0;
 private var level:Int = 0;
 private var levelActive:Bool = false;
 private var entityList:Array<Dynamic> = [];
}
