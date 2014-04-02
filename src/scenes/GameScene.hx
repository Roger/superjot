package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.math.Vector;

import entities.CustomEntity;
import entities.Player;
import entities.Bullet;
import entities.Enemy;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

import com.haxepunk.graphics.Text;

import utils.Recording;
import utils.Action;

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

 public function createMap(empty:Bool=false)
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
        case "player":
            if(empty) continue;

            var player:Player = new Player(object.x, object.y);
            player.active = false;
            entityList.push(player);
            add(player);
        case "enemy":
            if(empty) continue;

            var enemy:Enemy = new Enemy(object.x, object.y);
            enemy.active = false;
            add(enemy);
            entityList.push(enemy);
            numberEnemies++;
        case "text":
            var text:Text = new Text();
            text.resizable = true;
            text.color = 0xcacaca;
            text.size = 20;
            text.richText = object.name;
            add(new Entity(object.x, object.y, text));
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

 private function replay()
 {
     isReplay = true;
     for(e in entityList) {
         this.remove(e);
     }
     seconds = 0;
     Recording.update();
     replayEntities = new Map<String,Dynamic>();
     elapsed = 0;
     HXP.rate = 1;
     var map:Entity = createMap(true);
     removeAll();
     add(map);
     addOverlay();
     updateOvelay();
 }

 private function updateOvelay()
 {
    var sec:String = Std.string(seconds);
    sec = sec.substr(0, sec.indexOf(".") + 3);
    overlayText.richText = 'Enemies: $numberEnemies Kills: $numberKills Best: $bestKills Level: $name s: $sec';
 }

 public override function remove<E:Entity>(entity:E):E
 {
    if(entity.type == "player" || entity.type == "enemy" || entity.type == "bullet" || entity.type == "explosion") {
        Recording.add("remove", entity);
    }

    if(entityList.indexOf(entity) == -1) return super.remove(entity);

    if(isReplay) {
        return super.remove(entity);
    }


    if(entity.type == "enemy") {
       numberEnemies--;
       numberKills++;

       if(bestKills < numberKills) {
           bestKills = numberKills;
       }

       updateOvelay();
       if(numberEnemies == 0)
       {
           bestKills = 0;
           status = "won";
           replay();
       }
    } else if(entity.type == "player") {
       status = "lose";
       replay();
    }
    entityList.remove(entity);
    return super.remove(entity);
 }

 public override function add<E:Entity>(entity:E):E
 {
    if(entity.type == "player" || entity.type == "enemy" || entity.type == "bullet" || entity.type == "explosion") {
        if(!this.isReplay) {
            entityList.push(entity);
            Recording.add("add", entity);
        }
    }
    return super.add(entity);
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
    //Recording.print();
 }

 private function updateNormal()
 {
     HXP.rate = Recording.slowRate;
     if (Input.check("up") || Input.check("down") || Input.pressed("shoot") || Input.mousePressed)
     {
         HXP.rate = 1;
     }
     if(!levelActive && Input.mousePressed)
     {
         activateLevel();
     }

     elapsed +=  HXP.elapsed;
     //trace("NORMAL"+elapsed);
     if(elapsed >= Recording.slowRate/HXP.rate) {
         Recording.update();
         elapsed -= Recording.slowRate/HXP.rate;
     }
 }

 private function updateReplay()
 {
     elapsed += HXP.elapsed; // / HXP.rate;
     //trace("REPLAY:"+ elapsed);
     if(elapsed >= Recording.slowRate/HXP.rate) {
         elapsed -= Recording.slowRate/HXP.rate;

         var frame:utils.Frame = Recording.frames.shift();
         if(frame == null) {
             isReplay = false;
             if(status == "won") level++;
             reload();
             return;
         }

         //trace("------ FRAME --------");
         for(action in frame.actions) {
             //trace(action.action + ": " + action.type + " = " + action.name);
             switch(action.action)
             {
                 case "add":
                     switch(action.type)
                     {
                         case "player":
                             var entity:Player = new Player(action.position.x, action.position.y, action.name);
                             entity.active = false;
                             replayEntities.set(action.name, entity);
                             add(entity);
                         case "enemy":
                             var entity:Enemy = new Enemy(action.position.x, action.position.y, action.name);
                             entity.active = false;
                             entity.angle = action.angle;
                             add(entity);
                             replayEntities.set(action.name, entity);
                         case "bullet":
                             var entity:Bullet = new Bullet(action.position.x, action.position.y, action.angle, action.target, action.name);
                             entity.active = false;
                             add(entity);
                             replayEntities.set(action.name, entity);
                         default:
                             trace("Invalid entity type " + action.type);
                     }
                case "move":
                    var entity = replayEntities.get(action.name);
                    if(entity == null) continue;
                    entity.x = action.position.x;
                    entity.y = action.position.y;
                    entity.updateAngle(action.angle);
                    //trace(action.action + ": " + action.type + " = " + action.name);
                case "remove":
                    var entity:CustomEntity = replayEntities.get(action.name);
                    if(entity == null) continue;
                    entity.visible = false;
                    remove(entity);

             }
        }
     }
 }

 public override function update()
 {
     seconds += HXP.elapsed;
     updateOvelay();
     if(isReplay) {
         updateReplay();
     } else {
         updateNormal();
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

 private var elapsed:Float = 0;
 private var name:String = "";
 private var status:String = "";
 private var titleScreen:TitleScreen;
 private var overlayText:Text;
 private var numberEnemies:Int = 0;
 private var numberKills:Int = 0;
 private var bestKills:Int = 0;
 private var level:Int = 2;
 private var levelActive:Bool = false;
 private var entityList:Array<Dynamic> = [];

 private var isReplay:Bool = false;
 private var replayEntities:Map<String,Dynamic>;

 private var seconds:Float = 0;
}
