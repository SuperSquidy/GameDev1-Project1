/*
This file contains information & functions related to the Mandolin instrument, including :
 - 


This file WILL contain :


Current Plan:
	- Mandolin will not play multiple notes at once:
	  When it registers multiple buttons are pressed, it will
	  play the note with the lowest index in stringsDown

	  Reference playNotes() below

Potential Issue:
	Don't know how Flixel handels array matching. There may end up being an issue where
		["L, I"]
*/

package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG.sound;


class Mandolin extends FlxBasic
{
	//var _playerCharacter:FlxSprite;
	//Key Based
	var _h:Bool = false;
	var _j:Bool = false;
	var _k:Bool = false;
	var _l:Bool = false;
	var _semi:Bool = false;

	//Song Processing
	var _recentNotes:Array<String> = ["", "", "", "", ""];	//This will contain a list of the most recent keys pressed
	var _waterSong:Array<String> = ["L",";"];		//Double Jump
	var _windSong:Array<String> = ["J", "J", "J"];	//Dash
	var _earthSong:Array<String>;					//Grow a temporary plant platform
	var _starSong:Array<String>;					//Fill the sky with stars
	
	public function new(player:FlxSprite){
		super();
	//	_playerCharacter = player;
	}

	/*
		@function : plays a note & returns the index of the note played

		@parameters : stringsDown<Bool>
			Array of Booleans where each index represents 
			whether that key is currently being pressed or 
			not, corresponding to this mapping: [ h, j, k, l, ;]

		@return : returns the index of the note that was played

		Current mapping can be found in Player.hx under instrumentKeys()
	*/
	private function playNotes(stringsDown:Array<Bool>):Int{

		var _note:Int = -1;
		var _tmpLen:Int = stringsDown.length;

		//Determine Note to Play
		for (i in 1..._tmpLen+1){
			if (stringsDown[_tmpLen-i] == true)
				_note = i;
		}

		//Play Note
		//Koto
		switch (_note) { 
   			case 1:	//Logged to ;
				FlxG.sound.play("koto_c3");
      		case 2:
				FlxG.sound.play("koto_g2");
   			case 3: 
				FlxG.sound.play("koto_c2");	
   			case 4: 
				FlxG.sound.play("koto_g1");
      		case 5: //Logged to h
				FlxG.sound.play("koto_c1");
      		default:
      			return -1;
		}

		//Mandolin
		/*switch (_note) { 
   			case 1: 
				FlxG.sound.play("Mando11");		//Logged to ";"
   			case 2: 
				FlxG.sound.play("Mando19");
      		case 3:
				FlxG.sound.play("Mando36");
      		case 4:
				FlxG.sound.play("Mando39");
      		case 5:
				FlxG.sound.play("Mando55");
      		default:
      			return -1;
		}	*/

		return _note;	//Return index of the note played
	}

/* FUNCTIONS FOR INSTRUMENT PROCESSING */
	/* Key Reading for Instrument | Currently Mapped to : 'h j k l ;' */
	public function instrumentKeys():Void
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
			

			var _notePlayed = playNotes(_stringsDown);	//_notePlayed refers to the index of Notes, not the note itself

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


/*FUNCTIONS FOR CHECKING IF A SONG WAS JUST PLAYED*/
	public function checkJumpSong(_notes:Array<String>):Bool{	//Water Song
		if (_notes == _waterSong)
			return true;
		return false;
	}

	public function checkDashSong(_notes:Array<String>):Bool{	//Wind Song
		if (_notes == _windSong)
			return true;
		return false;
	}

	public function checkEarthSong(_notes:Array<String>):Bool{	//Earth Song
		if (_notes == _earthSong)
			return true;
		return false;
	}

	public function checkStarSong(_notes:Array<String>):Bool{	//Ballad of Stars
		if (_notes == _starSong)
			return true;
		return false;
	}


}