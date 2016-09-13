package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxCamera;

class WorldState extends FlxState
{
	
	public var level:TiledLevel;
	public var player:Player;
	public var floors:FlxGroup;
	public var checkpoints:FlxGroup;
	
	
	private var _levelName:String;
	private var _activeCheckPoint:CheckPoint;
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
		level = new TiledLevel("assets/tiled/" + _levelName, this);
		_checkpointPosition = player.getPosition();
		
		//Added in order of depth, back to front
		add(level.backgroundLayer); //add backgrounds
		add(level.imagesLayer); 	//add static images
		add(checkpoints);
		add(level.objectsLayer);	//add objects (including player)
		add(level.foregroundTiles); //add forground
		
		
		FlxG.camera.follow(player,FlxCameraFollowStyle.LOCKON,CAMERA_LERP);
		FlxG.camera.snapToTarget();
		
		
		
		var backButton  = new FlxButton(20,20, "Back", function(){FlxG.switchState(new MenuState());});
		add(backButton); //Back to menu button
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		level.collideWithLevel(player);
		
		
		FlxG.overlap(player, checkpoints, onCheckpointCollision);
		if (FlxG.overlap(player,floors)){
			//Death by pitfall
			onDeath();
		}else if(player.health <=0){
			//Death by loss of health
			onDeath();
		}
		
	}
	private function onCheckpointCollision(Player:FlxObject, checkpoint:CheckPoint):Void{
		//If this checkpoint wasn't already activated (there may be particle effects or a light or something)
		if (_activeCheckPoint == null ||_activeCheckPoint != checkpoint){
			if (_activeCheckPoint != null){
				_activeCheckPoint.onDeactivate();
			}
			//Activate this checkpoint
			_activeCheckPoint = checkpoint;
			_checkpointPosition = checkpoint.getPosition();
			checkpoint.onActivate();
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