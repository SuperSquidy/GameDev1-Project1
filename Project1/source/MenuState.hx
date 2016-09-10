package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;

class MenuState extends FlxState
{

	private var _emitter:FlxEmitter;

	override public function create():Void
	{
		super.create();

		_emitter = new FlxEmitter(FlxG.width / 2 , FlxG.height / 2, 200);
		
		// All we need to do to start using it is give it some particles. makeParticles() makes this easy!
		
		_emitter.makeParticles(2, 2, FlxColor.WHITE, 200);

		add(_emitter);

		_emitter.start(false, 0.01);


	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
