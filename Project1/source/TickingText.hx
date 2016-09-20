package;
import flixel.text.FlxText;
import flixel.FlxG;
import openfl.Assets;
/**
 * ...
 * @author wrighp
 */
class TickingText extends FlxText
{
	public var allText:Array<String>;
	public var speed:Float;
	public var sound:String;
	public var doSkip:Bool = true; //Should the text skip after a certain amount of time
	public var paused = false;
	
	private var _currentText:String;
	private var _time:Float = 0;
	private var _ellipses:Float = 0;
	private var _index:Int = 0;
	
	
	/**
	 * Creates text that will begin ticking in on update, and automatically skip forward if doSkip == true
	 * @param	customText	If true, will not load any textData. Modify allText to add more lines.
	 * @param	textFile	File location within assets/data/ of text file to load. Text is displayed up to every newline character.
	 * @param	speed	Interval between every new character is added.
	 * @param	size	Font size.
	 * @param	sound	Sound to play at every new character.
	 * @param	margin	Size of the margin on either side.
	 * @param	height	Y position of the text.
	 */
	public function new(?customText:Bool = false,?textFile:String,?speed:Float = .04,?size:Int = 24, ?sound:String = "textScroll",?margin:Int = 24,?height:Int = 36)
	{
		super(margin,height, FlxG.width - margin, "", size);
		if (!customText){
			allText = Assets.getText("assets/data/" + textFile).split("\n");
		}else{allText = new Array<String>(); }
		_currentText = "";
		this.sound = sound;
		this.speed = speed;
		this.borderColor = 0xff000000;
		this.borderStyle = SHADOW;
		this.borderSize = 3;
		this.scrollFactor.set(0, 0);
		//trace("Initializing Text");

	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if(!paused){
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
			}else if(doSkip){
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
	/**
	 * Can be called to reset the text back to start.
	 */
	public function resetText():Void{
		this.revive();
		_currentText = "";
		text = _currentText;
		_time = 0;
		_ellipses = 0;
		_index = 0;
	}
}