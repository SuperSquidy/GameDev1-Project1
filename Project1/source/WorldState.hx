package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class WorldState extends FlxState
{
	public var level:TiledLevel;
	public var player:Player;
	
	private var _levelName:String;
	
	//Can pass a player in constructor if a player already exists (for loading multiple levels)
	public function new(?player:Player, ?levelName:String = "test_map.tmx") 
	{
		super();
		this.player = player;
		_levelName = levelName;
	}
	override public function create():Void 
	{
		super.create();
		
		level = new TiledLevel("assets/tiled/" + _levelName, this);
		
		//Added in order of depth, back to front
		add(level.backgroundLayer); //add backgrounds
		add(level.imagesLayer); 	//add static images
		add(level.objectsLayer);	//add objects (including player)
		add(level.foregroundTiles); //add forground
		
		
		
		var backButton  = new FlxButton(20,20, "Back", function(){FlxG.switchState(new MenuState());});
		add(backButton); //Back to menu button
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		level.collideWithLevel(player);
		
		
	}
}