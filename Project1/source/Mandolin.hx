/*
This file contains information pertaining to the player character including :
 - Controls : WASD, Arrow Keys

This file WILL contain :
 - Instrument Controls
 - Character images & animations
 - Character walking sound effects

Current Plan:
	Mandolin will be able to play multiple notes at once
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
		@parameters : stringsDown
			Array of Booleans where each index represents 
			whether that key is currently being pressed or 
			not, corresponding to this mapping: [ h, j, k, l, ;]
	*/
	public function playNotes(stringsDown:Array<Bool>):Void{


	}


}