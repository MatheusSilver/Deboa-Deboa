package fx;

import flixel.FlxG;
import flixel.addons.editors.pex.FlxPexParser;
import flixel.effects.particles.FlxEmitter;

class ParticleParser extends FlxEmitter
{
    private var pexName:String;
    private var UPDATE_INTERVAL:Float = 1.0 / 60.0;
    private var timeAccumulated:Float = 0.0;

    public function new(width:Float, height:Float, scale:Float, frequency:Float, pexName:String)
    {
        this.pexName = pexName;
        super(0, 0, 75); // O 50 serve pra evitar que o manito estoure a quantidade partículas na tela.
        initEmitter(scale);
        this.setSize(width, height);
        this.start(false, frequency);
    }

    private function initEmitter(scale:Float):Void
    {
        var pexFile:Array<Dynamic> = Paths.pex(this.pexName);
        FlxPexParser.parse(pexFile[0], pexFile[1], this, scale);
    }

    private function shouldUpdate():Bool
    {
        return timeAccumulated >= UPDATE_INTERVAL;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        timeAccumulated += elapsed;
        while (shouldUpdate())
        {
            var baseSpeed:Float = 100.0; //Pode ser qualquer velocidade inicial.

            for (particle in this.members)
            {
                if (particle != null && particle.exists && particle.active)
                {
                    //Só pra não parecer que tá todo mundo seguindo uma linha reta.
                    var randomXAccel:Float = FlxG.random.float(-6, 6);
                    var randomYAccel:Float = FlxG.random.float(-4, 4);

                    particle.acceleration.set(randomXAccel, randomYAccel);


                    particle.velocity.x += particle.acceleration.x;
                    particle.velocity.y += particle.acceleration.y;

                    //Tenho minhas duvidas se isso é nescessário, mas por segurança...
                    if (particle.velocity.x > baseSpeed)
                        particle.velocity.x = baseSpeed;
                    else if (particle.velocity.x < -baseSpeed)
                        particle.velocity.x = -baseSpeed;

                    if (particle.velocity.y > baseSpeed)
                        particle.velocity.y = baseSpeed;
                    else if (particle.velocity.y < -baseSpeed)
                        particle.velocity.y = -baseSpeed;

                    
                    //Por algum motivo a velocidade e aceleração do Haxe não funcionam no modo automático, então o jeito é fazer na mão :fist::pensive:
                    particle.setPosition(particle.x + particle.velocity.x * UPDATE_INTERVAL, particle.y + particle.velocity.y * UPDATE_INTERVAL);
                }
            }
            timeAccumulated -= UPDATE_INTERVAL;
        }
    }
}
