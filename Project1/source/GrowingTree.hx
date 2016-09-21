package;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.debug.FlxDebugger;
import flixel.FlxObject;

/**
 * ...
 * @author wrighp
 */
class GrowingTree extends FlxSprite
{
	private static inline var SONG_DISTANCE = 1000;
	
	private var _lifeDuration:Float;
	private var _lifeLeft:Float;
	/**
	 * Tree goes through this animation cycle idle_small -> grow -> idle_large -> ungrow ->idle_small
	 * After each animation is completed finishAnimation is called with the name of the current animation.
	 * @param	X	X position.
	 * @param	Y	Y position.
	 * @param	lifeDuration = 5	How long the tree will last for, before ungrowing.
	 */
	public function new(X:Float,Y:Float, ?lifeDuration:Float = 20) 
	{
		super(X - 32, Y - 96);
		this.immovable = true;
		_lifeDuration = lifeDuration;
		var tileSizeX = 96;
		var tileSizeY = 128;
		loadGraphic('assets/images/Plant_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("idle_small", [0], 0, false);
		animation.play("idle_small", false);
		animation.add("grow", [0, 1, 2], 3, false);
		animation.add("idle_large", [2], 0, false);
		animation.add("ungrow", [3,4], 2, false);
		animation.finishCallback = finishAnimation;
		this.height = 32;
		allowCollisions = FlxObject.NONE;
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (animation.name == "idle_large" ||animation.name == "ungrow"){
			_lifeLeft -= elapsed;
			if (_lifeLeft <= 1){
				animation.play("ungrow");
				//remove hitbox
				//allowCollisions = FlxObject.NONE;
			}
			if(_lifeLeft <= 0){
				allowCollisions = FlxObject.NONE;
				animation.play("idle_small");
			}
		}
	}
	private function finishAnimation(name:String):Void{
		if (name == "grow"){
			animation.play("idle_large");
			//add hitbox
			allowCollisions = FlxObject.CEILING;
		}
		else if (name == "ungrow"){
			animation.play("idle_small");
		}
	}
	
	//Called when tree is grown with music
	public function grow():Void{
		if (animation.name == "idle_small"){
			_lifeLeft = _lifeDuration;
			animation.play("grow");
		}
	}
	
	//Called when mandolin plays earth song
	public static function onPlayMusic(){
		//Can add song effect here
		var pos = WorldState.instance.player.getPosition();
		var playerPoint:FlxVector = new FlxVector(pos.x,pos.y);
		for (t in WorldState.instance.trees){
			var tree = cast(t, GrowingTree);
			var point:FlxVector =new FlxVector(tree.x,tree.y);
			if (playerPoint.dist(point) < SONG_DISTANCE){
				tree.grow();
			}
		}
	}
}