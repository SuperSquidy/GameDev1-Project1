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
	}

	public function inactiveShrine(){
		//new FlxSprite(x, y - 32);
		loadGraphic('assets/images/Checkpoint_off.png', false, 32, 64); //Checkpoint turned off art
	}
}