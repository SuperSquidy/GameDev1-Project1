package;
import flixel.text.FlxText;
import flixel.FlxG;
import openfl.Assets;
/**
 * ...
 * @author ...
 */
class TickingText extends FlxText
{
	public var allText:Array<String>;
	public var speed:Float;
	public var sound:String;
	
	private var _currentText:String;
	private var _time:Float = 0;
	private var _ellipses:Float = 0;
	private var _index:Int = 0;
	public function new(filename:String, ?height:Int = 36,?padding:Int = 24, ?size:Int = 24,?speed:Float = .04, ?sound:String = "blip2")
	{
		super(padding, height,FlxG.width-padding,"", size);
		allText = Assets.getText("assets/data/" + filename).split("\n");
		_currentText = "";
		this.sound = sound;
		this.speed = speed;
		this.borderColor = 0xff000000;
		this.borderStyle = SHADOW;
		this.scrollFactor.set(0, 0);
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (_currentText.length < allText[_index].length){
			_time += elapsed;
			var played = false;
			while (_time > speed && _currentText.length < allText[_index].length){
				_time -= speed;
				var char =  allText[_index].charAt(_currentText.length);
					if (!played && char != ' '){
						FlxG.sound.play(sound, .5, false);
						played = true;
					}
					_currentText += char;
					text = _currentText;
			}
		}else{
			_time = 0;
			if (_ellipses < 3){
				if (Std.int(_ellipses+elapsed) > Std.int(_ellipses )){
					_currentText += ". ";
					FlxG.sound.play(sound,.5,false);
				}
				text = _currentText;
			} else if (_ellipses > 4){
				skipText();
			}
			_ellipses += elapsed;
		}
		
	}
	public function skipText():Void
	{
		if (_currentText.length < allText[_index].length){
			_time = 999999; //Adds the rest of the text 
		}
		else if (++_index < allText.length){
			_ellipses = 0;
			_currentText = "";
			_time = 0;
		}else{
			kill();
		}
		
	}
}