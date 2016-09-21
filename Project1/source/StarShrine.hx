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
This file contains information pertaining to the Star Shrine including :
 - Recognizing when the player has interacted with the object
 - Triggering logic & 'cutscenes' & correct story options
 - Unlocking the Player's double jump

 Current Implementation:
 - If the player is in range of the shrine for the first time
 	- The first set of text scrolls, teaching them the song
 - When the player plays the song in range of the shrine for the first time
 	- Second set of text scrolls, player turns invisible
 	- When text ends, game ideally fades to black
*/

class StarShrine extends Shrine
{

	public static var songLearned:Bool = false;
	private static var storyLearned:Bool = false;

	//Initializing Story-related Variables
	var ticker:TickingText;
	var ticker2:TickingText;

	var _X:Float;
	var _Y:Float;
	var _background = new FadeBackground(0,0);
	var endGameThing = new FlxSprite(0,0);


	override private function create():Void{
		super.create();
		//Don't worry about offsets for now
		var tileSizeX = 128;
		var tileSizeY = 128;

		_X = this.x;
		_Y = this.y;


		//Sprite Sheet & Animations
		loadGraphic('assets/images/Shrines/Star_Shrine_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("melting", [0, 1, 2], 3, false);
		animation.add("ending", [3, 4, 5], 1, false);

		//Initialize Text Assets
		ticker = new TickingText(false, "Shrine_of_stars_interact_1.txt", .04, 12, "Star_Text", 75, Std.int(y) - 200);
		ticker.x = this.x -250;  ticker.fieldWidth = 500;
		ticker2 = new TickingText(false, "Shrine_of_stars_text_2.txt", .04, 12, "Star_Text", 75, Std.int(y) - 200);
		ticker2.x = this.x -250;  ticker.fieldWidth = 500;
	}

	public override function onActivate():Void{
		endGame();

		if(!songLearned)
			learnSong();

		else if (Reg.mando.getStarPlayed()){		//If Earth song was played
			if(!storyLearned){
				learnStory();
				Player.invis = true;
				animation.play("ending");		//Player walks into Shrine
				if (!ticker2.alive){
					endGameThing.loadGraphic('assets/images/blackFade.png', true, 2400, 1600);
					WorldState.instance.add(endGameThing);
				//	endGame();
				}
			}
		}
	}

	/*	@function : Triggers scrolling text to learn song
	*/
	private function learnSong(){
		trace("Learning Song");
		songLearned = true;
		WorldState.instance.add(ticker);
		ticker.scrollFactor.set(1,1);
	}

	/*	@function : Triggers the story text
			and Earth Song to play
	*/
	private function learnStory(){
		trace("Learning Story");
	//	FlxG.sound.play("Star_Song");
		animation.play("melting");
		Reg.mando.enableStarSong();
		storyLearned = true;
		WorldState.instance.add(ticker2);
		ticker2.scrollFactor.set(1, 1);
		ticker.kill(); //Prevents text overlapping
	}

	/*	@function : Ends game when
			last text scrolls out
	*/
	private function endGame(){
		_background.endGame();
	}
}