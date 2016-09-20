package;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.ui.KeyCode;
import openfl.Assets;

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
		FlxG.keys.reset();
		opened();
		
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.TAB){ //Close out window
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
			/*for (i in 0...4){
				var text = new TickingText(true, .04 + .01 * i,24);
				text.y = 80 + 36 * i;
				text.doSkip = false;
				text.allText.push("???????");
				add(text);
			}*/
			
			var text:String;
			
			//These very verbose method chains are because the songs are written backwards in Mandolin.
			for (i in 0...4){
				if (i == 0 ){//&& WaterShrine.songLearned){
					var reversedWater = FlxStringUtil.formatArray(Reg.mando.getWaterSong()).split(',');
					reversedWater.reverse();
					text = "Hymn of Rain:     " + FlxStringUtil.formatArray(reversedWater) + "\n" + Assets.getText("assets/data/" + "Hymn_of_Rain_Description.txt");
					createText(.04 + .005 * i,(80 + 36 * i),text);
					continue;
				}
				else if(i == 1 ){ //&& Reg.mando.getWindActive()){
					var reversedWind = FlxStringUtil.formatArray(Reg.mando.getWindSong()).split(',');
					reversedWind.reverse();
					text = "Aria of Breezes     " + FlxStringUtil.formatArray(reversedWind) + "\n" + Assets.getText("assets/data/" + "Aria_of_Breezes_Description.txt");
					createText(.04 + .005 * i,(80 + 36 * i) * 2.6,text);
					continue;
				}
				else if(i == 2){//} && ScarecrowShrine.songLearned){
					var reversedEarth = FlxStringUtil.formatArray(Reg.mando.getEarthSong()).split(',');
					reversedEarth.reverse();
					text = "Song of Growth     " + FlxStringUtil.formatArray(reversedEarth) + "\n" + Assets.getText("assets/data/" + "Song_of_Growth_Description.txt");
					createText(.04 + .005 * i,(80 + 36 * i) * 3.5,text);
					continue;
				}
				else if(i == 3 ){ //&& Reg.mando.getStarActive()){
					var reversedStar = FlxStringUtil.formatArray(Reg.mando.getStarSong()).split(',');
					reversedStar.reverse();
					text = "Ballad of Stars     " + FlxStringUtil.formatArray(reversedStar) + "\n" + Assets.getText("assets/data/" + "Ballad_of_Stars_Description.txt");
					createText(.04 + .005 * i,(80 + 36 * i) * 4.0,text);
					continue;
				}
				else{
					text = "????????   ? ? ?";
				}
				text = StringTools.replace(text, ",", "   "); //Set the text to be placed in between each keypress.
				createText(.04 + .005 * i,(80 + 36 * i) * 3,text);
			}
		}
	}
	/**
	 * 
	 * @param	Speed	Interval before every new character is added.
	 * @param	Y		Height of text.
	 * @param	textString	String of text to display.
	 */
	private function createText(Speed:Float, Y:Float, textString:String){
		var text = new TickingText(true,Speed,24);
		text.y = Y;
		text.doSkip = false;
		text.allText.push(textString);
		add(text);
	}
}