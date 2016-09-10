package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxSprite
{


	//Helper Variables
	var speed:Float = 200;
	var _rot: Float = 0;
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0)
	{	
		super(X, Y);
		makeGraphic(16,16, FlxColor.GREEN);
		drag.x = drag.y = 1300; //Mild slide when stopping
	}

	override public function update(elapsed:Float):Void
	{
		movement();
		super.update(elapsed);
	}

	function movement():Void
	{

		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);	

		// cancel out opposing directions
		 if (_up && _down){
		 	_up = _down = false;
		 }
		 if (_left && _right){
		 	_left = _right = false;
		 }
		 
		 if (_up || _down || _left || _right){
			 if (_left)
			 {
				 _rot = 180;
				 facing = FlxObject.LEFT;
				 if (_up) _rot += 45;
				 else if (_down) _rot -= 45;
			 }
			 else if (_right)
			 {
				 _rot = 0;
				 facing = FlxObject.RIGHT;
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
