package;
import Shrine;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG.sound;

/*NONE OF THIS CODE DOES ANYTHING*/
class FadeBackground extends FlxSprite
{
	public function new(?X:Float=0, ?Y:Float=0){
		super(X, Y);

		loadGraphic('assets/images/blackFade.png', true, 2400, 1600);
		animation.add('fadeOut', [0, 1, 2, 3, 4, 5], 5, false);
		animation.frameIndex = 2; // The frame you want to display
		WorldState.instance.add(this);
	}

	public function endGame(){
		animation.play('fadeOut', false, 0);
	}
}