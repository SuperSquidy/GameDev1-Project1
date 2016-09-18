package;
import flixel.FlxSprite;

/**
 * ...
 * @author wrighp
 */
class Shrine extends FlxSprite
{

	private var collisionPlayer:Bool;

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
	
	override public function update(elapsed:Float):Void{
		//check collision player
			//setCollisionPlayer
		super.update(elapsed);
	}

	private function create(){	}
	
	public function onActivate(){
		animation.play("interacted", false);
	}

	private function setCollisionPlayer(condition:Bool):Void{
		collisionPlayer = condition;
	}

	public function getCollisionPlayer():Bool{
		return collisionPlayer;
	}


}