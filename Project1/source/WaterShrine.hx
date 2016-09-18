package;
import Shrine;
import flixel.math.FlxPoint;

/*
This file contains information pertaining to the Water Shrine including :
 - Recognizing when the player has interacted with the object
 - Triggering logic & 'cutscenes' & correct story options
 - Unlocking the Player's double jump

 Current Implementation:
 - If the player is in range of the shrine for the first time
 	- The first set of text scrolls, teaching them the song
 - When the player plays the song in range of the shrine for the first time
 	- Second set of text scrolls, player unlocks double jump functionality
 - If the player plays the song in range an additional time(s)
 	- The interaction animation plays, but nothing else
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
	//	if (getCollisionPlayer())
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
		if(!songLearned)
			learnSong();

		if (Reg._player.getMandolinObj().getWaterPlayed()){
			super.onActivate();
			if(!storyLearned){
				//Text prompt 2 scrolls, shares story
				storyLearned = true;
			}
			finishInteraction("interacted");
		}
	}

	/*	@function : Enables the water song
			if they have not already unlocked it
			& plays the first set of text
	*/
	private function learnSong(){
		Reg._player.getMandolinObj().enableWaterSong();
		ticker = new TickingText("Watershrine_interact.txt");
		FlxG.sound.play("Water_Song");	}
		songLearned = true;
	}

}