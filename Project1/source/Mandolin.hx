/*
This file contains the information & logic for processing the instrument including
- Processing key presses for the instrument
- Playing notes
- Keeping track of recent notes played
- Keeping track of what songs the player has unlocked
- Processes songs & triggers appropriate actions in other classes [Incomplete Feature]

Current Implementation:
	- Mandolin does not play multiple notes at once:
	  	When it registers multiple buttons are pressed, it will
	  	play the note with the lowest index in stringsDown

	  	Note that note sounds can overlap if played a frame apart

	- When a song is succesffuly played, the recent notes array clears:
		For cases like dash ("JJJ"), this means they have to replay
		the whole song to dash again, and cannot just hit one more J
		to dash again after cd

	- Notes will be forgotten after a few seconds of nothing played
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
	var _playerCharacter:Player;
	var _timer:Float = -1;
	private static inline var _timerCooldown:Float = 3.0;
	var _notesThisFrame:Bool = false;

	//Song Processing : Note songs are stored backwards
	var _recentNotes:Array<String>	= ["", "", "", "", "", "", "", "", ""];		//List of the most recent keys pressed
	public static var _waterSong:Array<String>	= [";","L"];				//Double Jump
	public static var _windSong:Array<String> 	= ["J", "J", "J"];			//Dash
	public static var _earthSong:Array<String>	= ["H", "J", "L", "K", "H"];					//Grow a temporary plant platform
	public static var _starSong:Array<String> 	= [ "H", "J", "J", "K", "L"];	//Fill the sky with stars
	
	//Flag Processing - True if the player has access to the special effects of the song
	//Changed to public static so that they persist between levels
	public static var _waterActive:Bool;		
	public static var _windActive:Bool;
	public static var _earthActive:Bool;
	public static var _starActive:Bool;

	//Holds true if a song was just played
	private var _playedWater:Bool = false;
	private var _playedWind:Bool = false;
	private var _playedEarth:Bool = false;
	private var _playedStar:Bool = false;

/* CONSTRUCTOR */	
	public function new(player:Player){
		super();
		_playerCharacter = player;
	}

/* FUNCTIONS TO PLAY NOTES */
	private function playC3(){
		FlxG.sound.play("koto_c3");	}
	private function playG2(){
		FlxG.sound.play("koto_g3");	}
	private function playC2(){
		FlxG.sound.play("koto_c2");	}
	private function playG1(){
		FlxG.sound.play("koto_g1");	}
	private function playC1(){
		FlxG.sound.play("koto_c1");	}

/*HELPER FUNCTIONS*/
	//Resets the recent notes
	private function resetRecentNotes(){
		_recentNotes = ["", "", "", "", ""];
	}

	/* @function : Keeps track of timer & scrubs 
		recent notes if timer runs out
	*/
	public function noteTimer(elapsed:Float){
		if (getNotesThisFrame())					//If played a note, reset timer
			_timer = 0;
		else 									//Else Increment timer
			_timer += elapsed;
		
		if (_timer >= _timerCooldown)			//If timer reaches CD, scrub recent notes
			resetRecentNotes();
	}

	//Notes played this frame
	private function getNotesThisFrame():Bool{
		return _notesThisFrame;
	}

	private function setNotesThisFrame(condition:Bool):Void{
		_notesThisFrame = condition;
	}

/* FUNCTIONS FOR INSTRUMENT PROCESSING */
	
	//@function : plays notes when a key is pressed and updates the last played note array
	public function instrumentKeys():Void
	{
		setNotesThisFrame(true);
		if (FlxG.keys.justPressed.H){
			playC1();
			updateNotes("H");		}
		else if (FlxG.keys.justPressed.J){
			playG1();
			updateNotes("J");		}
		else if (FlxG.keys.justPressed.K){
			playC2();
			updateNotes("K");		}
		else if (FlxG.keys.justPressed.L){
			playG2();
			updateNotes("L");		}
		else if (FlxG.keys.justPressed.SEMICOLON){
			playC3();
			updateNotes(";");		}
		else{
			setNotesThisFrame(false);
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
	private function updateNotes(_note:String)
	{
		_recentNotes.pop();				//Remove the note on the end
		_recentNotes.unshift(_note);	//Add the new note to the beginning
		activateSongs();
	}

	/* @function : Determines if an unlocked song has
			been played, and then triggers the corres-
			ponding items that belong with it.
	*/
	private function activateSongs():Void{
		//Water Song
		if (checkSongPlayed(_waterSong)){
			resetRecentNotes();							//Clear last song played
			waterPlayed(true);
			if(_waterActive){
				_playerCharacter.setJumpPlayed(true);		//Trigger Player DoubleJump
				//Trigger Succesful Song Animation | Particles
			}
		}
		else{
			waterPlayed(false);
		}

		//Wind Song
		if (checkSongPlayed(_windSong)){
			resetRecentNotes();							//Clear last song played
			windPlayed(true);
			if(_windActive){
				_playerCharacter.setDashPlayed(true);		//Trigger Player Dash
				//Trigger Succesful Song Animation | Particles
			}
		}
		else{
			windPlayed(false);
		}
		
		//Earth Song
		if (checkSongPlayed(_earthSong)){
			resetRecentNotes();		//Clear last song played
			earthPlayed(true);
			if (_earthActive){
				GrowingTree.onPlayMusic();
				//Trigger additional sound file ?
			}
		}
		else{
			earthPlayed(false);
		}

		//Star Song
		if (checkSongPlayed(_starSong)){
			trace("StarSong Played");
			resetRecentNotes();		//Clear last song played
			starPlayed(true);
			//if (_starActive)
				//Trigger Star Song
		}
		else{
			starPlayed(false);
		}
	}


	/*	@function : Checks if a given song has been played & if the
			player has unlocked the given song
		@parameter
			_song  : The song of the element to check
			_songActive : Boolean if the song has been unlocked
	*/
	private function checkSongPlayed(_song:Array<String>):Bool{	//Water Song
		var isActive:Bool = true;
		for (i in 0 ... _song.length){		//Otherwise check if most recent notes match the song
			if (_recentNotes[i] != _song[i])
				isActive = false;
		}
			
		return isActive;	
	}
	
/*FUNCTIONS UNLOCKING SONGS */
/*
	These functions (one for each) can be called to activate a song
	so that the player can play it & have its action performed
*/
	public function enableWaterSong(){
		_waterActive = true;	}
	public function enableWindSong(){
		_windActive = true;		}
	public function enableEarthSong(){
		_earthActive = true;	}
	public function enableStarSong(){
		_starActive = true;		}

/*FUNCTIONS FOR KEEPING TRACK OF SONGS Played*/
	public function waterPlayed(condition:Bool)
		_playedWater = condition;
	public function windPlayed(condition:Bool)
		_playedWind = condition;
	public function earthPlayed(condition:Bool)
		_playedEarth = condition;
	public function starPlayed(condition:Bool)
		_playedStar = condition;
	public function getWaterPlayed():Bool
		return _playedWater;
	public function getWindPlayed():Bool
		return _playedWind;
	public function getEarthPlayed():Bool
		return _playedEarth;
	public function getStarPlayed():Bool
		return _playedStar;

/*HELPER FUNCTIONS FOR ACCESSING VARS*/
	public function getWaterActive():Bool
		return _waterActive;
	public function getWindActive():Bool
		return _windActive;
	public function getEarthActive():Bool
		return _earthActive;
	public function getStarActive():Bool
		return _starActive;
	public function getWaterSong():Array<String>
		return _waterSong;
	public function getWindSong():Array<String>
		return _windSong;
	public function getEarthSong():Array<String>
		return _earthSong;
	public function getStarSong():Array<String>
		return _starSong;

}