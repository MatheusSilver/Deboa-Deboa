package;

class EstadoDeTrocaReverso extends MusicBeatState
{ // Obviamente eu poderia fazer algo mais geral, mas considerando que o problema era só aqui, não havia muito pra eu me preocupar na real
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		PlayState.limparCache = true;

		new flixel.util.FlxTimer().start(0.5, function(tmr:flixel.util.FlxTimer)
		{
			if (PlayState.modohistoria){
				PlayState.modohistoria = false;
				MusicBeatState.switchState(new MenuPreHistoria());
			}else
				MusicBeatState.switchState(new FreeplayState());
		});
	}
}