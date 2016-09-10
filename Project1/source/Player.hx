package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0)
	{	
		super(X, Y);
		loadGraphic("assets/images/tmpPlayer.png", true, 200, 200)
		
		drag.x = drag.y = 1300; //Mild slide when stopping
	}

	override public function update(elapsed:Float):void
	{
		movement	
	}
}
