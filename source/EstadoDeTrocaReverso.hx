package;

class EstadoDeTrocaReverso extends MusicBeatState
{ // Obviamente eu poderia fazer algo mais geral, mas considerando que o problema era só aqui, não havia muito pra eu me preocupar na real
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		PlayState.limparCache = true;
		PlayState.movecameraallowed = true;

		flixel.FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		flixel.FlxG.sound.music.fadeIn(4, 0, 0.7);
		//As vezes brutalidade não é a melhor solução : D

		new flixel.util.FlxTimer().start(0.5, function(tmr:flixel.util.FlxTimer)
		{
			if (PlayState.modohistoria){
				PlayState.modohistoria = false;
				MusicBeatState.switchState(new MenuPreHistoria());
				MenuPreHistoria.maintainVisible = false;
			}else
				MusicBeatState.switchState(new FreeplayState());
		});
	}
}