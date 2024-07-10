package;

import PlayState;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Utils.CoolUtil;
import modifiers.ModifiersManager;

using StringTools;

class GameHUD extends FlxTypedGroup<FlxBasic>
{

	public var timeTxt:FlxText;
	public var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;

	public var botplayTxt:FlxText;
	public var botplaySine:Float = 0;

	public var scoreTxtTween:FlxTween;
	public var scoreTxt:FlxText;
    public var judgementCounter:FlxText;
	public var judgementCounterTween:FlxTween;

    public var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
    public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
    public var bfIsLeft:Bool = false;
	public var isGrad = false;

	public function new()
	{
		super();

        timeTxt = new FlxText(PlayState.STRUM_X + (FlxG.width / 2) - 248, 20, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = !ClientPrefs.hideTime;
		if (ClientPrefs.downScroll)
			timeTxt.y = FlxG.height - 45;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = !ClientPrefs.hideTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);
		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), PlayState.instance,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		if (PlayState.SONG.song.toLowerCase() == 'clickbait')
		{
			timeBar.createFilledBar(0x63C9C9C9, 0xFFFF0000);
			timeBar.numDivisions = 2000; // How much lag this causes?? Should i tone it down to idk, 400 or 200?
		}
		else
		{
			timeBar.numDivisions = 400;
			timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		}

		timeBar.alpha = 0;
		timeBar.visible = !ClientPrefs.hideTime;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;


        botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32); //Não acho que botplay mude dependendo da lingua
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = PlayState.cpuControlled;
		if (PlayState.instance.curSong.toLowerCase() != 'cross-console-clash')
		{
			add(botplayTxt);
		}
		if (ClientPrefs.downScroll)
		{
			botplayTxt.y = timeBarBG.y - 78;
		}
        
		judgementCounter = new FlxText(20, 0, 0, "", 20);
		judgementCounter.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounter.borderSize = 2;
		judgementCounter.borderQuality = 2;
		judgementCounter.scrollFactor.set();
		judgementCounter.screenCenter(Y);
		judgementCounter.visible = false; // Temporariamente, ou não... Sei lá
        add(judgementCounter);


		judgementCounter.cameras = [PlayState.instance.camHUD];
		timeBar.cameras = [PlayState.instance.camHUD];
		timeBarBG.cameras = [PlayState.instance.camHUD];
		timeTxt.cameras = [PlayState.instance.camHUD];

        
	}

    public function initHealthBars(){
        healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud && PlayState.instance.canRegen && !ModifiersManager.isEnabledbyName("no_death");
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		healthBarBG.visible = PlayState.instance.canRegen;
		add(healthBarBG);

		if (ClientPrefs.downScroll)
			healthBarBG.y = 0.11 * FlxG.height;

		if (PlayState.SONG.song.toLowerCase() == 'gran-finale')
		{
			trace('dav burro');
			trace("parece mentira");
			healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 21, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8 - 49),
				Std.int(healthBarBG.height - 8 - 32), PlayState.instance, 'healthbarval', 0, 2);
			healthBar.visible = !ClientPrefs.hideHud && !ModifiersManager.isEnabledbyName("no_death");

		}
		else
		{
			healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), PlayState.instance,
				'healthbarval', 0, 2);
			healthBar.scrollFactor.set();
			// healthBar
			healthBar.visible = !ClientPrefs.hideHud && !ModifiersManager.isEnabledbyName("no_death");
			add(healthBar);
			healthBarBG.sprTracker = healthBar;
		}

		iconP1 = new HealthIcon(PlayState.instance.boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.visible = !ClientPrefs.hideHud && PlayState.instance.canRegen && !ModifiersManager.isEnabledbyName("no_death");
		add(iconP1);

		iconP2 = new HealthIcon(PlayState.instance.dad.healthIcon, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.visible = !ClientPrefs.hideHud && PlayState.instance.canRegen && !ModifiersManager.isEnabledbyName("no_death");
		add(iconP2);

		reloadHealthBarColors();
        
		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);

        healthBarBG.cameras = [PlayState.instance.camHUD];
		iconP1.cameras = [PlayState.instance.camHUD];
		iconP2.cameras = [PlayState.instance.camHUD];
		healthBar.cameras = [PlayState.instance.camHUD];
        scoreTxt.cameras = [PlayState.instance.camHUD];

    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(ClientPrefs.hideHud) // não tem pra que atualizar as informações se tiver escondido, não é mesmo?
            return;

		if (PlayState.cpuControlled)
            {
                botplaySine += 180 * elapsed;
                botplayTxt.alpha = 1 - CoolUtil.seno((CoolUtil.pi() * botplaySine) / 180);
            }
        botplayTxt.visible = PlayState.cpuControlled && !PlayState.instance.playingVideoMP4;

            if (PlayState.instance.ratingString == '?')
            {
                if(scoreTxt!=null) scoreTxt.text = Linguagem.LangUtil.getString("play_counter_score", "playstate") + ': ' + PlayState.instance.songScore + ' | '+ Linguagem.LangUtil.getString("play_counter_misses", "playstate") + ': ' + PlayState.instance.songMisses + ' | '+ Linguagem.LangUtil.getString("play_counter_accuracy", "playstate") + ': ' + PlayState.instance.ratingString;
                judgementCounter.text = 'Sicks: 0 \nGoods: 0\nBads: 0\nShits: 0\nErros: 0' + '\n' + ''; // Isso me incomoda muito nos prints que voces mandam...
            }
            else
            {
                judgementCounter.text = Linguagem.LangUtil.getString("play_counter_sicks", "playstate") + ' ' + '${PlayState.sicks}\n'+Linguagem.LangUtil.getString("play_counter_goods", "playstate") + ' ${PlayState.goods}\n'+Linguagem.LangUtil.getString("play_counter_bads", "playstate") + '${PlayState.bads}\n'+Linguagem.LangUtil.getString("play_counter_shits", "playstate") + ' ${PlayState.shits}\n'+Linguagem.LangUtil.getString("play_counter_misses", "playstate") + ' ${PlayState.instance.songMisses}'
                    + '\n'
                    + ''; // Aparentemente eu exagerei kek
                if(scoreTxt!=null) scoreTxt.text = Linguagem.LangUtil.getString("play_counter_score", "playstate") + ': ' + PlayState.instance.songScore + ' | '+Linguagem.LangUtil.getString("play_counter_misses", "playstate")+ ': ' + PlayState.instance.songMisses + ' | '+Linguagem.LangUtil.getString("play_counter_accuracy", "playstate")+ ': ' + PlayState.instance.ratingString + ' (' + Math.floor(PlayState.instance.ratingPercent * 100) + '%)';
            }

            var mult:Float = FlxMath.lerp(1, iconP1.scale.x, Utils.CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
            iconP1.scale.set(mult, mult);
            iconP1.updateHitbox();
    
            var mult:Float = FlxMath.lerp(1, iconP2.scale.x, Utils.CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
            iconP2.scale.set(mult, mult);
            iconP2.updateHitbox();
    
            var iconOffset:Int = 26;
            
    
            if(PlayState.instance.curSong.toLowerCase() != "sink" && PlayState.instance.curSong.toLowerCase() != "phantasm")
            {
                iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
                iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
            }
            else
            {
                iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(0, 0, 100, 100, 0) * 0.01) - iconOffset);
                iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(100, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
            }

    
            if (healthBar.percent < 20)
                iconP1.animation.curAnim.curFrame = 1;
            else
                iconP1.animation.curAnim.curFrame = 0;
    
            if (healthBar.percent > 80)
                iconP2.animation.curAnim.curFrame = 1;
            else if (healthBar.percent < 80)
                iconP2.animation.curAnim.curFrame = 0;
    }

    public function reloadHealthBarColors()
        {
            /*
                O fim e o começo devem possuir a mesma cor para um poder se ligar ao outro.
                sendo assim, o vazio é aquele que fica a esquerda
                e o fill, é aquele que fica a direita.			
                Não tenho tanta certeza de como isso funciona na real Ass:Sílvio
             */
            if (!isGrad)
            {
                if(PlayState.instance.curSong.toLowerCase() == 'phantasm')
                {
                    if (!bfIsLeft)
                        healthBar.createFilledBar(FlxColor.fromRGB(0, 0, 0),
                            FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]));
                    else
                        healthBar.createFilledBar(FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]),
                            FlxColor.fromRGB(0, 0, 0));
                }
                else
                {
                    if (!bfIsLeft)
                        healthBar.createFilledBar(FlxColor.fromRGB(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2]),
                            FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]));
                    else
                        healthBar.createFilledBar(FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]),
                            FlxColor.fromRGB(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2]));
                }
            }
            else
            {
                healthBar.createGradientBar([
                    FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]),
                    FlxColor.fromRGB(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2]),
                    FlxColor.fromRGB(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2])
                ], [
                    FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]),
                    FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]),
                    FlxColor.fromRGB(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2])
                ]);
            }
            healthBar.updateBar();
    
            if (PlayState.instance.curSong.toLowerCase() == 'pasta-night')
            {
                healthBar.createGradientBar([
                    FlxColor.fromRGB(PlayState.instance.gf.healthColorArray[0], PlayState.instance.gf.healthColorArray[1], PlayState.instance.gf.healthColorArray[2]),
                    FlxColor.fromRGB(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2])
                ], [
                    FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2])
                ], 1, 90);
    
                // Ah sim, utilizando esse evento, você poderá modificar a ordem das setas.
                healthBar.updateBar();
            }
        }

	public function hudobj(song_name:String) {
		var HUD:ExtraHUDObject = new ExtraHUDObject(song_name);
		add(HUD);
	}
}