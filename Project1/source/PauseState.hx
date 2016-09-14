package;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
/**
 * ...
 * @author wrighp
 */
class PauseState extends FlxSubState
{
	private var _overlay:FlxSprite;
	private var _text:Array<TickingText>;
	override public function create():Void 
	{
		super.create();
		_parentState.persistentDraw = true;
		_overlay = new FlxSprite();
		_overlay.makeGraphic(1, 1, FlxColor.WHITE);
		_overlay.scale.set(FlxG.width, FlxG.height);
		_overlay.screenCenter();
		_overlay.scrollFactor.set(0, 0);
		add(_overlay);
		opened();
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.TAB){ //Close out window
			this.forEachOfType(TickingText, function(t){t.kill(); });
			close();
		}
	}
	public function opened():Void{
		if (this._created){
			//Fade color overlay in
			FlxTween.color(_overlay, .2, FlxColor.fromRGB(0, 32, 32, 0), FlxColor.fromRGB(0, 32, 32, 128));
			_overlay.alpha = 0;
			FlxTween.tween(_overlay, {alpha : .5}, .2);
			
			//Temporary example of how text will be added
			for (i in 0...4){
				var text = new TickingText(true, .04 + .01 * i,24);
				text.y = 80 + 36 * i;
				text.doSkip = false;
				text.allText.push("???????");
				add(text);
			}
		}
	}
}