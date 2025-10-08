package;

// limpeza pros primeiros states

class Init extends MusicBeatState {
	override function create() {
		super.create();

		#if android
		flixel.FlxG.android.preventDefaultKeys = [BACK];
		#end
		
		ClientPrefs.init(); // nao precisava das outras funções de init(). elas ja estao nessa funcao aqui.

		MusicBeatState.switchState(ClientPrefs.firstBoot ? new Linguagem.LanguageState() : new TitleState());
	}
}