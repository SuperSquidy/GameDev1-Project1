package;
import flixel.FlxObject;
import flixel.addons.editors.tiled.TiledObject;
import flixel.FlxG;
/**
 * ...
 * @author wrighp
 */
class Trigger extends FlxObject
{
	public var type:String; //"Shrine1", "event", etc.
	public var activated:Bool = false;
	public var tiledObject:TiledObject;
	
	/**
	 * Trigger that has string property "triggerType" with more information on the particular trigger
	 * @param	x	x position.
	 * @param	y	y position.
	 * @param	oX	scale X.
	 * @param	oY	scale Y.
	 * @param	tiledObject
	 */
	public function new(x, y, oX, oY,tiledObject:TiledObject){
		super(x, y, oX, oY);
		type = tiledObject.properties.get("triggerType");
		this.tiledObject = tiledObject;
	}
	
	static public function onTriggerCollision(player:FlxObject, trigger:Trigger):Void{
		switch (trigger.type)
		{
			case "airToMainArea":
				moveArea("overworld.tmx","airShrine");
			case "earthToOverworld":
				moveArea("overworld.tmx","earthShrine");
			case "waterToMain":
				moveArea("overworld.tmx","waterShrine");
				
			//Overworld exits
			case "overworldToEarth":
				moveArea("earth_shrine.tmx");
			case "overworldToWater":
				moveArea("water_shrine.tmx", "overworld");
			case "overworldtoStar":
				moveArea("star_shrine.tmx");
			case "overworldToAir":
				moveArea("air_shrine.tmx");
		}
		trigger.activated = true;
	}
	static private function moveArea(fileName:String,?enterFrom:String = null):Void{
		//WorldState.instance.player.setPlayerFrozen(true);
		FlxG.camera.fade(.25, false, function(){FlxG.switchState(new WorldState(fileName,enterFrom)); });
	}
}