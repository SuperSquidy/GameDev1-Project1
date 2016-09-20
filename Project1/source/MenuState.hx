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
	var bkg:FlxSprite;
	override public function create():Void
	{
		super.create();
		
		//add background
		bkg = new FlxSprite();
		bkg.loadGraphic("assets/images/Menu_bkg.png", false, 640, 480);
		add(bkg);
		// add(new FlxText(10,10,20, "Hello, world!"));
		_playButton  = new FlxButton(0, 0, "",function(){FlxG.switchState(new WorldState("water_shrine.tmx")); });
		_playButton.loadGraphic("assets/images/Button_SpriteSheet.png", true, 160, 64);
		_playButton.screenCenter();
		_playButton.y += 150;
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
		
		//credits button
		var credits  = new FlxButton(0, 0, "", function(){if (ticker == null){ ticker = new TickingText("Credits.txt"); add(ticker); }else{ticker.skipText(); }});
		credits.loadGraphic("assets/images/Button_SpriteSheet_credits.png", true, 144, 32);
		credits.screenCenter();
		credits.y += 210;
		add(credits);
		
		/*var demoText  = new FlxButton(0, 0, "Demo Text", function(){if (ticker == null){ ticker = new TickingText("test.txt"); add(ticker); }else{ticker.skipText(); }});
		demoText.screenCenter();
		demoText.y += 30;
		add(demoText); //Add or skip ahead ticking text
		*/
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function clickPlay():Void
	{
		// switch to play scene!
		FlxG.switchState(new PlayState());
		//FlxG.switchState(FlxG.switchState(new WorldState("assets/tiled/water_shrine.tmx")));
	}
}
