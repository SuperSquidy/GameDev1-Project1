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
	

	public function new(){
		super();
	
		var checkpoint = new FlxSprite(x, y - 32);
		var color = new FlxColor();
		color.setRGB(255, 255, 255, 128);
		checkpoint.makeGraphic(32, 64, color);
		state.checkpoints.add(checkpoint);

	}			
}