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
	
var _particles:FlxEmitter;

	public function new(?X:Float=0, ?Y:Float=0){
		super(X, Y);
		loadGraphic('assets/images/Checkpoint_off.png', false, 32, 96); //Checkpoint turned off art
	}

	public function inactiveShrine(){
	}
	public function onDeactivate(){
		if (_particles != null){
			_particles.kill();
			_particles = null;
		}
	}
	public function onActivate(){
		
		_particles = new FireParticles(x+this.width/2, y+this.height/4);
		//WorldState.instance.level.imagesLayer.add(_particles); //Behind checkpoint
		WorldState.instance.checkpoints.add(_particles);	//In front of checkpoint
		_particles.start(false, .02);
	}
}