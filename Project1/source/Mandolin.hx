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

class Mandolin extends FlxBasic
{

	public function new(){
		super();
	}

	/*
		@parameters : stringsDown<Bool>
			Array of Booleans where each index represents 
			whether that key is currently being pressed or 
			not, corresponding to this mapping: [ h, j, k, l, ;]

		@return : returns the index of the note chosen to be played
		Current mapping can be found in Player.hx under instrumentKeys()
	*/
	public function playNotes(stringsDown:Array<Bool>):Int{

		//insert switch statement here
		return 0;
	}

}