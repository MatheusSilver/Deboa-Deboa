package multiplayer;


import FunkinLua;
import Section.SwagSection;
import Song.SwagSong;
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
import networking.Network;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import networking.sessions.Session;
import networking.sessions.client.Client;
import networking.sessions.items.ClientObject;
import networking.sessions.items.ServerObject;
import networking.sessions.server.Server;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxSort;
import lime.utils.Assets;

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
	var terminarBar:FlxBar;
	var terminarTxt:FlxText;
	var terminarFloat:Float=0;

	public static var instance:MultiplayerPlayState;

	var blackStuff:FlxSprite;
	var waitingForOthers:FlxText;

	var currentMode:Int = 0;


	public function new(startPos:Float, whichSong:String, isHost:Bool, trocarLados:Bool, modo:Int) {
		instance = this;
		currentMode = modo;
		this.startPos = startPos;
		Conductor.songPosition = startPos - startOffset;
        if(!trocarLados)
			{isPlayer1 = !isHost;}
		else
			{isPlayer1 = isHost;};
        _song = Song.loadFromJson(whichSong);
		_song.arrowSkin = "NOTE_assets";
		_song.splashSkin = "noteSplashes";
		PlayState.SONG = _song;
		startOffset = Conductor.crochet;
		timerToStart = startOffset;
		super();
	}

	var scoreTxt:FlxText;
	//var opponentScoreTxt:FlxText;

	public var opponentHits:Int = 0;
	public var opponentMisses:Int = 0;
	public var opponentScore:Int = 0;
	
	var timerToStart:Float = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		add(bg);
		
		strumLine = new FlxSprite(PlayState.STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();
		
		comboGroup = new FlxTypedGroup<FlxSprite>();
		add(comboGroup);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);


		generateStaticArrows(0);
		generateStaticArrows(1);

		if(!isPlayer1)
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
		
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;
		
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

		scoreTxt = new FlxText(0, ClientPrefs.downScroll ? 25 : FlxG.height - 65, FlxG.width, "", 50);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);

		Main.mouse_allowed = false;

		//sayGo();
		blackStuff = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackStuff.screenCenter(XY);
		blackStuff.alpha = 0.5;
		add(blackStuff);
		waitingForOthers = new FlxText(0, 0, FlxG.width, LangUtil.getString("game_loading_txt", "multiplayer"), 30);
		waitingForOthers.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		waitingForOthers.screenCenter(XY);
		add(waitingForOthers);

		terminarBar = new FlxBar(20, ClientPrefs.downScroll  ? 20 : FlxG.height - 40, LEFT_TO_RIGHT, 374, 20, this, "terminarFloat", 0, 100, true);
		terminarBar.numDivisions = 100;
		terminarBar.createFilledBar(0xFF000000, 0xFFFFFFFF, true);
		terminarBar.visible=false;
		add(terminarBar);
		terminarBar.updateFilledBar();
		terminarBar.updateBar();
		terminarTxt = new FlxText(20, ClientPrefs.downScroll  ? 40 : FlxG.height - 80, FlxG.width, LangUtil.getString("game_stop_text", "multiplayer"), 17);
		terminarTxt.color = FlxColor.BLACK;
		terminarTxt.visible = false;
		add(terminarTxt);

		super.create();
	}

	function sayGo() {
		var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go'));
		go.scrollFactor.set();

		go.updateHitbox();

		go.screenCenter();
		go.antialiasing = ClientPrefs.globalAntialiasing;
		add(go);
		FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				go.destroy();
			}
		});
		FlxG.sound.play(Paths.sound('introGo'), 0.6);
	}

	var songScore:Int = 0;
	var songHits:Int = 0;
	var songMisses:Int = 0;
	var ghostMisses:Int = 0;
	var startingSong:Bool = true;
	private function generateSong(dataPath:String):Void
	{
		FlxG.sound.playMusic(Paths.inst(_song.song), 0, false);
		FlxG.sound.music.pause();
		FlxG.sound.music.onComplete = endSong;
		vocals.pause();
		vocals.volume = 0;

		var songData = _song;
		Conductor.changeBPM(songData.bpm);
		
		notes = new FlxTypedGroup<Note>();
		add(notes);
		
		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

        if(!isPlayer1)
        {
			var count:Int = 4;
            for (s in 0...noteData.length)
            {
                for (i in 0...noteData[s].sectionNotes.length)
                    {
                        var note:Array<Dynamic> = noteData[s].sectionNotes[i];
                            if(note[1]>-1){
                            note[1] = (note[1] + count) % (count*2);
                            noteData[s].sectionNotes[i] = note;
                        }
                    }
            }

        }

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				if(songNotes[1] > -1) { //Real notes
					var daStrumTime:Float = songNotes[0];
					if(daStrumTime >= startPos) {
						var daNoteData:Int = Std.int(songNotes[1] % 4);

						var gottaHitNote:Bool = section.mustHitSection;

						if (songNotes[1] > 3)
						{
							gottaHitNote = !section.mustHitSection;
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
						if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
						swagNote.scrollFactor.set();

						var susLength:Float = swagNote.sustainLength;

						susLength = susLength / Conductor.stepCrochet;
						unspawnNotes.push(swagNote);

						var floorSus:Int = Math.floor(susLength);
						if(floorSus > 0) {
							for (susNote in 0...floorSus+1)
							{
								oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

								var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(_song.speed, 2)), daNoteData, oldNote, true);
								sustainNote.mustPress = gottaHitNote;
								sustainNote.noteType = swagNote.noteType;
								sustainNote.scrollFactor.set();
								unspawnNotes.push(sustainNote);

								if (sustainNote.mustPress)
								{
									sustainNote.x += FlxG.width / 2; // general offset
								}
								else
								{
									sustainNote.x += FlxG.width / 1.5;
								}
							}
						}

						if (swagNote.mustPress)
						{
							swagNote.x += FlxG.width / 2; // general offset
						}
						else {
							swagNote.x += FlxG.width / 1.5;
						}
						
						if(!noteTypeMap.exists(swagNote.noteType)) {
							noteTypeMap.set(swagNote.noteType, true);
						}
					}
				}
			}
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);
		generatedMusic = true;

		new FlxTimer().start(2, function(tmr:FlxTimer) {
			MultiplayerMainMenuState.instance.enviarToPronto();
		});

	}


	function startSong():Void
	{
		waitingForOthers.destroy();
		blackStuff.destroy();
		startingSong = false;
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
		//results aqui, fazer que os dois tenham que confirmar pra continuar aí eles voltam pro menu
		MultiplayerMainMenuState.instance.endMatch();
		super.close();
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	var endingSong:Bool = false;
	public function endSong() {
		endingSong = true;
		if(FlxG.sound.music!= null)
		{
			FlxG.sound.music.stop();		
			vocals.stop();
			vocals.destroy();
		}

		//MultiplayerMainMenuState.instance.send_results([sicks, goods, bads, shits], combo, songScore, GJClient.userName);
		if(podeTerminar > 1)
		{
			close();
		}
		else
		{
			mostrarResults();
		}
        trace("cabou !");
	}

	function mostrarResults()
	{
		if(FlxG.sound.music != null)
		{
			FlxG.sound.music.volume = 0;	
		}

		// vou fazer ele mostrar uns results improvisados e dps eu adiciono aquele resultstate do silvo
		var blackGround:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackGround.screenCenter(XY);
		blackGround.alpha = 0.5;
		add(blackGround);
		var textoAviso:FlxText;
		textoAviso = new FlxText(0, 0, FlxG.width, "", 60);
		textoAviso.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textoAviso.screenCenter(XY);

		switch(euGanhei())
		{
			case 0:
				textoAviso.text = LangUtil.getString("results_tie_text", "multiplayer");
			case 1:
				textoAviso.text = LangUtil.getString("results_win_text", "multiplayer");
			case 2:
				textoAviso.text = LangUtil.getString("results_lose_text", "multiplayer");
		}

		add(textoAviso);
		new FlxTimer().start(5, function(tmr:FlxTimer) {
			close();
		});
	}

	function euGanhei():Int
	{
		// 0 = empate, 1 = ganhou, -1 = perdeu
		var sera:Int = 0;
		switch(currentMode)
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

	/*var imRemoving:Bool = false;
	function removeNote()
	{
		if(MultiplayerMainMenuState.instance.daNoteReceived.length>0 && !imRemoving)
			{
				imRemoving = true;
				new FlxTimer().start(0.75, function(tmr:FlxTimer) {
					if(MultiplayerMainMenuState.instance.daNoteReceived.length>0)
					{
						MultiplayerMainMenuState.instance.daNoteReceived.remove(MultiplayerMainMenuState.instance.daNoteReceived[0]);
					}
					imRemoving = false;
				});
			}
	}*/

	override function update(elapsed:Float) {
		//removeNote();
		if (startingSong) {
			/*timerToStart -= elapsed * 1000;
			Conductor.songPosition = startPos - timerToStart;*/
			if(podeComecar > 1) {
				startSong();
			}
		} else {
			Conductor.songPosition += elapsed * 1000;
			if(podeTerminar > 1 && !endingSong)
			{
				endSong();
			}
			if(podeTerminar > 0)
			{
				terminarTxt.visible = true;
			}
			if(FlxG.keys.pressed.ESCAPE && !queriaTerminar)
			{
				if(terminarFloat>=100)
				{
					MultiplayerMainMenuState.instance.enviarQueroTerminar();
					queriaTerminar = true;
				}
				else
				{
					terminarFloat+=3;
				}
			}
			else if(!FlxG.keys.pressed.ESCAPE && !queriaTerminar && terminarFloat != 0.0)
			{
				terminarFloat-=3;
			}
			terminarBar.visible = terminarFloat>0.0 && !queriaTerminar;
			terminarTxt.y = ClientPrefs.downScroll  ? terminarBar.visible ? 40 : 20 : terminarBar.visible ? FlxG.height - 80 : FlxG.height - 40 ;
		}

		var roundedSpeed:Float = FlxMath.roundDecimal(_song.speed, 2);
		if (unspawnNotes[0] != null)
		{
			var time:Float = 1500;
			if(roundedSpeed < 1) time /= roundedSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		
		if (generatedMusic)
		{
			var fakeCrochet:Float = (60 / _song.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				if(!daNote.mustPress && ClientPrefs.middleScroll)
				{
					daNote.active = true;
					daNote.visible = false;
				}
				else if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				// i am so fucking sorry for this if condition
				var strumX:Float = 0;
				var strumY:Float = 0;
				if(daNote.mustPress) {
					strumX = playerStrums.members[daNote.noteData].x;
					strumY = playerStrums.members[daNote.noteData].y;
				} else {
					strumX = opponentStrums.members[daNote.noteData].x;
					strumY = opponentStrums.members[daNote.noteData].y;
				}

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				var center:Float = strumY + Note.swagWidth / 2;

				if(daNote.copyX) {
					daNote.x = strumX;
				}
				if(daNote.copyY) {
					if (ClientPrefs.downScroll) {
						daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);
						if (daNote.isSustainNote) {
							//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
							if (daNote.animation.curAnim.name.endsWith('end')) {
								daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
								daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;
								if(PlayState.isPixelStage) {
									daNote.y += 8;
								} else {
									daNote.y -= 19;
								}
							} 
							daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
							daNote.y += 27.5 * ((_song.bpm / 100) - 1) * (roundedSpeed - 1);

							if(daNote.mustPress || daNote.hitByOpponent)
							{
								if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
						}
					} else {
						daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

						if(daNote.mustPress || daNote.hitByOpponent)
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
					if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
					}
					
					if(MultiplayerMainMenuState.instance.daNoteReceived.contains(daNote.noteData))
						{
							MultiplayerMainMenuState.instance.daNoteReceived.remove(daNote.noteData);
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
								if (ClientPrefs.downScroll) {
									daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);
									if (daNote.animation.curAnim.name.endsWith('end')) {
										daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
										daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;
										if(PlayState.isPixelStage) {
											daNote.y += 8;
										} else {
											daNote.y -= 19;
										}
									} 
									daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
									daNote.y += 27.5 * ((_song.bpm / 100) - 1) * (roundedSpeed - 1);

									if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
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
									daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);
										
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
					else
					{
						daNote.hitByOpponent = false;
					}



				}

				var doKill:Bool = daNote.y < -daNote.height;
				if(ClientPrefs.downScroll) doKill = daNote.y > FlxG.height;

				if (doKill)
				{
						if (daNote.tooLate || !daNote.wasGoodHit)
						{
							//Dupe note remove
							notes.forEachAlive(function(note:Note) {
								if (daNote != note && !daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 10) {
									note.kill();
									notes.remove(note, true);
									note.destroy();
								}
							});

							if(!daNote.ignoreNote && daNote.mustPress) {
								songMisses++;
							}
						}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		keyShit();
		switch(currentMode)
		{
			case 0:
				scoreTxt.text = LangUtil.getString("game_your_score", "multiplayer") +' '+songScore +  '\n' + LangUtil.getString("game_opp_score", "multiplayer") +' '+opponentScore;
			case 1:
				scoreTxt.text = LangUtil.getString("game_your_hits", "multiplayer") +' '+songHits + '\n' + LangUtil.getString("game_opp_hits", "multiplayer") +' '+opponentHits;
			case 2:
				scoreTxt.text = LangUtil.getString("game_your_misses", "multiplayer") +' '+songMisses + '\n' + LangUtil.getString("game_opp_misses", "multiplayer") +' '+songMisses;
		}
		MultiplayerMainMenuState.instance.enviarMissesEHits(songHits, songMisses, songScore);
		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	function keyShit() {
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

		// FlxG.watch.addQuick('asdfa', upP);
		if (generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					goodNoteHit(daNote);
				}
			});

			if (controlHoldArray.contains(true) || controlArray.contains(true)) {
				var canMiss:Bool = !ClientPrefs.ghostTapping;
				if (controlArray.contains(true)) {
					for (i in 0...controlArray.length) {
						// heavily based on my own code LOL if it aint broke dont fix it
						var pressNotes:Array<Note> = [];
						var notesDatas:Array<Int> = [];
						var notesStopped:Bool = false;

						var sortedNotesList:Array<Note> = [];
						notes.forEachAlive(function(daNote:Note)
						{
							if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate 
							&& !daNote.wasGoodHit && daNote.noteData == i) {
								sortedNotesList.push(daNote);
								notesDatas.push(daNote.noteData);
								canMiss = true;
							}
						});
						sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

						if (sortedNotesList.length > 0) {
							for (epicNote in sortedNotesList)
							{
								for (doubleNote in pressNotes) {
									if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 10) {
										doubleNote.kill();
										notes.remove(doubleNote, true);
										doubleNote.destroy();
									} else
										notesStopped = true;
								}
									
								// eee jack detection before was not super good
								if (controlArray[epicNote.noteData] && !notesStopped) {
									goodNoteHit(epicNote);
									pressNotes.push(epicNote);
								}

							}
						}
						else if (canMiss && controlArray[i]) 
							noteMiss(i, true);
					}
				}
			}
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if(controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm') {
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			if(controlReleaseArray[spr.ID]) {
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
			switch(note.noteType) {
				case 'Hurt Note': //Hurt note
					noteMiss(note.noteData);
					--songMisses;
					if(!note.isSustainNote) {
						if(!note.noteSplashDisabled) {
							spawnNoteSplashOnNote(note);
						}
					}

					note.wasGoodHit = true;

					if (!note.isSustainNote)
					{
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
					return;
			}

			if (!note.isSustainNote)
			{
				spawnNoteSplashOnNote(note);
				popUpScore(note);
				combo += 1;
				songHits++;
				if(combo > 9999) combo = 9999;
			}
			
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

		songScore -= 10;
		if(ghostMiss) ghostMisses++;
		songMisses++;

	}

	var COMBO_X:Float = 400;
	var COMBO_Y:Float = 340;

	var sicks:Int = 0;
	var shits:Int = 0;
	var bads:Int = 0;
	var goods:Int = 0;
	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + 8); 

		var placement:String = Std.string(combo);

		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'shit';
			shits++;
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.5)
		{
			daRating = 'bad';
			bads++;
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
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

		if(daRating == 'sick' && !note.noteSplashDisabled)
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
	}


	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{

			var skin:String = "NOTE_assets";
			// FlxG.log.add(i);
            var babyArrow:StrumNote;
			babyArrow = new StrumNote(ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X, strumLine.y, i, player);

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
			babyArrow.postAddedToGroup();
		}
	}


	// For Opponent's notes glow
	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}


	// Note splash shit, duh
	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(_song.splashSkin != null && _song.splashSkin.length > 0) skin = _song.splashSkin;
		
		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if(note != null) {
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}
	
	override function destroy() {
		FlxG.sound.music.stop();
		vocals.stop();
		vocals.destroy();
		super.destroy();
	}
}