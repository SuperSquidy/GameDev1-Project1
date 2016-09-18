package;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.debug.FlxDebugger;

/**
 * ...
 * @author wrighp
 */
class GrowingTree extends FlxSprite
{
	private static inline var SONG_DISTANCE = 400;
	
	private float _lifeDuration;
	private float _lifeLeft;
	/**
	 * 
	 * @param	X	X position.
	 * @param	Y	Y position.
	 * @param	lifeDuration = 5	How long the tree will last for, before ungrowing.
	 */
	public function new(X:Float,Y:Float, ?lifeDuration = 5) 
	{
		super(X, Y);
		_lifeDuration = lifeDuration;
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	//Called when tree is grown with music
	public function grow():Void{
		
	}
	
	//Called when mandolin plays earth song
	public static function onPlayMusic(){
		//Can add song effect here
		var playerPoint:FlxVector = WorldState.instance.player.getPosition();
		for (tree:GrowingTree in WorldState.instance.trees){
			var point:FlxVector = tree.getPosition();
			if (playerPoint.dist(point) < SONG_DISTANCE){
				tree.grow();
			}
		}
	}
}