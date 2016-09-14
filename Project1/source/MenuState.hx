package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import sys.FileSystem;

class MenuState extends FlxState
{
	var _playButton:FlxButton;
	var ticker:TickingText;
	override public function create():Void
	{
		super.create();
		
		// add(new FlxText(10,10,20, "Hello, world!"));
		_playButton  = new FlxButton(0,0, "Play", clickPlay);
		_playButton.screenCenter();
		add(_playButton);
		
		var i = 0;
		for (s in FileSystem.readDirectory("assets/tiled")){
			var demoWorldButton:FlxButton = new FlxButton(0, 0, "     Demo: " + s,function(){FlxG.switchState(new WorldState(s)); });
			demoWorldButton.screenCenter();
			demoWorldButton.scale.set(3, 1);
			demoWorldButton.label.wordWrap = false;
			demoWorldButton.label.autoSize = true;
			demoWorldButton.updateHitbox();
			demoWorldButton.y += 30*i;
			demoWorldButton.x += 100;
			add(demoWorldButton); //Switch to WorldState
			i++;
		}
		
		
		var demoText  = new FlxButton(0, 0, "Demo Text", function(){if (ticker == null){ ticker = new TickingText("test.txt"); add(ticker); }else{ticker.skipText(); }});
		demoText.screenCenter();
		demoText.y += 30;
		add(demoText); //Add or skip ahead ticking text
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
