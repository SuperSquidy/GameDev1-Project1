/*
This file contains information pertaining to the player character including :
 - Player Controls : WASD & Arrow Keys for movement
 					 HJKL; for Instrument
 					 E for dash

 - Helper Vars for Motion : speed, rotation, drag
 - Initializes Mandolin
 - Triggers Mandolin to play notes
 - Jump & Double Jump Capabilities
 - Store recent jump keypresses
 - Keeps track of reset-timer for when to forget Mandolin notes

This file WILL :
 - Contain character images & animations
 - Contain character walking sound effects

Don't know how to refer to awkward keys, like ESC or EQUALS?
Reference the FlxKeyList : http://api.haxeflixel.com/flixel/input/keyboard/FlxKeyList.html

Current Jump Mechanics:
 - Jump with W or SPACE
 - Double Jump by "L; while mid-air
	- Walking off a platform, only double-jump can still be performed while falling
 - Dash triggered by song "JJJ"
 	-Dashing from platform to same level platform will make you fall, 
 		since gravity kicks in when you get off the platform

 Current Issues:
 
 Previous Issues:
 - [FIXED] Player Dash does not reset after initial dash
*/


package;

import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxSprite
{

/* HELPER VARIABLES */
	//Jump & Physics Related
	public static inline var _gravity:Int = 1500;
	public static inline var _jumpSpeed:Int = 1075;
	public static inline var _jumpsAllowed:Int = 2;

	private var _jumpTime:Float = -1;
	private var _timesJumped:Int = 0;
	private var _jumpKeys:Array<FlxKey> = [W, SPACE];

	/*Dash stuffs*/
	private static inline var _dashSpeed:Int = 1000;
	private static inline var _dashDuration:Float = 0.25;
	private static inline var _dashCooldown:Float = 3.0;
	
	private var dashSong:Bool = false;		//Needed for Mandolin to dash
	private var jumpSong:Bool = false;
	private var jumpSongGround = false;
	private var isWalking:Bool;
	private var playerFrozen:Bool = false;	//For 'cutscenes'

	private var _dashTime:Float = -1;

	//Movement Conditionals
	var _runSpeed:Float = 200;
	var _rot: Float = 0;
	var _drag: Float = 1300;	//Mild slide when stopping

	//Key Based
	var _left:Bool = false;
	var _right:Bool = false;
	var _mando:Mandolin;

/* CONSTRUCTOR & UPDATE */
	/* Currently defines our player as 
	a 32x64 Green Square & Initializes instrument*/

	public function new(?X:Float=0, ?Y:Float=0)
	{	
		super(X, Y);

		//Player Character Art
		this.set_pixelPerfectRender(true); //Removes jitter
		loadGraphic('assets/images/PC_SpriteSheet.png', true, 32, 64);	//PC sprite sheet
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		//Player Character Animations
		animation.add('idle', [13, 14], 5, true);		// Idle
		animation.add('walk', [1, 2, 3, 4], 12, true);	// Walk
		animation.add('jump', [5, 6], 5, false);		// Jump
		animation.add('dbljump', [7, 8, 9, 6], 5, false);	// Double Jump
		animation.add('fall', [10, 11, 12], 12, true);	// Fall
		animation.add('dash', [15, 16, 17], 12, true);	// Dash
		
		//Physics & Jump
		drag.set(_runSpeed * 8, _runSpeed * 8);
		maxVelocity.set(_runSpeed, _jumpSpeed);
		acceleration.y = _gravity;

		//Initialize Mandolin
		_mando = new Mandolin(this);	
	}

	override public function update(elapsed:Float):Void
	{
		acceleration.x = 0;
		acceleration.y = _gravity;
		
		//If in a cutscene, don't allow the player to move
		if (!playerFrozen){
			movement();			//Trigger walking logic		
			jump(elapsed);		//Trigger jump logic
			dash(elapsed);		//Trigger dash logic
			_mando.instrumentKeys();
			_mando.noteTimer(elapsed);
		}

		//Reset double jump on collision
		if (isTouching(FlxObject.FLOOR) && !FlxG.keys.anyPressed(_jumpKeys))
		{
			_jumpTime = -1;
			_timesJumped = 0;  // Reset the double jump flag
			setJumpSongGround(true);
		}

		super.update(elapsed);
	}

/* FUNCTIONS FOR PLAYER MOVEMENT*/
	function movement():Void
	{
		// Defining Character Keys
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);
		isWalking = false;

		// Disallow Opposite Actions to occur
		if (_left && _right){
			_left = _right = false;
		}
		
		//Walking Code	 
		if (_left)	{
			acceleration.x = -drag.x;
			if (velocity.y == 0 && velocity.x != 0){
				animation.play('walk');
				isWalking = true;
			}
			facing = FlxObject.LEFT;
		}
		else if (_right)	{
			acceleration.x = drag.x;
			if (velocity.y == 0 && velocity.x != 0){
				animation.play('walk');
				isWalking = true;
			}
			facing = FlxObject.RIGHT;
		}
		
		//Idle Animation
		if (!isWalking && (velocity.y == 0))
			animation.play('idle');
	}

	/* Current Jump Code */
	private function jump(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(_jumpKeys))
		{
			if ((velocity.y == 0) && (_timesJumped < _jumpsAllowed-1)) // Only allow two jumps
			{
				if (_timesJumped == 0 && velocity.y!=0)	//if first jump & already falling
					_timesJumped++;
				_timesJumped++;
				_jumpTime = 0;
				velocity.y = - 0.6 * maxVelocity.y;
				animation.play('jump');
			}
		}

		if (jumpSong)
		{
			if ((velocity.y != 0 || _timesJumped > 0) && _timesJumped < _jumpsAllowed) // If not on ground or we've already jumped
			{
				if (_timesJumped == 0 && velocity.y!=0)	//if first jump & already falling
					_timesJumped++;
				_timesJumped++;
				_jumpTime = 0;
				velocity.y = - 0.6 * maxVelocity.y;
				setJumpSongGround(false);
				animation.play('dbljump');
			}
			setJumpPlayed(false);
		}

		if(!(FlxG.keys.anyPressed(_jumpKeys)) && velocity.y < 0 && jumpSongGround){
			acceleration.y = _gravity * 3;
		} else{
			acceleration.y = _gravity;
		}
	}

	/*Dash function */
	private function dash(elapsed:Float):Void{
		if(dashSong && _dashTime == -1){
			
			if(this.facing ==FlxObject.LEFT){
				_dashTime = 0;
				//dash left
				velocity.x -= _dashSpeed;
				maxVelocity.set(_dashSpeed, _jumpSpeed);
			} else if(this.facing ==FlxObject.RIGHT){
				_dashTime = 0;
				//dash right
				velocity.x += _dashSpeed;
				maxVelocity.set(_dashSpeed, _jumpSpeed);
			}

			setDashPlayed(false);
		}
		
		if(_dashTime >= 0){
			_dashTime += elapsed;

			if(_dashTime > _dashDuration){
				//end the dash
				maxVelocity.set(_runSpeed, _jumpSpeed);
			}

			if(_dashTime > _dashCooldown){
				_dashTime = -1;
			}

			setDashPlayed(false);
		}
	}

/* HELPER FUNCTIONS FOR SONGS */	
	public function setDashPlayed(condition:Bool):Void{
		dashSong = condition;
	}
	public function setJumpPlayed(condition:Bool):Void{
		jumpSong = condition;
	}
	public function setPlayerFrozen(condition:Bool):Void{
		playerFrozen = condition;
	}
	private function setJumpSongGround(condition:Bool):Void{
		jumpSongGround = condition;
	}
}
