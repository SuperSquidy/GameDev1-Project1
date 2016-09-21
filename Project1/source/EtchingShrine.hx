package;

/**
 * ...
 * @author ...
 */
class EtchingShrine extends Shrine
{

	public static var songLearned:Bool = false;
	private static var storyLearned:Bool = false;

	//Initializing Story-related Variables
	var ticker:TickingText;

	override private function create():Void{
		super.create();
		//Don't worry about offsets for now
		var tileSizeX = 64;
		var tileSizeY = 32;

		//Sprite Sheet & Animations
		loadGraphic('assets/images/Shrines/WindShrine_SongStone.png', true, tileSizeX, tileSizeY);
		//Initialize Text Assets
		ticker = new TickingText(false, "Windshrine_etching_interact_2.txt", .04, 12, "Wind_Text", 100, Std.int(y) - 200);
		ticker.x = this.x -250;  ticker.fieldWidth = 550;
		
	}

	public override function onActivate():Void{
		if(!songLearned)
			learnSong();
	}

	private function finishInteraction(name:String):Void
	{
		if (name == "interacted"){
			animation.play("looping",true);	
		}	
	}

	/*	@function : Triggers scrolling text to learn song
	*/
	private function learnSong(){
		trace("Learning Song");
		songLearned = true;
		Reg.mando.enableWindSong();
		WorldState.instance.add(ticker);
		ticker.scrollFactor.set(1,1);
	}
}
