import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

enum SyncStatus {
	INIT;
	SYNCING;
	TESTING;
	FINISHED;
}

class SyncState extends MusicBeatState {	
	static inline var BEAT_INTERVAL:Float = 0.5;
	static inline var TOTAL_ROUNDS:Int = 3;
	static inline var TOTAL_SIGNALS:Int = 3;	

	var bg:FlxSprite;

	var testingSoundLight:FlxSound;
	var testingSoundHeavy:FlxSound;

	var explanationText:FlxText;
	var detailsText:FlxText;

	var offset:Int = 0;

	
	var status:SyncStatus = INIT;
	var lightPlayCount:Int = 0;
	var syncDelays:Array<Float> = [];
	var currentSyncDelay:Float = 0;
	var currentSoundTime:Float = 0;

	// Serve para impedir que alguem aperte espaço antes do quarto hit sequer ter tocado.
	var canPressToSync:Bool = false;

	override function create() {
		FlxG.sound.music.volume = 0;
		super.create();
		Main.mouse_allowed = false;

		testingSoundLight = new FlxSound().loadEmbedded(Paths.sound('osu/10', 'shared'));
		testingSoundHeavy = new FlxSound().loadEmbedded(Paths.sound('osu/11', 'shared'));
		testingSoundLight.volume = testingSoundHeavy.volume = 1;

		bg = new FlxSprite(0, 0, Paths.image("blackscreen", "preload"));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter(XY);
		add(bg);

		explanationText = new FlxText(0, 50, FlxG.width, '', 48);
		explanationText.setFormat(Paths.font("letravio.ttf"), 32, FlxColor.WHITE, CENTER);
		explanationText.screenCenter(X);
		explanationText.scrollFactor.set();
		explanationText.text = "Sincronização de som";
		add(explanationText);

		detailsText = new FlxText(0, 0, FlxG.width, '', 36);
		detailsText.setFormat(Paths.font("letravio.ttf"), 32, FlxColor.WHITE, CENTER);
		detailsText.scrollFactor.set();
		detailsText.text = "Esta sincronização calibrará o atraso do seu fone Bluetooth\n" +
							"Você ouvirá três batidas leves e depois uma batida forte\n\n" +
							"Aperte ESPAÇO quando ouvir a batida forte\n" +
							"Aperte ESPAÇO para começar";
		detailsText.updateHitbox();
		detailsText.screenCenter(XY);
		add(detailsText);
	}

	private function startSyncing() {
		status = SYNCING;
		syncDelays = [];
		playFirstLight();
	}

	private function playFirstLight() {
		lightPlayCount = 0;
		testingSoundLight.play();
		lightPlayCount++;
		// Esse timer aqui é para a próxima batida. (Neste caso, a segunda batida)
		new FlxTimer().start(BEAT_INTERVAL, function(_) {
			playNextLight();
		});
	}

	private function playNextLight() {
		if(lightPlayCount < TOTAL_SIGNALS) {
			testingSoundLight.play();
			lightPlayCount++;
			// Esse timer aqui é para a próxima batida.

			if (lightPlayCount == TOTAL_SIGNALS) canPressToSync = true;
			new FlxTimer().start(BEAT_INTERVAL, function(_) {
				playNextLight();
			});
		} else {
			testingSoundHeavy.play();
			currentSoundTime = haxe.Timer.stamp(); // tempo em milisegundos
		}
	}

	private function registerResults() {
		
		var currentPressTime = haxe.Timer.stamp(); // tempo em milisegundos
		currentSyncDelay = currentPressTime - currentSoundTime;
		syncDelays.push(currentSyncDelay);
		finishSyncRound();
	}

	private function startSyncRound(){
		currentSoundTime = 0;
		testingSoundLight.stop();
		canPressToSync = false;
		new FlxTimer().start(BEAT_INTERVAL, function(_) {
			playFirstLight(); 
		});
	}

	private function finishSyncRound() {
		if(syncDelays.length < TOTAL_ROUNDS)
			startSyncRound();
		else
			startTesting();
	}

	private function calculateAverageDelay():Float {
		var avgDelay = 0.0;

		for(delay in syncDelays) avgDelay += delay;
		
		avgDelay /= syncDelays.length;
		
		return avgDelay;
	}


	//Aqui era para ter alguma coisa que desse indicação visual do som calibrado, mas já fritei meu cerébro para pensar em tudo até aqui.
	private function startTesting() {
		status = TESTING;
		offset = Math.round(calculateAverageDelay());
		
		detailsText.text = "Teste de sincronização\nAtraso: " + Std.string(offset) + "ms\n" +
		"aperte ENTER PARA salvar os resultados!\n" +
		"ou aperte R para começar o teste de novo";
		detailsText.alpha = 1;
		detailsText.visible = true;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(status == INIT && FlxG.keys.justPressed.SPACE) {
			GlobalSoundManager.play(confirmMenu);
			FlxTween.tween(detailsText, {alpha: 0}, 1, {
				ease: FlxEase.quartInOut,
				onComplete: function(_) {
					detailsText.visible = false;
					startSyncing();
				}
			});
		}
		else if(status == SYNCING && canPressToSync && FlxG.keys.justPressed.SPACE 
					&& lightPlayCount >= TOTAL_SIGNALS) registerResults();
		else if(status == TESTING) {
			if(FlxG.keys.justPressed.ENTER) {
				detailsText.text = "Atraso: " + Std.string(offset) + "ms\n\nAperte ESPAÇO para continuar";
				status = FINISHED;
			}
			else if(FlxG.keys.justPressed.R) {
				status = INIT;
				detailsText.alpha = 1;
				detailsText.text = "Aperte ESPAÇO para recomeçar o teste";
			}
		}
		else if(status == FINISHED && FlxG.keys.justPressed.SPACE) {
			ClientPrefs.noteOffset = offset;
			ClientPrefs.save();
			MusicBeatState.switchState(new ajustes.AjustesState());
		}
	}
}