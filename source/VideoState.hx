package; // Furtado de um lugar secreto shhhhhhhhhhhhhhhhhhhhh

#if mobile
import extension.webview.WebView;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;

using StringTools;

class VideoState extends MusicBeatState
{
	var changecount = 0;

	public static var androidPath:String = 'file:///android_asset/';

	public var nextState:FlxState;

	var text:FlxText;

	public function new(source:String, toTrans:FlxState)
	{
		super();

		text = new FlxText(0, 0, 0, "Toque para continuar", 48);
		text.screenCenter();
		text.alpha = 0;
		add(text);

		nextState = toTrans;

		// FlxG.autoPause = false;
		source = source.replace('.${Paths.VIDEO_EXT}', '');

		WebView.onClose = onClose;
		WebView.onURLChanging = onURLChanging;

		WebView.open(androidPath + source + '.html', false, null, ['http://exitme(.*)']);
	}

	public override function update(dt:Float)
	{
		if (Utils.BSLTouchUtils.justTouched() || FlxG.android.justReleased.BACK)
			onClose();

		super.update(dt);
	}

	function onClose()
	{ // not working
		text.alpha = 0;
		changecount = 0;
		// FlxG.autoPause = true;
		trace('close!');
		trace(nextState);
		MusicBeatState.switchState(nextState);
	}

	function onURLChanging(url:String)
	{
		if (changecount == 2)
		{ // Hacks mais sujos que o anterior k
			text.alpha = 0;
			onClose();
		}
		else
		{
			changecount++;
			text.alpha = 1;
		}
		if (url == 'http://exitme%28.%2A%29/')
			onClose(); // drity hack lol
		trace("WebView is about to open: " + url);
	}
}
#end
/*
Tirap-tchoron, tirap-tchoron
Oh-ah, oh-ah
Tirap-tchoron, tirap-tchoron
Oh-ah
Na madrugada, abandonada
E não atende o celular
Tirando onda, cheio de marra
Achando que eu vou perdoar
Pra mim, já chega, eu tô bolada
Agora quem não quer, sou eu
Não te dou bola, senta e chora
Porque você já me perdeu
Deu mole pra caramba, tremendo vacilão
Tá todo arrependido, vai comer na minha mão
Pensou que era o cara, mas não é bem assim
Agora baba, bobo, vai correr atrás de mim
Deu mole pra caramba, tremendo vacilão
Tá todo arrependido, vai comer na minha mão
Pensou que era o cara, mas não é bem assim
Agora baba, bobo, vai correr atrás de mim
Tirap-tchoron, tirap-tchoron
Oh-ah, oh-ah
Tirap-tchoron, tirap-tchoron
Oh-ah
Na madrugada, abandonada
E não atende o celular
Tirando onda, cheio de marra
Achando que eu vou perdoar
Pra mim, já chega, eu tô bolada
Agora quem não quer, sou eu
Não te dou bola, senta e chora
Porque você já me perdeu
Deu mole pra caramba, tremendo vacilão
Tá todo arrependido, vai comer na minha mão
Pensou que era o cara, mas não é bem assim
Agora baba, bobo...
Oh-oh
Deu mole pra caramba, tremendo vacilão
Tá todo arrependido, vai comer na minha mão
Pensou que era o cara, mas não é bem assim
Agora baba, bobo, vai correr atrás de mim
Tirap-tchoron, tirap-tchoron
Oh-ah, oh-ah
Tirap-tchoron, tirap-tchoron
Oh-ah
Tirap-tchoron, tirap-tchoron
Oh-ah, oh-ah
Tirap-tchoron, tirap-tchoron
Oh-ah
Oh-ah
Oh-ah
Oh-ah, oh-ah
Oh-ah
*/