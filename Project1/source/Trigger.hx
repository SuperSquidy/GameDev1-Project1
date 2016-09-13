package;
import flixel.FlxObject;
import flixel.addons.editors.tiled.TiledObject;
/**
 * ...
 * @author wrighp
 */
class Trigger extends FlxObject
{
	public var type:String; //"Shrine1", "event", etc.
	public var activated:Bool = false;
	public var tiledObject:TiledObject;
	
	public function new(x, y, oX, oY,tiledObject:TiledObject){
		super(x, y, oX, oY);
		type = tiledObject.properties.get("triggerType");
		this.tiledObject = tiledObject;
	}
	
	static public function onTriggerCollision(player:FlxObject, trigger:Trigger):Void{
		switch (trigger.type.toLowerCase())
		{
			case "something":
				//do something: trigger.tiledObject.properties.get("someExtraProperty")
			case "somethingelse":
				//stuff
		}
		trigger.activated = true;
	}
}