package;

class ProgressionUtil 
{
	public static function terminouHistoria():Bool {
		WeekData.reloadWeekFiles(true);

		var historiaMusicas:Int = 0;
		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			historiaMusicas += leWeek.songs.length;
		}

		//trace("Total de musicas: "+ historiaMusicas + "\n" + "Progresso: " + getSaveSum());
		return getSaveSum() == historiaMusicas+1;
	}

	public static function terminouFreeplay():Bool {
		WeekData.reloadWeekFiles(true);

		var freeplayMusicas:Int = 0;
		for (i in 0...WeekData.freeplayList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.freeplayList[i]);
			freeplayMusicas += leWeek.songs.length;
		}

		//trace("Total de musicas freeplay: "+ freeplayMusicas + "\n" + "Progresso freeplay: " + FreeplayState.progressFreeplay);
		return Std.parseInt(Std.string(flixel.FlxG.save.data.freeplayProgress)) == freeplayMusicas+1;
	}

	public static function terminouTudo():Bool {
		return terminouFreeplay() && terminouHistoria();
	}

	public static function musicasLiberadas():Bool {
		return #if UNLOCK_SONGS_ALLOWED ClientPrefs.musicasDesbloqueadas == true #else false #end;
	}

	public static function todasMusicasAbertas():Bool {
		if (!terminouHistoria())
			return false;
		var freeplayMusicas:Int = 0;
		for (i in 0...WeekData.freeplayList.length)
			freeplayMusicas += WeekData.weeksLoaded.get(WeekData.freeplayList[i]).songs.length;
		var progresso:Null<Int> = Std.parseInt(Std.string(flixel.FlxG.save.data.freeplayProgress));
		return progresso != null && progresso >= freeplayMusicas;
	}

	public static function getSaveSum():Int {
		var sum:Int = 0;
		for (i in 0...MenuPreHistoria.curSave.length) {
			sum += Std.parseInt(MenuPreHistoria.curSave.split(",")[i]);
		}
		return sum;
	}
}