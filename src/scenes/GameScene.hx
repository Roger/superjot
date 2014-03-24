package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import entities.Player;
import entities.Enemy;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

import com.haxepunk.graphics.Text;

class GameScene extends Scene
{

 public function new()
 {
    super();
 }

 public function createMap()
 {
   // load map
   var map = TmxMap.loadFromFile("maps/level02.tmx");

   // create entity map
   var e_map = new TmxEntity(map);

   e_map.loadGraphic("graphics/tileset.png", ["layer"]);

   // loads a grid layer named collision and sets the entity type to walls
   e_map.loadMask("collision", "solid");

   for(object in map.getObjectGroup("objects").objects)
   {
     switch(object.type)
     {
        case "platform":
            trace("Platform!");
        case "player":
            add(new Player(object.x, object.y));
        case "enemy":
            add(new Enemy(object.x, object.y));
            numberEnemies++;
        default:
            trace("unknown type: " + object.type);
     }
   }

   add(e_map);
 }

 private function addOverlay()
 {
    //overlayText = new Text(" = " + numberEnemies, 0, 0, 0, 0, { color:0x000000, size:30 } );
    overlayText = new Text();
    overlayText.resizable = true;
    overlayText.color = 0x000000;
    overlayText.size = 20;
    overlayText.richText = "E: " + numberEnemies + " K: " + numberKills;
    var overlay:Entity = new Entity(8, 8, overlayText);
    add(overlay);
 }

 public override function remove<E:Entity>(entity:E):E
 {
     if(entity.type == "enemy") {
        numberEnemies--;
        numberKills++;
        overlayText.richText = "E: " + numberEnemies + " K: " + numberKills;
     }
     return super.remove(entity);
 }

 public override function begin()
 {
    createMap();
    addOverlay();
 }
 private var overlayText:Text;
 private var numberEnemies:Int = 0;
 private var numberKills:Int = 0;
}
