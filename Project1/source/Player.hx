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

This file WILL :
 - Contain character images & animations
 - Contain character walking sound effects

Don't know how to refer to awkward keys, like ESC or EQUALS?
Reference the FlxKeyList : http://api.haxeflixel.com/flixel/input/keyboard/FlxKeyList.html

Current Jump Mechanics:
 - Jump with W or SPACE
 - Double Jump by pressing either a second time
 - Double Jump can be triggered mid-air
 	i.e Walking off a platform, one jump can still be performed while falling
 - Dash with E
 	dashing from platform to same level platform will make you fall, since gravity
 		kicks in when you get off the platform
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
	private var _dashElapsed:Float;

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

		//PC Art
		this.set_pixelPerfectRender(true); //Removes jitter
		loadGraphic('assets/images/staticPC.png', false, 32, 64); //static PC art
		
		// setFacingFlip(direction, flipx, flipy)
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

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
		
		jump(elapsed);		//Trigger jump logic
		movement();			//Trigger walking logic
		_mando.instrumentKeys();
		_dashElapsed = elapsed;
		dash(elapsed);

		//Reset double jump on collision
		if (isTouching(FlxObject.FLOOR) && !FlxG.keys.anyPressed(_jumpKeys))
		{
			_jumpTime = -1;
			_timesJumped = 0;  // Reset the double jump flag
		}

		super.update(elapsed);
	}

/* FUNCTIONS FOR PLAYER MOVEMENT*/
	/* Current Movement Code, Courtesy of Dr. Marc */
	function movement():Void
	{

		//Defining Character Keys
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);	

		// Disallow Opposite Actions to occur
		if (_left && _right){
			_left = _right = false;
		}
		
		//Movement Code	 
		if (_left)	{
			acceleration.x = -drag.x;		
			facing = FlxObject.LEFT;
		}
		else if (_right)	{
			acceleration.x = drag.x;		
			facing = FlxObject.RIGHT;
		}
	}

	/* Current Jump Code, Courtesy of Project Jumper Demo */
	private function jump(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(_jumpKeys))
		{
			if ((velocity.y == 0) || (_timesJumped < _jumpsAllowed)) // Only allow two jumps
			{
				if (_timesJumped == 0 && velocity.y!=0)	//if first jump & already falling
					_timesJumped++;
				_timesJumped++;
				_jumpTime = 0;
				velocity.y = - 0.6 * maxVelocity.y;
			}
		}

		if(!(FlxG.keys.anyPressed(_jumpKeys)) && velocity.y < 0){
			acceleration.y = _gravity * 3;
		} else{
			acceleration.y = _gravity;
		}

		/*
		
		// You can also use space or any other key you want
		if ((FlxG.keys.anyPressed(_jumpKeys)) && (_jumpTime >= 0)) 
		{
			_jumpTime += elapsed;
			
			// You can't jump for more than 0.25 seconds
			if (_jumpTime > 0.25)
			{
				_jumpTime = -1;
			}
			else if (_jumpTime > 0)
			{
				velocity.y = - 0.6 * maxVelocity.y;
			}
		}
		else
			_jumpTime = -1.0;

		*/
	}

	/*Dash function */
	public function dash(elapsed:Float):Void{
		if(FlxG.keys.justPressed.E && _dashTime == -1){
			
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
		}
	}

	public function getElapsed():Float{
		return _dashElapsed;
	}


}
