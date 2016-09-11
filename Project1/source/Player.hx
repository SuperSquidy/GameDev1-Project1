/*
This file contains information pertaining to the player character including :
 - Player Controls : WASD & Arrow Keys for movement
 					 HJKL; for Instrument
 - Helper Vars for Motion : speed, rotation, drag
 - Initializes Mandolin

This file WILL :
 - Trigger Music from the Mandolin Class
 - Contain character images & animations
 - Contain character walking sound effects
 - Remember the last several keys pressed, and trigger songs as played

Don't know how to refer to awkward keys, like ESC or EQUALS?
Reference the FlxKeyList : http://api.haxeflixel.com/flixel/input/keyboard/FlxKeyList.html 
*/


package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxSprite
{

/* HELPER VARIABLES */
	//Movement Conditionals
	var speed:Float = 200;
	var _rot: Float = 0;
	var _drag: Float = 1300;	//Mild slide when stopping

	//Key Based
	var _up:Bool = false;
	var _down:Bool = false;
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
		makeGraphic(32,64, FlxColor.GREEN);
		drag.x = drag.y = _drag;
		_mando = new Mandolin();	//Initialize Mandolin
	}

	override public function update(elapsed:Float):Void
	{
		movement();
		instrumentKeys();
		super.update(elapsed);
	}

/* FUNCTIONS FOR PLAYER MOVEMENT*/
	/* Current Movement Code, Courtesy of Dr. Marc */
	function movement():Void
	{

		//Defining Character Keys
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);	

		// Disallow Opposite Actions to occur
		if (_up && _down){
			_up = _down = false;
		}
		if (_left && _right){
			_left = _right = false;
		}
		
		//Movement Code	 
		if (_up || _down || _left || _right){
			if (_left)
			{
				_rot = 180;
				if (_up) _rot += 45;
				else if (_down) _rot -= 45;
			}
			else if (_right)
			{
				_rot = 0;
				if (_up) _rot -= 45;
				else if (_down) _rot += 45;
			}
			else if (_down) _rot = 90;
			else if (_up) _rot = 270;
			 
		 	velocity.set(speed,0);
			velocity.rotate(new FlxPoint(0,0), _rot);
		 }
	
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
				instrumentUpdateRecentNotes(Notes[_notePlayed]);			//Storing off the played note for song recognition
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
