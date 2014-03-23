package scenes;

import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import entities.Player;
import entities.Enemy;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

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
        default:
            trace("unknown type: " + object.type);
     }
   }

   add(e_map);
 }


 public override function begin()
 {
     createMap();
 }
}
