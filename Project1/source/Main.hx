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
		FlxG.resizeWindow(1024, 768);
		addChild(new FlxGame(1024,768, MenuState, 1));
		
	}
}
