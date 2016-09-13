package;

import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG.sound;


class CheckPoint extends FlxSprite
{
	var currentState:String;
	static inline var HITBOX_HEIGHT = 300;
	
	var _particles:FlxEmitter;

	/*	Constructor for CheckPoint Class
		@parameter : X, Y : starting positions for CheckPoint object
		@function  : This function takes a starting location & places a deactivated
			checkpoint sprite at that point 
	*/

	public function new(?X:Float=0, ?Y:Float=0){
		super(X, Y);
		
		//The below two lines don't do anything, as loading a new graphic removes previous animatons apparently
		//Dim pseudo-animation
		loadGraphic('assets/images/Checkpoint_on_anim.png', true, 32, 96); //Checkpoint turned off art
		animation.add("dim", [1], 1, true);

		//Disabled graphic
		loadGraphic('assets/images/Checkpoint_off.png', false, 32, 96); //Checkpoint turned off art

		currentState = "Undiscovered";
		
		y -= HITBOX_HEIGHT-height; //shifts height for higher hitbox
		resizeHitbox();
	}

	//This function currently isn't needed
	override public function update(elapsed:Float):Void{
		super.update(elapsed);
		
		//Properly fades out fire instead of removing it instantly
		if (_particles != null && currentState == "Disabled"){
			_particles.emitting = false;
			if (_particles.countLiving() == 0){	
			_particles.kill();
			_particles = null;
			}
		}
	}
	//Call whenever loadGraphic is used to resize the hitbox
	private function resizeHitbox():Void{
		offset.set(0, -HITBOX_HEIGHT+height);
		height = HITBOX_HEIGHT;
	}
	
/* HELPER FUNCTIONS */
	public function getState():String{
		return currentState;
	}

/* ACTIVATION BASED FUNCTIONS */
	//	Sets the current checkpoint to active
	public function onActivate():Void{
		currentState = "Active";
		//Flickering animation
		loadGraphic('assets/images/Checkpoint_on_anim.png', true, 32, 96); //Checkpoint turned off art
		animation.add("flicker", [0, 1, 2, 1], 4, true);
		animation.play("flicker",true);
		resizeHitbox();
		
		_particles = new FireParticles(x+this.frameWidth/2, y-this.frameHeight*3/4+HITBOX_HEIGHT);
		//WorldState.instance.level.imagesLayer.add(_particles); //Behind checkpoint
		WorldState.instance.checkpoints.add(_particles);	//In front of checkpoint
		_particles.start(false, .02);
	}

	// Sets the current checkpoint to disabled
	public function onDeactivate():Void{
		currentState = "Disabled";
		loadGraphic('assets/images/Checkpoint_on_anim.png', true, 32, 96); //Checkpoint turned off art
		animation.add("dim", [1], 1, true);
		animation.play("dim");
		resizeHitbox();
	}

}