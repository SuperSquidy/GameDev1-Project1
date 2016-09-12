package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		FlxG.resizeWindow(1280, 960);
		addChild(new FlxGame(1280,960, MenuState, 1));
		
	}
}
