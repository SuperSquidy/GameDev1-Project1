package;
import Shrine;
import flixel.math.FlxPoint;

/**
 * ...
 * @author wrighp & bormaj
 */
class WaterShrine extends Shrine
{
	private static var songLearned:Bool = false;
	private static var storyLearned:Bool = false;
	var ticker:TickingText;

	override private function create():Void{
		super.create();
		//Don't worry about offsets for now
		var tileSizeX = 64;
		var tileSizeY = 64;
		loadGraphic('assets/images/Shrines/Water_Shrine_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("idle", [0], 0, false);
		animation.play("idle", false);
		animation.add("interacted", [1, 2, 3, 4], 2, false);
		animation.finishCallback = finishInteraction;
		animation.add("looping", [2,3,4], 3, true);
	}
	
	override public function update(elapsed:Float):Void{
	
	//	if (getCollisionPlayer() && !songPlayed)
	//		onActivate();
	
		super.update(elapsed);
	}

	private function finishInteraction(name:String):Void
	{
		if (name == "interacted"){
			animation.play("looping",true);	
		}	
	}

	override public function onActivate():Void{
		super.onActivate();
			
		if(!songLearned)
			learnSong();

		if (Reg._player.getMandolinOb().get)
		else if(!storyLearned){
			//Text prompt 2 scrolls, shares story
			storyLearned = true;
		}
	}

	/*	@function : Enables the water song
			if they have not already unlocked it
			& plays the first set of text
	*/
	private function learnSong(){
		Reg._player.getMandolinObj().enableWaterSong();
		ticker = new TickingText("Watershrine_interact.txt");
		songLearned = true;
	}

}