package;
import flixel.FlxSprite;

/**
 * ...
 * @author wrighp
 */
class Shrine extends FlxSprite
{

	public function new(X:Float, Y:Float, ?Scale:Float = 2) 
	{
		super(X, Y);
		create();
		scale.set(Scale, Scale);
		centerOrigin();
		updateHitbox();
		x -= frameWidth*Scale / (2);
		y -= frameHeight*(Scale)-32;
	}
	private function create(){	}
	public function onActivate(){
		animation.play("interacted", false);
	}
}