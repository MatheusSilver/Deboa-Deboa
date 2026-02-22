package;

// limpeza pros primeiros states

class Init extends MusicBeatState {
	override function create() {
		super.create();

		#if android
		flixel.FlxG.android.preventDefaultKeys = [BACK];
		#end
		
		ClientPrefs.init(); // nao precisava das outras funções de init(). elas ja estao nessa funcao aqui.

		// Eu deixei a verificação aqui desse jeito, pois, vai que a pessoa coloca uma GPU enquanto joga o mod? Ou não?
		Main.is_GPU_allowed = checkGPU();
		if (Main.is_GPU_allowed != true) 
    		ClientPrefs.loadingexperimental = false;

		MusicBeatState.switchState(ClientPrefs.firstBoot ? new Linguagem.LanguageState() : new TitleState());
	}

	/* Essa função checa se há disponível aceleração por hardware ou renderização por software */
	inline private function checkGPU():Bool {
		#if mobile
		return true;
		#end

		if(FlxG.stage == null)
			return false;
		if(FlxG.stage.context3D == null)
			return false;

		final var driver = FlxG.stage.context3D.driverInfo;
		// A aceleração por software pode ser por causa de driver antigo, funcao desabilitada e etc.
		// Sem aceleração por hardware, não é pertinente o uso da GPU e até não seguro no caso de ausência de uma.
		return !driver.startsWith("Software");
	}
}