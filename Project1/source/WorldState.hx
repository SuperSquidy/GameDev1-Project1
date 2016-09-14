package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxCamera;
import flixel.util.FlxColor;
class WorldState extends FlxState
{
	public static var menu:PauseState;
		
	public var level:TiledLevel;
	public var player:Player;
	public var floors:FlxGroup;
	public var checkpoints:FlxGroup;
	public var triggers:FlxGroup;
	
	private var _levelName:String;
	private var _checkpointPosition:FlxPoint;
	private static inline var CAMERA_LERP = .1;

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
		
		floors = new FlxGroup();
		checkpoints = new FlxGroup();
		triggers = new FlxGroup();
		
		level = new TiledLevel("assets/tiled/" + _levelName, this);
		_checkpointPosition = player.getPosition();
		
		//Added in order of depth, back to front
		add(level.backgroundLayer); //add backgrounds
		add(level.imagesLayer); 	//add static images
		add(checkpoints);
		add(triggers);
		add(level.objectsLayer);	//add objects (including player)
		add(level.foregroundTiles); //add forground
		
		
		FlxG.camera.follow(player,FlxCameraFollowStyle.LOCKON,CAMERA_LERP);
		FlxG.camera.snapToTarget();
		
		//Pause screen
		this.destroySubStates = false;
		this.persistentDraw = true;
		if (menu == null){
			menu = new PauseState(FlxColor.TRANSPARENT);
		}
		
		
		var backButton  = new FlxButton(20,20, "Back", function(){FlxG.switchState(new MenuState());});
		add(backButton); //Back to menu button
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		level.collideWithLevel(player);
		
		
		FlxG.overlap(player, triggers,Trigger.onTriggerCollision);
		FlxG.overlap(player, checkpoints, onCheckpointCollision);
		if (FlxG.overlap(player,floors)){
			//Death by pitfall
			onDeath();
		}else if(player.health <=0){
			//Death by loss of health
			onDeath();
		}
		if (FlxG.keys.justPressed.TAB){
			menu.opened();
			openSubState(menu);
		}
	}
	private function onCheckpointCollision(Player:FlxObject, Checkpoint:FlxObject):Void{
		//If this checkpoint wasn't already activated (there may be particle effects or a light or something)
		if (!Checkpoint.getPosition().equals(_checkpointPosition)){
			//Activate this checkpoint
			_checkpointPosition = Checkpoint.getPosition();
		}
	}
	public function onDeath():Void
	{
		//Reset Player Health
		player.health = 1;
		player.setPosition(_checkpointPosition.x, _checkpointPosition.y);
		FlxG.camera.shake(.01, .2);
	}
}