package multiplayer;

import multiplayer.ResultsSubstate.PlayerProperties;
import FunkinLua;
import Song.SwagSection;
import Song.SwagSong;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.addons.ui.FlxUIInputText;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxSort;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.ErrorEvent;
import openfl.display.Loader;
import multiplayer.MultiplayerMainMenuState;
import NoteSplash;
import CoolUtil;
import multiplayer.menus.Lobby;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class MultiplayerPlayState extends MusicBeatSubstate
{
	private var strumLine:FlxSprite;
	private var comboGroup:FlxTypedGroup<FlxSprite>;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	public var strumBGS:FlxTypedGroup<StrumBG>;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	var generatedMusic:Bool = false;
	var vocals:FlxSound;

	var startOffset:Float = 0;
	var startPos:Float = 0;
	var _song:SwagSong;
	var isPlayer1:Bool = true;

	public var podeComecar:Int = 0;

	public var podeTerminar:Int = 0;

	var queriaTerminar:Bool = false;
	var terminarTxt:FlxText;

	public static var instance:MultiplayerPlayState;

	var blackStuff:FlxSprite;
	var waitingForOthers:FlxText;

	var currentMode:Int = 0;

	var mySkin:String;
	var oppSkin:String;

	var myBf:Boyfriend;
	var oppBf:Boyfriend;
	var oppName:String;

	public function new(startPos:Float, whichSong:String, isHost:Bool, trocarLados:Bool, modo:Int, myObject:LobbyPlayer, oppObject:LobbyPlayer)
	{
		instance = this;
		currentMode = modo;
		mySkin = MultiplayerMainMenuState.instance.skins[MultiplayerMainMenuState.instance.skinAtual][1];
		oppSkin = oppObject.noteSkin;

		oppName = oppObject.getName();

		this.startPos = startPos;
		Song.Conductor.songPosition = startPos - startOffset;
		if (!trocarLados)
		{
			isPlayer1 = !isHost;
		}
		else
		{
			isPlayer1 = isHost;
		};

		var http = new haxe.Http(whichSong);
		var songJson:String;
		http.onData = function(data:String)
		{
			songJson = data;
		}

		http.onError = function(error)
		{
			songJson = null;
		}

		http.request();

		if (songJson != null)
		{
			_song = Song.parseJSONshit(songJson);
			_song.arrowSkin = "NOTE_assets";
			_song.splashSkin = "noteSplashes";
			PlayState.SONG = _song;
			startOffset = Song.Conductor.crochet;
			timerToStart = startOffset;
		}
		super();
	}

	var scoreTxt:FlxText;

	// var opponentScoreTxt:FlxText;
	public var opponentHits:Int = 0;
	public var opponentMisses:Int = 0;
	public var opponentScore:Int = 0;

	var timerToStart:Float = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();

	public var luaArray:Array<FunkinLua> = [];

	override function create()
	{
		updateTime = true;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		add(bg);

		myBf = new Boyfriend(0, 0, "bf", null, false);
		myBf.playAnim('idle', false, false, 10);
		oppBf = new Boyfriend(0, 0, "bf", null, false);
		oppBf.playAnim('idle', false, false, 10);

		add(myBf);
		add(oppBf);

		ready = new FlxSprite().loadGraphic(Paths.image('ready', 'shared'));
		set = new FlxSprite().loadGraphic(Paths.image('set', 'shared'));
		go = new FlxSprite().loadGraphic(Paths.image('go', 'shared'));

		if (ClientPrefs.focus)
		{
			strumBGS = new FlxTypedGroup<StrumBG>(3);
			add(strumBGS);
		}

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if (ClientPrefs.downScroll)
			strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		comboGroup = new FlxTypedGroup<FlxSprite>();
		add(comboGroup);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		if (ClientPrefs.focus) {
			strumBGS.add(new StrumBG(playerStrums));

			if(!ClientPrefs.middleScroll) {
				strumBGS.add(new StrumBG(opponentStrums));
			}
		}

		generateStaticArrows(0, oppSkin);
		generateStaticArrows(1, mySkin);

		if (!isPlayer1 && !ClientPrefs.middleScroll)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x -= 645;
			});
			opponentStrums.forEach(function(spr:FlxSprite)
			{
				spr.x += 645;
			});
		}

		myBf.x = playerStrums.getFirstAlive().x;
		oppBf.x = opponentStrums.getFirstAlive().x;
		myBf.screenCenter(Y);
		oppBf.screenCenter(Y);

		if (!ClientPrefs.downScroll)
		{
			myBf.y += 100;
			oppBf.y += 100;
		}

		if(ClientPrefs.middleScroll) {
			for (note in playerStrums) {
				strumLineNotes.remove(note);
			}
			playerStrums.clear();
			generateStaticArrows(1, mySkin, true);

			opponentStrums.forEachAlive(function (note:StrumNote) {
				note.visible = false;
			});
		}

		myBf.flipX = !isPlayer1 ? true : false;
		oppBf.flipX = isPlayer1 ? true : false;

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		if (_song != null)
		{
			if (_song.needsVoices)
				vocals = new FlxSound().loadEmbedded(Paths.voices(_song.song));
			else
				vocals = new FlxSound();
			generateSong(_song.song);
			
			#if LUA_ALLOWED
			for (notetype in noteTypeMap.keys()) {
				var luaToLoad:String = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(Assets.exists(luaToLoad)) {
					var lua:editors.EditorLua = new editors.EditorLua(luaToLoad);
					new FlxTimer().start(0.1, function (tmr:FlxTimer) {
						lua.stop();
						lua = null;
					});
				}
			}
			#end
			noteTypeMap.clear();
			noteTypeMap = null;
		}
		else
		{
			FlxG.log.error("Algo deu errado, tentando terminar a partida.");
			MultiplayerMainMenuState.instance.enviarPrecisoTerminar();
		}

		scoreTxt = new FlxText(0, ClientPrefs.downScroll ? 25 : FlxG.height - 65, FlxG.width, "", 50);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);

		Main.mouse_allowed = false;

		blackStuff = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackStuff.screenCenter(XY);
		blackStuff.alpha = 0.5;
		add(blackStuff);
		waitingForOthers = new FlxText(0, 0, FlxG.width, Linguagem.LangUtil.getString("game_loading_txt", "multiplayer"), 30);
		waitingForOthers.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		waitingForOthers.screenCenter(XY);
		add(waitingForOthers);

		terminarTxt = new FlxText(20, ClientPrefs.downScroll ? 40 : FlxG.height - 80, FlxG.width,
			Linguagem.LangUtil.getString("game_stop_text", "multiplayer"), 17);
		terminarTxt.color = FlxColor.BLACK;
		terminarTxt.visible = false;
		add(terminarTxt);

		RecalculateRating();
		super.create();
	}

	function hitNoteBf(who:Boyfriend, idAnim:Int)
	{
		var animToPlay:String = "";
		switch (Std.int(Math.abs(idAnim)))
		{
			case 0:
				animToPlay = 'singLEFT';
			case 1:
				animToPlay = 'singDOWN';
			case 2:
				animToPlay = 'singUP';
			case 3:
				animToPlay = 'singRIGHT';
		}
		who.playAnim(animToPlay != "" ? animToPlay : 'none', true);
		who.holdTimer = 0;
	}

	var ready:FlxSprite;
	var set:FlxSprite;
	var go:FlxSprite;
	var countDownSprites:Array<FlxSprite> = [];
	var saidGo:Bool = false;

	function sayGo()
	{
		saidGo = true;
		waitingForOthers.destroy();
		blackStuff.destroy();

		var loops:Int = 0;
		new FlxTimer().start(Song.Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			loops++;
			switch (Std.int(loops))
			{
				case 1:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 2:
					ready.scrollFactor.set();
					ready.updateHitbox();

					ready.screenCenter();
					ready.antialiasing = ClientPrefs.globalAntialiasing;
					add(ready);
					countDownSprites.push(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, 0.4, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							countDownSprites.remove(ready);
							remove(ready);
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 3:
					set.scrollFactor.set();
					set.screenCenter();
					set.antialiasing = ClientPrefs.globalAntialiasing;
					add(set);
					countDownSprites.push(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, 0.9, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							countDownSprites.remove(set);
							remove(set);
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 4:
					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();
					go.antialiasing = ClientPrefs.globalAntialiasing;
					add(go);
					countDownSprites.push(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, 0.4, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							countDownSprites.remove(go);
							remove(go);
							MultiplayerMainMenuState.instance.enviarToPronto();
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
			}
		}, 4);
	}

	var songScore:Int = 0;
	var songHits:Int = 0;
	var songMisses:Int = 0;
	var ghostMisses:Int = 0;
	var startingSong:Bool = true;
	var duetSongs:Array<String> = ["phantasm"];
	var goDuet:Bool = false;
	private var isRing:Bool = false;

	private function generateSong(dataPath:String):Void
	{
		FlxG.sound.playMusic(Paths.inst(_song.song), 0, false);
		FlxG.sound.music.pause();
		FlxG.sound.music.onComplete = endSong;
		vocals.pause();
		vocals.volume = 0;

		var songData = _song;
		Song.Conductor.changeBPM(songData.bpm);

		notes = new NoteGroup();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;
		isRing = _song.isRing;

		goDuet = duetSongs.contains(songData.song.toLowerCase());

		if (!isPlayer1 || goDuet)
		{
			var count:Int = 4;
			for (s in 0...noteData.length)
			{
				for (i in 0...noteData[s].sectionNotes.length)
				{
					var note:Array<Dynamic> = noteData[s].sectionNotes[i];
					if (note[1] > -1)
					{
						note[1] = (note[1] + count) % (count * 2);
						noteData[s].sectionNotes[i] = note;
					}
				}
			}
		}

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		for (section in noteData)
		{
			loadSegment(section);
			if (goDuet)
				loadSegment(section, true);
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);
		generatedMusic = true;

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			MultiplayerMainMenuState.instance.enviarToPronto();
		});
	}

	function loadSegment(section:SwagSection, copy_for_dad:Bool = false)
	{
		for (songNotes in section.sectionNotes)
		{
			if (songNotes[1] > -1 && !isRing)
			{ // Real notes - excluindo-se as notas de anel.
				/*if (songNotes[3] == "" || songNotes[3] == null || songNotes[3] == "dualSing" || songNotes[3] == "GF Sing")
				{*/
					if (isRing && songNotes[1] >= 2)
						songNotes[1] -= songNotes[1] >= 7 ? 2 : 1;
					// 2 pra remover a nota de anel tanto do opp quanto do bf, 1 pra remover só do bf.

					var daStrumTime:Float = songNotes[0];
					if (daStrumTime >= startPos)
					{
						var daNoteData:Int = Std.int(songNotes[1] % 4);

						var gottaHitNote:Bool = section.mustHitSection;

						if (songNotes[1] > 3)
						{
							gottaHitNote = !copy_for_dad ? !section.mustHitSection : section.mustHitSection;
						}

						var oldNote:Note;
						if (unspawnNotes.length > 0)
							oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
						else
							oldNote = null;

						var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
						swagNote.mustPress = gottaHitNote;
						swagNote.sustainLength = songNotes[2];
						swagNote.noteType = songNotes[3];
						if (!Std.isOfType(songNotes[3], String))
							swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; // Backward compatibility + compatibility with Week 7 charts
						swagNote.scrollFactor.set();

						var susLength:Float = swagNote.sustainLength;

						susLength = susLength / Song.Conductor.stepCrochet;
						unspawnNotes.push(swagNote);

						var floorSus:Int = Math.floor(susLength);
						if (floorSus > 0)
						{
							for (susNote in 0...floorSus + 1)
							{
								oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

								var sustainNote:Note = new Note(daStrumTime
									+ (Song.Conductor.stepCrochet * susNote)
									+ (Song.Conductor.stepCrochet / FlxMath.roundDecimal(_song.speed, 2)),
									daNoteData, oldNote, true);
								sustainNote.mustPress = gottaHitNote;
								sustainNote.noteType = swagNote.noteType;
								sustainNote.scrollFactor.set();
								unspawnNotes.push(sustainNote);

								if (sustainNote.mustPress)
								{
									sustainNote.x += FlxG.width / 2; // general offset
									sustainNote.texture = "multiplayer/notes/" + mySkin;
								}
								else
								{
									sustainNote.x += FlxG.width / 1.5;
									sustainNote.texture = "multiplayer/notes/" + oppSkin;
								}
							}
						}

						if (swagNote.mustPress)
						{
							swagNote.x += FlxG.width / 2; // general offset
							swagNote.texture = "multiplayer/notes/" + mySkin;
						}
						else
						{
							swagNote.x += FlxG.width / 1.5;
							swagNote.texture = "multiplayer/notes/" + oppSkin;
						}

						if (!noteTypeMap.exists(swagNote.noteType))
						{
							noteTypeMap.set(swagNote.noteType, true);
						}
					}
				//}
			}
		}
	}

	function startSong():Void
	{
		startingSong = false;
		previousFrameTime = FlxG.game.ticks;
		FlxG.sound.music.time = startPos;
		FlxG.sound.music.play();
		FlxG.sound.music.volume = 1;
		vocals.volume = 1;
		vocals.time = startPos;
		vocals.play();
	}

	override function close()
	{
		Main.mouse_allowed = true;
		// results aqui, fazer que os dois tenham que confirmar pra continuar aí eles voltam pro menu
		MultiplayerMainMenuState.instance.endMatch();
		super.close();
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	var endingSong:Bool = false;

	public function endSong()
	{
		endingSong = true;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			vocals.stop();
			vocals.destroy();
		}

		if (podeTerminar > 1)
		{
			close();
		}
		else
		{
			MultiplayerMainMenuState.instance.send_results([sicks, goods, bads, shits], combo, accuracy);
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.volume = 0;
			}
			new FlxTimer().start(5, function(tmr:FlxTimer)
			{
				mostrarResults();
			});
		}
		trace("cabou !");
	}

	public var oppCombo:Int;
	public var oppAccuracy:Float;
	public var oppResults:Array<Int>;

	function mostrarResults()
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.volume = 0;
		}

		var resultsScreen:ResultsSubstate = new ResultsSubstate(new PlayerProperties(gamejolt.GJClient.userName, songScore, combo, accuracy,
			[sicks, goods, bads, shits]),
			new PlayerProperties(oppName, opponentScore, oppCombo, oppAccuracy, oppResults), isPlayer1);
		add(resultsScreen);
		switch (euGanhei())
		{
			case 0:
				trace(Linguagem.LangUtil.getString("results_tie_text", "multiplayer"));
			case 1:
				trace(Linguagem.LangUtil.getString("results_win_text", "multiplayer"));
			case -1:
				trace(Linguagem.LangUtil.getString("results_lose_text", "multiplayer"));
		}
		new FlxTimer().start(18, function(tmr:FlxTimer)
		{
			close();
		});
	}

	function euGanhei():Int
	{
		// 0 = empate, 1 = ganhou, -1 = perdeu
		var sera:Int = 0;
		switch (currentMode)
		{
			case 0:
				sera = songScore > opponentScore ? 1 : songScore == opponentScore ? -1 : -1;
			case 1:
				sera = songHits > opponentHits ? 1 : songHits == opponentHits ? 0 : -1;
			case 2:
				sera = songMisses < opponentMisses ? 1 : songMisses == opponentMisses ? 0 : -1;
		}
		return sera;
	}


	var previousFrameTime:Int = 0;
	var songTime:Float = 0;
	var updateTime:Bool = false;

	override function update(elapsed:Float)
	{
		var roundedSpeed:Float = FlxMath.roundDecimal(_song.speed, 2);
		if (unspawnNotes[0] != null)
		{
			var time:Float = 1500;
			if (roundedSpeed < 1)
				time /= roundedSpeed;
			if (unspawnNotes[0].multSpeed < 1)
				time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Song.Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned = true;
				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			keyShit();

			var fakeCrochet:Float = (60 / _song.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if (!daNote.mustPress && daNote.noteType != 'player3')
					strumGroup = opponentStrums;

				if (ClientPrefs.middleScroll && !daNote.mustPress)
					daNote.visible = false;

				// i am so fucking sorry for this if condition
				var strumX:Float = 0;
				var strumY:Float = 0;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				if (daNote.mustPress)
				{
					strumX = playerStrums.members[daNote.noteData].x;
					strumY = playerStrums.members[daNote.noteData].y;
				}
				else
				{
					strumX = opponentStrums.members[daNote.noteData].x;
					strumY = opponentStrums.members[daNote.noteData].y;
				}

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;

				var center:Float = strumY + Note.swagWidth / 2;

				if (ClientPrefs.downScroll) // Downscroll
					daNote.distance = (0.45 * (Song.Conductor.songPosition - daNote.strumTime) * _song.speed * daNote.multSpeed);
				else // Upscroll
					daNote.distance = (-0.45 * (Song.Conductor.songPosition - daNote.strumTime) * _song.speed * daNote.multSpeed);

				var angleDir = strumDirection * CoolUtil.pi() / 180;
				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if (daNote.copyX)
				{
					daNote.x = strumX + CoolUtil.cos(angleDir) * daNote.distance;
				}
				if (daNote.copyY)
				{
					if (ClientPrefs.downScroll)
					{
						daNote.y = strumY + CoolUtil.sin(angleDir) * daNote.distance;

						if (daNote.isSustainNote)
						{
							// Jesus fuck this took me so much mother fucking time AAAAAAAAAA
							if (daNote.animation.curAnim.name.endsWith('end'))
							{
								daNote.y += 0.4515 * (fakeCrochet / 4) * _song.speed - daNote.frameHeight * daNote.scale.y;
							}
							daNote.y += (Note.swagWidth / 2) - (60.5 * (_song.speed - 1));
							daNote.y += 27.5 * ((_song.bpm / 100) - 1) * (_song.speed - 1);

							if (daNote.mustPress || daNote.hitByOpponent)
							{
								if (daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
						}
					}
					else
					{
						daNote.y = strumY + CoolUtil.sin(angleDir) * daNote.distance;

						if (daNote.mustPress || daNote.hitByOpponent)
						{
							if (daNote.isSustainNote
								&& daNote.y + daNote.offset.y * daNote.scale.y <= center
								&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					var time:Float = 0.15;
					if (daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end'))
					{
						time += 0.15;
					}

					if (MultiplayerMainMenuState.instance.daNoteReceived.contains(daNote.noteData))
					{
						StrumPlayAnim(true, Std.int(Math.abs(daNote.noteData)) % 4, time);
						daNote.hitByOpponent = true;
						if (!daNote.isSustainNote)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							if (ClientPrefs.downScroll)
							{
								daNote.y = (strumY + 0.45 * (Song.Conductor.songPosition - daNote.strumTime) * _song.speed);
								if (daNote.animation.curAnim.name.endsWith('end'))
								{
									daNote.y += 0.4515 * (fakeCrochet / 4) * _song.speed - daNote.frameHeight * daNote.scale.y;
								}
								daNote.y += (Note.swagWidth / 2) - (60.5 * (_song.speed - 1));
								daNote.y += 27.5 * ((_song.bpm / 100) - 1) * (_song.speed - 1);

								if (daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								daNote.y = (strumY - 0.45 * (Song.Conductor.songPosition - daNote.strumTime) * _song.speed);

								if (daNote.isSustainNote
									&& daNote.y + daNote.offset.y * daNote.scale.y <= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (center - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
						}
						hitNoteBf(oppBf, daNote.noteData);
						MultiplayerMainMenuState.instance.daNoteReceived.remove(daNote.noteData);
					}
					else
					{
						daNote.hitByOpponent = false;
					}
				}

				if (Song.Conductor.songPosition > PlayState.noteKillOffset + daNote.strumTime - 200)
				{
					if (daNote.mustPress && !daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit))
					{
						noteMiss(daNote.noteData);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		else
		{
			notes.forEachAlive(function(daNote:Note)
			{
				daNote.canBeHit = false;
				daNote.wasGoodHit = false;
			});
		}
		if (!startingSong)
		{
			var holdTimerThreshold:Float = Song.Conductor.stepCrochet * (0.0011 /*/ FlxG.sound.music.pitch*/) * oppBf.singDuration;
			if (oppBf.animation.curAnim != null
				&& oppBf.holdTimer > holdTimerThreshold
				&& oppBf.animation.curAnim.name.startsWith('sing')
				&& !oppBf.animation.curAnim.name.endsWith('miss')
				&& !endingSong)
			{
				oppBf.dance();
			}
		}
		switch (currentMode)
		{
			case 0:
				scoreTxt.text = Linguagem.LangUtil.getString("game_your_score", "multiplayer")
					+ ' '
					+ songScore
					+ '\n'
					+ Linguagem.LangUtil.getString("game_opp_score", "multiplayer")
					+ ' '
					+ opponentScore;
			case 1:
				scoreTxt.text = Linguagem.LangUtil.getString("game_your_hits", "multiplayer")
					+ ' '
					+ songHits
					+ '\n'
					+ Linguagem.LangUtil.getString("game_opp_hits", "multiplayer")
					+ ' '
					+ opponentHits;
			case 2:
				scoreTxt.text = Linguagem.LangUtil.getString("game_your_misses", "multiplayer")
					+ ' '
					+ songMisses
					+ '\n'
					+ Linguagem.LangUtil.getString("game_opp_misses", "multiplayer")
					+ ' '
					+ opponentMisses;
		}
		MultiplayerMainMenuState.instance.enviarMissesEHits(songHits, songMisses, songScore);

		if (startingSong)
		{
			if (podeComecar > 1 && !saidGo)
			{
				podeComecar = 0;
				sayGo();
			}
			else if (podeComecar > 1 && saidGo)
			{
				startSong();
			}
		}
		else
		{
			Song.Conductor.songPosition += elapsed * 1000;

			if (podeTerminar > 1 && !endingSong)
			{
				endSong();
			}
			if (podeTerminar > 0)
			{
				terminarTxt.visible = true;
			}

			if (controls.BACK && !queriaTerminar)
			{
				queriaTerminar = true;
				MultiplayerMainMenuState.instance.enviarQueroTerminar();
			}
		}

		terminarTxt.y = ClientPrefs.downScroll ? 20 : FlxG.height - 40;
		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (curBeat % 2 == 0)
		{
			if (myBf.animation.curAnim.name != null && !myBf.animation.curAnim.name.startsWith("sing"))
			{
				myBf.dance();
			}
			if (oppBf.animation.curAnim.name != null && !oppBf.animation.curAnim.name.startsWith("sing"))
			{
				oppBf.dance();
			}
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Song.Conductor.songPosition + 20 || FlxG.sound.music.time < Song.Conductor.songPosition - 20)
		{
			resyncVocals();
		}
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Song.Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Song.Conductor.songPosition;
		vocals.play();
	}

	function keyShit()
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;

		var upP = controls.NOTE_UP_P;
		var rightP = controls.NOTE_RIGHT_P;
		var downP = controls.NOTE_DOWN_P;
		var leftP = controls.NOTE_LEFT_P;

		var upR = controls.NOTE_UP_R;
		var rightR = controls.NOTE_RIGHT_R;
		var downR = controls.NOTE_DOWN_R;
		var leftR = controls.NOTE_LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		var controlReleaseArray:Array<Bool> = [leftR, downR, upR, rightR];
		var controlHoldArray:Array<Bool> = [left, down, up, right];

		if (generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					goodNoteHit(daNote);
				}
			});

			if (controlHoldArray.contains(true) || controlArray.contains(true))
			{
				if (controlArray.contains(true))
				{
					for (i in 0...controlArray.length)
					{
						// heavily based on my own code LOL if it aint broke dont fix it
						var pressNotes:Array<Note> = [];
						var notesDatas:Array<Int> = [];
						var notesStopped:Bool = false;

						var sortedNotesList:Array<Note> = [];
						notes.forEachAlive(function(daNote:Note)
						{
							if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.noteData == i)
							{
								sortedNotesList.push(daNote);
								notesDatas.push(daNote.noteData);
							}
						});
						sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

						if (sortedNotesList.length > 0)
						{
							for (epicNote in sortedNotesList)
							{
								for (doubleNote in pressNotes)
								{
									if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 10)
									{
										doubleNote.kill();
										notes.remove(doubleNote, true);
										doubleNote.destroy();
									}
									else
										notesStopped = true;
								}

								// eee jack detection before was not super good
								if (controlArray[epicNote.noteData] && !notesStopped)
								{
									goodNoteHit(epicNote);
									pressNotes.push(epicNote);
								}
							}
						}
					}
				}
			}
		}

		var holdTimerThreshold:Float = Song.Conductor.stepCrochet * (0.0011 /*/ FlxG.sound.music.pitch*/) * myBf.singDuration;
		if (!controlHoldArray.contains(true)
			&& myBf.animation.curAnim != null
			&& myBf.holdTimer > holdTimerThreshold
			&& myBf.animation.curAnim.name.startsWith('sing')
			&& !myBf.animation.curAnim.name.endsWith('miss')
			&& !endingSong)
		{
			myBf.dance();
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			if (controlReleaseArray[spr.ID])
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
		});
	}

	var combo:Int = 0;

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			MultiplayerMainMenuState.instance.enviarInputGame(note.noteData);

			if (!note.isSustainNote)
			{
				spawnNoteSplashOnNote(note);
				popUpScore(note);
				combo += 1;
				songHits++;
				if (combo > 9999)
					combo = 9999;
			}

			hitNoteBf(myBf, note.noteData);

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.playAnim('confirm', true);
				}
			});

			note.wasGoodHit = true;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function noteMiss(direction:Int = 1, ?ghostMiss:Bool = false):Void
	{
		combo = 0;

		songScore -= 100;
		if (ghostMiss)
			ghostMisses++;
		songMisses++;
	}

	var COMBO_X:Float = 400;
	var COMBO_Y:Float = 340;

	var sicks:Int = 0;
	var shits:Int = 0;
	var bads:Int = 0;
	var goods:Int = 0;
	var accuracy:Float;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Song.Conductor.songPosition + 8);

		var placement:String = Std.string(combo);

		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Song.Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'shit';
			shits++;
			score = 50;
		}
		else if (noteDiff > Song.Conductor.safeZoneOffset * 0.5)
		{
			daRating = 'bad';
			bads++;
			score = 100;
		}
		else if (noteDiff > Song.Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			goods++;
			score = 200;
		}
		else
		{
			daRating = 'sick';
			sicks++;
			score = 350;
		}

		if (daRating == 'sick' && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}
		songScore += score;

		if (combo > 60)
			daRating = 'sick';
		else if (combo > 12)
			daRating = 'good'
		else if (combo > 4)
			daRating = 'bad';

		RecalculateRating();
	}

	private function generateStaticArrows(player:Int, skin:String, ?middle:Bool = false):Void
	{
		for (i in 0...4)
		{
			var babyArrow:StrumNote;
			babyArrow = new StrumNote(middle ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X, strumLine.y, i, player);

			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.texture = "multiplayer/notes/" + skin;
			babyArrow.postAddedToGroup();
		}
	}

	// For Opponent's notes glow
	function StrumPlayAnim(isDad:Bool, id:Int, time:Float)
	{
		var spr:StrumNote = null;
		if (isDad)
		{
			spr = strumLineNotes.members[id];
		}
		else
		{
			spr = playerStrums.members[id];
		}

		if (spr != null)
		{
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	// Note splash shit, duh
	function spawnNoteSplashOnNote(note:Note)
	{
		if (ClientPrefs.noteSplashes && note != null)
		{
			var strum:StrumNote = playerStrums.members[note.noteData];
			if (strum != null)
			{
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null)
	{
		var skin:String = "multiplayer/" + mySkin + "_splashes";

		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	public var ratingString:String;
	public var ratingPercent:Float;

	public function RecalculateRating()
	{
		ratingPercent = songScore / ((songHits + songMisses) * 300);
		if (!Math.isNaN(ratingPercent) && ratingPercent < 0)
			ratingPercent = 0;

		if (Math.isNaN(ratingPercent))
		{
			ratingString = '?';
		}
		else if (ratingPercent >= 1)
		{
			ratingPercent = 1;
			ratingString = Linguagem.LangUtil.getString("play_rating_" + PlayState.ratingStuff[PlayState.ratingStuff.length - 1][0],
				"playstate"); // Uses last string
		}
		else
		{
			for (i in 0...PlayState.ratingStuff.length - 1)
			{
				if (ratingPercent < PlayState.ratingStuff[i][1])
				{
					ratingString = Linguagem.LangUtil.getString("play_rating_" + PlayState.ratingStuff[i][0], "playstate");
					break;
				}
			}
		}
	}

	override function destroy()
	{
		FlxG.sound.music.stop();
		vocals.stop();
		vocals.destroy();
		super.destroy();
	}

	override public function onFocusLost():Void
	{
		super.onFocusLost();
	}

	override public function onFocus():Void
	{
		super.onFocus();
	}
}
