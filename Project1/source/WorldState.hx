package;

import WaterShrine;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;

class WorldState extends FlxState
{

	static public var instance:WorldState;
	public var level:TiledLevel;
	public var player:Player;
	public var floors:FlxGroup;
	public var checkpoints:FlxGroup;
	public var triggers:FlxGroup;
	public var shrines:FlxGroup;
	public var trees:FlxGroup;
	
	private var _levelName:String;
	private var _enterFrom:String;	//Used to check what level a player entered from, null if they just spawned in.
	private var _enterPosition:FlxPoint; //Null if player is spawning in, position of enter point otherwise
	private var _activeCheckPoint:CheckPoint;
	private var _checkpointPosition:FlxPoint;
	
	
	private static inline var CAMERA_LERP = .1;

	//Can pass a player in constructor if a player already exists (for loading multiple levels)
	public function new(?levelName:String = "test_map.tmx",?enterFrom:String = null) 
	{
		super();
		this._enterFrom = enterFrom;
		_levelName = levelName;
		trace("Loading level: " + levelName+" and entering from: " + _enterFrom);
	}
	/**
	 * Checks to see if this is where a player should spawn from, if so, sets the player spawn to position.
	 * @param	check The parameter to check from a playerEnter object
	 */
	public function checkEnterFrom(check:String, position:FlxPoint):Void{
		if (_enterFrom != null && check == _enterFrom){
			_enterPosition = position;
		}
	}
	override public function create():Void 
	{
		super.create();
		//Camera fade in
		FlxG.camera.fade(.25, true);
		
		instance = this;
		floors = new FlxGroup();
		checkpoints = new FlxGroup();
		triggers = new FlxGroup();
		shrines = new FlxGroup();
		trees = new FlxGroup();
		
		level = new TiledLevel("assets/tiled/" + _levelName, this);
		if (_enterPosition != null){
			player.setPosition(_enterPosition.x, _enterPosition.y-32);
		}
		_checkpointPosition = player.getPosition();
		
		//Added in order of depth, back to front
		
		add(level.imagesLayer); 	//add static images
		add(level.backgroundLayer); //add backgrounds
		add(checkpoints);
		add(shrines);
		add(triggers);
		add(trees);
		add(level.objectsLayer);	//add objects (including player)
		add(level.foregroundTiles); //add forground
		
		
		FlxG.camera.follow(player,FlxCameraFollowStyle.LOCKON,CAMERA_LERP);
		FlxG.camera.snapToTarget();
		
		//Pause screen
		this.destroySubStates = true;
		this.persistentDraw = true;

	//	if (FlxG.sound.music == null){
	//		FlxG.sound.playMusic("ScarfDance");
	//		FlxG.sound.music.persist = true; //Music will now persist between states
	//	}
		
		var backButton  = new FlxButton(20,20, "Back", function(){FlxG.switchState(new MenuState());});
		add(backButton); //Back to menu button
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//Debug key
		if (FlxG.keys.justPressed.B) FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
		
		level.collideWithLevel(player);
		FlxG.collide(player, trees);
		FlxG.overlap(player, triggers,Trigger.onTriggerCollision);
		FlxG.overlap(player, checkpoints, onCheckpointCollision);
		FlxG.overlap(player, shrines, onWatershrineCollision);
		if (FlxG.overlap(player,floors)){
			//Death by pitfall
			onDeath();
		}else if(player.health <=0){
			//Death by loss of health
			onDeath();
		}
		if (FlxG.keys.justPressed.TAB){
			var pauseState = new PauseState(FlxColor.TRANSPARENT);
			pauseState.opened();
			openSubState(pauseState);
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
			_checkpointPosition = checkpoint.getSpawnPosition();
			checkpoint.onActivate();
		}
	}

	private function onWatershrineCollision(Player:FlxObject, shrine:WaterShrine):Void{
		shrine.onActivate();
	}

	private function onEarthshrineCollision(Player:FlxObject, shrine:ScarecrowShrine):Void{
		shrine.onActivate();
	}

	public function onDeath():Void
	{
		//Particle "splash" on death
		var particles = new FireParticles();
		particles.focusOn(player); particles.y += 32;
		particles.acceleration.set(0, 100, 0, 200, 0, 200, 0, 200);
		particles.velocity.set( -80, -80, 80, 80);
		particles.lifespan.set(.25, .5);
		particles.color.set(0x444444, 0x444444, 0x000000, 0x000000);
		add(particles);
		particles.start(true, 0, 50);
		
		//Reset Player Health
		player.health = 1;
		player.setPosition(_checkpointPosition.x, _checkpointPosition.y);
		//Kill player movement (and probably abilities too)
		player.velocity.set(0, 0);
		
		//Effects (shake, flicker, sound, etc)
		FlxG.camera.shake(.01, .2);
		FlxFlicker.flicker(player, .5, .06);
		FlxG.sound.play("hurt");
	}
}