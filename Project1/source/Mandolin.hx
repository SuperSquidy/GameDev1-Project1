/*
This file contains the information & logic for processing the instrument including
- Processing key presses for the instrument
- Playing notes
- Keeping track of recent notes played
- Keeping track of what songs the player has unlocked
- Processes songs & triggers appropriate actions in other classes [Incomplete Feature]

Current Plan:
	- Mandolin will not play multiple notes at once:
	  When it registers multiple buttons are pressed, it will
	  play the note with the lowest index in stringsDown
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
	var _playerCharacter:FlxSprite;

	//Song Processing
	var _recentNotes:Array<String> = ["", "", "", "", ""];	//This will contain a list of the most recent keys pressed
	var _waterSong:Array<String> = ["L",";"];		//Double Jump
	var _windSong:Array<String> = ["J", "J", "J"];	//Dash
	var _earthSong:Array<String>;					//Grow a temporary plant platform
	var _starSong:Array<String>;					//Fill the sky with stars
	
	//Flag Processing - True if the player has access to the special effects of the song
	//NOTE : Set true for testing purposes only.
	var _waterActive:Bool = true;		
	var _windActive:Bool = true;
	var _earthActive:Bool = true;
	var _starActive:Bool = true;


/* CONSTRUCTOR */	
	public function new(player:FlxSprite){
		super();
		_playerCharacter = player;
	}

/* FUNCTIONS TO PLAY NOTES */
	private function playC3(){
		FlxG.sound.play("koto_c3");	}
	private function playG2(){
		FlxG.sound.play("koto_g2");	}
	private function playC2(){
		FlxG.sound.play("koto_c2");	}
	private function playG1(){
		FlxG.sound.play("koto_g1");	}
	private function playC1(){
		FlxG.sound.play("koto_c1");	}

/* FUNCTIONS FOR INSTRUMENT PROCESSING */
	
	//@function : plays notes when a key is pressed and updates the last played note array
	public function instrumentKeys():Void
	{
		if (FlxG.keys.justPressed.H){
			playC3();
			updateNotes("H");		}
		else if (FlxG.keys.justPressed.J){
			playG2();
			updateNotes("J");		}
		else if (FlxG.keys.justPressed.K){
			playC2();
			updateNotes("K");		}
		else if (FlxG.keys.justPressed.L){
			playG1();
			updateNotes("L");		}
		else if (FlxG.keys.justPressed.SEMICOLON){
			playC1();
			updateNotes(";");		}
	}

	/*  @function : Updates _recentNotes as keys are played
			The most recent 5 notes are remembered, with the newest
			note being stored in the lowest index

			I.e if _recentNotes = ["A, B, C, D, E"] & _note = 'Q'
				_recentNotes becomes ["Q, A, B, C, D"]
		@parameter : _note is the note that will be
			replace the oldest note in _recentNotes
	*/
	private function updateNotes(_note:String)
	{
		_recentNotes.pop();				//Remove the note on the end
		_recentNotes.unshift(_note);	//Add the new note to the beginning
	}

	private function 

/*FUNCTIONS FOR SONG MATCHING*/
/*
	These functions (one for each song) checks first, whether the
	song is available to be played by the player
*/
	private function checkJumpSong(_notes:Array<String>):Bool{	//Water Song
		if (!waterActive)
			return false;

		var isActive:Bool = true;
		for (i in 0 ... _waterSong.length){		//Otherwise check if most recent notes match the song
			if _notes[i] != _waterSong[i]
				isActive false;
		}
			
		return isActive;	
	}
	private function checkDashSong(_notes:Array<String>):Bool{	//Wind Song
		if (!windActive)		//If song inactive, no logic neccessary
			return false;

		var isActive:Bool = true;			
		for (i in 0 ... _windSong.length){		//Otherwise check if most recent notes match the song
			if _notes[i] != _windSong[i]
				isActive false;
		}
			
		return isActive;

	}
	private function checkEarthSong(_notes:Array<String>):Bool{	//Earth Song
		if (!earthActive)		//If song inactive, no logic neccessary
			return false;

		var isActive:Bool = true;
		for (i in 0 ... _earthSong.length){		//Otherwise check if most recent notes match the song
			if _notes[i] != _earthSong[i]
				isActive false;
		}
			
		return isActive;
	}
	public function checkStarSong(_notes:Array<String>):Bool{	//Ballad of Stars
		if (!starActive)	//If song inactive, no logic neccessary
			return false;

		var isActive:Bool = true;
		for (i in 0 ... _starSong.length){		//Otherwise check if most recent notes match the song
			if _notes[i] != _starSong[i]
				isActive false;
		}
			
		return isActive;
	}

/*FUNCTIONS FOR WHEN PlAYER UNLOCKS SONGS */
/*
	These functions (one for each) can be called to activate a song
	so that the player can play it & have its action performed
*/
	public function enableWaterSong(){
		_waterActive = true;
	}
	public function enableWindSong(){
		_windActive = true;
	}
	public function enableEarthSong(){
		_earthActive = true;
	}
	public function enableStarSong(){
		_starActive = true;
	}

}