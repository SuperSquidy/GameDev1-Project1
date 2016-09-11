package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	var _playButton:FlxButton;
	
	override public function create():Void
	{
		super.create();
		
		// add(new FlxText(10,10,20, "Hello, world!"));
		_playButton  = new FlxButton(0,0, "Play", clickPlay);
		_playButton.screenCenter();
		add(_playButton);
		
		var demoWorldButton  = new FlxButton(0,0, "Demo World", function(){FlxG.switchState(new WorldState()});
		demoWorldButton.screenCenter();
		demoWorldButton.y += 30;
		add(demoWorldButton); //Switch to WorldState
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function clickPlay():Void
	{
		// switch to play scene!
		FlxG.switchState(new PlayState());
	}
}
