package;
import Shrine;
import flixel.math.FlxPoint;

/**
 * ...
 * @author wrighp
 */
class ScarecrowShrine extends Shrine
{
	override private function create():Void{
		super.create();
		//Don't worry about offsets for now
		var tileSizeX = 32;
		var tileSizeY = 64;
		loadGraphic('assets/images/Shrines/Scarecrow_Shrine_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("idle", [0], 0, false);
		animation.play("idle", false);
		animation.add("interacted", [0, 1, 2, 3,4,5], 1, false);
		animation.finishCallback = finishInteraction;
		animation.add("looping", [4,3,4,5], 3, true);
	}
	private function finishInteraction(name:String):Void
	{
		if (name == "interacted"){
			animation.play("looping",true);	
		}	
	}
}