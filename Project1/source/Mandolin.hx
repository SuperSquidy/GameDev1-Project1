/*
This file contains information & functions related to the Mandolin instrument, including :
 - 


This file WILL contain :


Current Plan:
	- Mandolin will not play multiple notes at once:
	  When it registers multiple buttons are pressed, it will
	  play the note with the lowest index in stringsDown

	  Reference playNotes() below
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

	public function new(){
		super();
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
	public function playNotes(stringsDown:Array<Bool>):Int{

		var _note:Int = -1;
		var _tmpLen:Int = stringsDown.length;

		//Determine Note to Play
		for (i in 1..._tmpLen+1){
			if (stringsDown[_tmpLen-i] == true)
				_note = i;
		}

		//Play Note
		switch (_note) { 
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
		}

		return _note;	//Return index of the note played
	}

}