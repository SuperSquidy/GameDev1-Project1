package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG.sound;


class CheckPoint extends FlxSprite
{
	var currentState:String;
	
	/*	Constructor for CheckPoint Class
		@parameter : X, Y : starting positions for CheckPoint object
		@function  : This function takes a starting location & places a deactivated
			checkpoint sprite at that point 
	*/
	public function new(?X:Float=0, ?Y:Float=0){
		super(X, Y);
		
		

		//Dim pseudo-animation
		loadGraphic('assets/images/Checkpoint_on_anim.png', true, 32, 96); //Checkpoint turned off art
		animation.add("dim", [1], 1, true);

		//Disabled graphic
		loadGraphic('assets/images/Checkpoint_off.png', false, 32, 96); //Checkpoint turned off art

		currentState = "Undiscovered";
	}

	override public function update(elapsed:Float):Void{
		if (getState() == "Active")
			activateCheckPoint();
		else
			animation.stop();
		super.update(elapsed);
	}

/* HELPER FUNCTIONS */
	public function getState():String{
		return currentState;
	}

/* ACTIVATION BASED FUNCTIONS */
	//	Sets the current checkpoint to active
	public function activateCheckPoint():Void{
		currentState = "Active";
		//Flickering animation
		loadGraphic('assets/images/Checkpoint_on_anim.png', true, 32, 96); //Checkpoint turned off art
		animation.add("flicker", [0, 1, 2, 1], 4, true);
		animation.play("flicker");
	}

	// Sets the current checkpoint to disabled
	public function disableCheckPoint():Void{
		currentState = "Disabled";
		animation.play("dim");
	}

}