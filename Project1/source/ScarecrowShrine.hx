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
This file contains information pertaining to the ScareCrow (Earth) Shrine including :
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
class ScarecrowShrine extends Shrine
{
	private static var songLearned:Bool = false;
	private static var storyLearned:Bool = false;
	
	var ticker:TickingText;
	var ticker2:TickingText;
	var ticker3:TickingText;

	override private function create():Void{
		super.create();
		//Don't worry about offsets for now
		var tileSizeX = 32;
		var tileSizeY = 64;

		//Sprite Sheets & Animations
		loadGraphic('assets/images/Shrines/Scarecrow_Shrine_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("idle", [0], 0, false);
		animation.play("idle", false);
		animation.add("interacted", [0, 1, 2, 3,4,5], 1, false);
		animation.finishCallback = finishInteraction;
		animation.add("looping", [4,3,4,5], 3, true);

		//Initializing Story Text Files
		ticker = new TickingText(false, "Earthshrine_interact_0.txt", .04, 12, "Earth_Text", 700, 400);
		ticker2 = new TickingText(false, "Earthshrine_interact_0.txt", .04, 12, "Earth_Text", 700, 400);
		ticker3 = new TickingText(false, "Earthshrine_interact_0.txt", .04, 12, "Earth_Text", 700, 400);
	}

	public function onActivate():Void{
		if(!songLearned)
			learnSong();

		else if (Reg.mando.getEarthPlayed()){		//If Earth song was played
			if(!storyLearned)
				learnStory();
			else if (!ticker2.alive){ //Prevents more overlapping
				ticker3.resetText();
				WorldState.instance.add(ticker3);
				ticker3.doSkip = true;
			}
			finishInteraction("interacted");
			Reg.mando.earthPlayed(false);
		}
	}

	private function finishInteraction(name:String):Void
	{
		if (name == "interacted"){
			animation.play("looping",true);	
		}	
	}

	/*	@function : Triggers scrolling text to learn song
	*/
	private function learnSong(){
		trace("Learning Song");
		songLearned = true;
		WorldState.instance.add(ticker);
	}

	/*	@function : Triggers the story text
			and Earth Song to play
	*/
	private function learnStory(){
		trace("Learning Story");
		FlxG.sound.play("Earth_Song");
		Reg.mando.enableWaterSong();
		animation.play("interacted");
		storyLearned = true;
		WorldState.instance.add(ticker2);
		ticker.kill(); //Prevents text overlapping
	}

}