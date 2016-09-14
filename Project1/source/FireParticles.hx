package;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flash.display.BlendMode;
import flixel.util.FlxColor;
/**
 * ...
 * @author wrighp
 */
class FireParticles extends FlxEmitter
{
	private static inline var NUM_PARTICLES = 100;
	
	public function new(?x:Float=0,?y:Float=0) 
	{
		var spread = 5;
		super((x - spread / 2), y);
		
		for (i in 0 ... NUM_PARTICLES){
			var part = new FlxParticle();
			part.loadGraphic("assets/images/particle16.png",false,8,8);
			part.exists = false;
			this.add(part);
		}
		this.setSize(spread, spread);
		this.launchMode = FlxEmitterMode.SQUARE;
		this.blend = BlendMode.ADD;
		this.velocity.set( -10, -20, 10, -50);
		this.alpha.set(.75, .75, 0, 0);
		this.lifespan.set(.75,1.25);
		this.color.set(0xF60000, 0xFF6000, 0x000000, 0x000000);
		this.scale.set(.25, .5, 1, 1.25);
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (_explode && countLiving() == 0){
			kill();
		}
	}
}