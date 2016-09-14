package;
import Shrine;
import flixel.math.FlxPoint;

/**
 * ...
 * @author wrighp
 */
class WindShrine extends Shrine
{
	override private function create():Void{
		super.create();
		//Don't worry about offsets for now
		var tileSizeX = 96;
		var tileSizeY = 96;
		loadGraphic('assets/images/Shrines/Wind_Shrine_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("idle", [0], 0, false);
		animation.play("idle", false);
		animation.add("interacted", [0, 1, 2, 3,4], 2, false);
		animation.finishCallback = finishInteraction;
		animation.add("looping", [1, 2, 3, 4], 3, true);
		
	}
	private function finishInteraction(name:String):Void
	{
		if (name == "interacted"){
			animation.play("looping",true);	
		}	
	}
}