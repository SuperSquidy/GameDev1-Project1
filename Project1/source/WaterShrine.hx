package;

import Shrine;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG.sound;


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
	var playerTrigger:Trigger;

	override private function create():Void{
		super.create();
		
		//Don't worry about offsets for now
		var tileSizeX = 64;
		var tileSizeY = 64;
		
		//Sprite Sheet & Animations
		loadGraphic('assets/images/Shrines/Water_Shrine_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("idle", [0], 0, false);
		animation.play("idle", false);
		animation.add("interacted", [1, 2, 3, 4], 2, false);
		animation.finishCallback = finishInteraction;
		animation.add("looping", [2,3,4], 3, true);
	}
	
	override public function update(elapsed:Float):Void{
		super.update(elapsed);
	}
	
	public function onActivate():Void{		
		if(!songLearned)
			learnSong();

		else if (Reg.mando.getWaterPlayed()){		//If water song played
			if(!storyLearned)
				learnStory();
			finishInteraction("interacted");
			Reg.mando.waterPlayed(false);
		}
	}

	private function finishInteraction(name:String):Void{
		if (name == "interacted")
			animation.play("looping",true);	
	}

	/*	@function : Triggers scrolling text to learn song
	*/
	private function learnSong(){
		trace("Learning Song");
		ticker = new TickingText("Watershrine_interact_1.txt");
		songLearned = true;
	}

	/*	@function : Triggers the story text
			and Water Song to play
	*/
	private function learnStory(){
		trace("Learning Story");
		FlxG.sound.play("Water_Song");
		Reg.mando.enableWaterSong();
		animation.play("interacted");
		//Ticking Text
		storyLearned = true;
	}

}