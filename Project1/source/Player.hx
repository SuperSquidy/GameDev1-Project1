/*
This file contains information pertaining to the player character including :
 - Controls : WASD, Arrow Keys

This file WILL contain :
 - Instrument Controls
 - Character images & animations
 - Character walking sound effects
*/


package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxSprite
{

/* HELPER VARIABLES */
	//Movement Conditionals
	var speed:Float = 200;
	var _rot: Float = 0;
	var _drag: Float = 1300;	//Mild slide when stopping

	//Key Based
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;

	/* Currently defines our player as 
	a 16x16 Green Square */
	public function new(?X:Float=0, ?Y:Float=0)
	{	
		super(X, Y);
		makeGraphic(16,16, FlxColor.GREEN);
		drag.x = drag.y = _drag; 
	}


	override public function update(elapsed:Float):Void
	{
		movement();
		super.update(elapsed);
	}

	/* Current Movement Code, Courtesy of Dr. Marc */
	function movement():Void
	{

		//Defining Character Keys
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);	

		// Disallow Opposite Actions to occur
		if (_up && _down){
			_up = _down = false;
		}
		if (_left && _right){
			_left = _right = false;
		}
		
		//Movement Code	 
		if (_up || _down || _left || _right){
			if (_left)
			{
				_rot = 180;
				if (_up) _rot += 45;
				else if (_down) _rot -= 45;
			}
			else if (_right)
			{
				_rot = 0;
				if (_up) _rot -= 45;
				else if (_down) _rot += 45;
			}
			else if (_down) _rot = 90;
			else if (_up) _rot = 270;
			 
		 	velocity.set(speed,0);
			velocity.rotate(new FlxPoint(0,0), _rot);
		 }
	
	}
}
