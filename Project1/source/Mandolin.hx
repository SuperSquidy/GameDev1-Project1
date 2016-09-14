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

	- Songs will always remember notes if a song is not played:
		This means that a player can play JJ then wait 5 minutes
		and play the third J to trigger the dash
			^ Assuming they have played nothing else in between

Need to Implement:
	- Timer feature so that after x frames or seconds where no notes are 
	  played, recent notes reset
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

	//Song Processing
	var _recentNotes:Array<String>	= ["", "", "", "", ""];		//This will contain a list of the most recent keys pressed
	var _waterSong:Array<String>	= ["L",";"];				//Double Jump
	var _windSong:Array<String> 	= ["J", "J", "J"];			//Dash
	var _earthSong:Array<String>	= ["", ""];					//Grow a temporary plant platform
	var _starSong:Array<String> 	= [ "", ""];				//Fill the sky with stars
	
	//Flag Processing - True if the player has access to the special effects of the song
	//NOTE : Set true for testing purposes only.
	var _waterActive:Bool = true;		
	var _windActive:Bool = true;
	var _earthActive:Bool = true;
	var _starActive:Bool = true;

/* CONSTRUCTOR */	
	public function new(player:Player){
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
		if (checkSongPlayed(_waterSong, _waterActive)){
			resetRecentNotes();		//Clear last song played
			//Trigger Double Jump
			//Trigger Succesful Song Animation | Particles
			//Trigger additional sound file
		}

		//Wind Song
		if (checkSongPlayed(_windSong, _windActive)){
			resetRecentNotes();		//Clear last song played
			_playerCharacter.setDashPlayed(true);		//Trigger Player Dash
			//Trigger Succesful Song Animation | Particles
			//Trigger additional sound file
		}

		//Earth Song
		if (checkSongPlayed(_earthSong, _earthActive)){
			resetRecentNotes();		//Clear last song played
			//Trigger Earth Platform Thing
			//Trigger Succesful Song Animation | Particles
			//Trigger additional sound file
		}

		//Star Song
		if (checkSongPlayed(_starSong, _starActive)){
			resetRecentNotes();		//Clear last song played
			//Trigger Star Song
			//Trigger Succesful Song Animation | Particles
			//Trigger additional sound file
		}
	}


	/*	@function : Checks if a given song has been played & if the
			player has unlocked the given song
		@parameter
			_song  : The song of the element to check
			_songActive : Boolean if the song has been unlocked
	*/
	private function checkSongPlayed(_song:Array<String>, _songActive:Bool):Bool{	//Water Song
		if (!_songActive)
			return false;

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