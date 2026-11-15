package;

import flixel.FlxG;
using StringTools;


// limpeza pros primeiros states

class Init extends MusicBeatState {
	override function create() {
		ClientPrefs.init(); // nao precisava das outras funções de init(). elas ja estao nessa funcao aqui.

		// Eu deixei a verificação aqui desse jeito, pois, vai que a pessoa coloca uma GPU enquanto joga o mod? Ou não?
		Main.is_GPU_allowed = checkGPU();
		if (Main.is_GPU_allowed != true) 
    		ClientPrefs.loadingexperimental = false;

		super.create();

		#if android
		flixel.FlxG.android.preventDefaultKeys = [BACK];
		#end

		MusicBeatState.switchState(ClientPrefs.firstBoot ? new Linguagem.LanguageState() : new TitleState());
	}

	/* Essa função checa se há disponível aceleração por hardware ou renderização por software */
	private function checkGPU():Bool {
		#if mobile
		return true;
		#end

		if(FlxG.stage == null || FlxG.stage.context3D == null) return false;

		final driver:String = FlxG.stage.context3D.driverInfo;
		// A aceleração por software pode ser por causa de driver antigo, funcao desabilitada e etc.
		// Sem aceleração por hardware, não é pertinente o uso da GPU e até não seguro no caso de ausência de uma.
		return !driver.startsWith("Software");
	}
}