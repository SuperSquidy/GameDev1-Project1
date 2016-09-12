/*
This file contains information pertaining to the player character including :
 - Player Controls : WASD & Arrow Keys for movement
 					 HJKL; for Instrument
 - Helper Vars for Motion : speed, rotation, drag
 - Initializes Mandolin
 - Triggers Mandolin to play notes
 - Jump & Double Jump Capabilities
 - Store recent jump keypresses

This file WILL :
 - Trigger Songs from the Mandolin Class
 - Contain character images & animations
 - Contain character walking sound effects

Don't know how to refer to awkward keys, like ESC or EQUALS?
Reference the FlxKeyList : http://api.haxeflixel.com/flixel/input/keyboard/FlxKeyList.html

Current Jump Mechanics:
 - Jump with W or SPACE
 - Double Jump by pressing either a second time
 - Double Jump can be triggered mid-air
 	i.e Walking off a platform, one jump can still be performed while falling
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
	public static inline var _jumpSpeed:Int = 650;
	public static inline var _jumpsAllowed:Int = 2;

	private var _jumpTime:Float = -1;
	private var _timesJumped:Int = 0;
	private var _jumpKeys:Array<FlxKey> = [W, SPACE];

	//Movement Conditionals
	var _runSpeed:Float = 200;
	var _rot: Float = 0;
	var _drag: Float = 1300;	//Mild slide when stopping

	//Key Based
	var _left:Bool = false;
	var _right:Bool = false;

	//Instrument Based
	var _mando:Mandolin;
	var _h:Bool = false;
	var _j:Bool = false;
	var _k:Bool = false;
	var _l:Bool = false;
	var _semi:Bool = false;
	var _recentNotes:Array<String> = ["", "", "", "", ""];	//This will contain a list of the most recent keys pressed

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
		_mando = new Mandolin();	
	}

	override public function update(elapsed:Float):Void
	{
		acceleration.x = 0;
		acceleration.y = _gravity;
		
		jump(elapsed);		//Trigger jump logic
		movement();			//Trigger walking logic
		instrumentKeys();	//Trigger notes-playing logic

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
			}
		}
		
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
	}

/* FUNCTIONS FOR INSTRUMENT PROCESSING */
	/* Key Reading for Instrument | Currently Mapped to : 'h j k l ;' */
	function instrumentKeys():Void
	{
		//Defining Music Keys
		_h = FlxG.keys.justPressed.H;
		_j = FlxG.keys.justPressed.J;
		_k = FlxG.keys.justPressed.K;
		_l = FlxG.keys.justPressed.L;
		_semi = FlxG.keys.justPressed.SEMICOLON;	//Check API -> looking for "SEMICOLON"


		if (_h || _j || _k || _l || _semi){
			//Array that stores notes for _recentNotes
			var Notes = ["H", "J", "K", "L", ";"];

			//Sending Notes to Mandolin & determing what was played
			var _stringsDown = [_h, _j, _k, _l, _semi];
			

			var _notePlayed = _mando.playNotes(_stringsDown);	//_notePlayed refers to the index of Notes, not the note itself

			if (_notePlayed != -1)								//Default case if no notes where played
				instrumentUpdateRecentNotes(Notes[_notePlayed]);	//Storing off the played note for song recognition
		}
	}


	/*  @function : Updates _recentNotes as keys are played
			The most recent 5 notes are remembered, with the newest
			note being stored in the lowest index

			I.e if _recentNotes = ["A, B, C, D, E"] & _note = 'Q'
				_recentNotes becomes ["Q, A, B, C, D"]
		@parameter : _note is the note that will be
			replace the oldest note in _recentNotes
	*/
	function instrumentUpdateRecentNotes(_note:String)
	{
		_recentNotes.pop();				//Remove the note on the end
		_recentNotes.unshift(_note);	//Add the new note to the beginning
	}
}
