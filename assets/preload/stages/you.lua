goIdle = true
local flashed = true

function onCreate()
	flashed = false
	makeAnimationList();

    makeAnimatedLuaSprite('tail', 'XNEW', 5100 - 800, 915 + 40); -- tails
	addAnimationByPrefix('tail', 'idle', 'lordxidle', 24, true)
	addOffset('tail', 'idle', 0, 0)
	addAnimationByPrefix('tail', 'singLEFT', 'XLeft', 24, false) -- no meio é o nome do movimento in code e a direita é o nome da anim no xml
	addOffset('tail', 'singLEFT', 9, -70)
	addAnimationByPrefix('tail', 'singDOWN', 'xidle', 24, false)
	addOffset('tail', 'singDOWN', -49, -146)
	addAnimationByPrefix('tail', 'singUP', 'xup', 24, false)
	addOffset('tail', 'singUP', 24, 109)
	addAnimationByPrefix('tail', 'singRIGHT', 'xright', 24, false)
	addOffset('tail', 'singRIGHT', -77, -13)
	setScrollFactor('tail', 1, 1);

    -- Mesmo code da CCC sodasse

    makeLuaSprite('run', 'run',3689, 673);
 
	addLuaSprite('run', false);
    setProperty('run.visible', true);
    addLuaSprite('tail', false);
    setProperty('tail.visible', true);

	makeLuaTiledSprite('neve','neve',2560,1440,true,true) --1
	--setObjectCamera("neve", "hud2")
	setPropertyTiledLuaSprite("neve.x", 3800)
	setPropertyTiledLuaSprite("neve.y", 750)
	setPropertyTiledLuaSprite("neve.alpha", 0.5)
	setPropertyTiledLuaSprite("neve.visible", false)
	addLuaSprite("neve")

	makeLuaSprite("gelo_overlay", "freeze_overlay", 0, 0)
	setObjectCamera("gelo_overlay", 'hud')
	screenCenter("gelo_overlay", "xy")
	setGraphicSize("gelo_overlay", screenWidth, screenHeight)
	setProperty("gelo_overlay.alpha", 0)
	addLuaSprite("gelo_overlay")

	makeLuaSprite('whiteflash', 'empty', 0, 0)
	makeGraphic('whiteflash', 1, 1, 'FFFFFF')
	setGraphicSize("whiteflash", screenWidth, screenHeight)
	setObjectCamera("whiteflash", 'hud2')
	setProperty('whiteflash.alpha', 0)
	setProperty("whiteflash.visible", false)
	addLuaSprite("whiteflash")

	--setGameover('sonic', 'gameOverEndSonic', 'breakfast')

	setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
end

function onCreatePost()
	playAnim('tail', 'idle', false);
end

--tails shit
--script by Shadow Mario, Kevin Kuntz and other dudos
animationsList = {}
holdTimers = {tail = -1.0};
noteDatas = {tail = 0};
function makeAnimationList()
	animationsList[0] = 'singLEFT';
	animationsList[1] = 'singDOWN';
	animationsList[2] = 'singUP';
	animationsList[3] = 'singRIGHT';
end

function resetAnim()
	playAnim('tail', 'idle', true);
	goIdle = true
end

function onTimerCompleted(tag)
	if tag == "resetAnim" then
		resetAnim()
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Special Sing' then
		if not isSustainNote then
			noteDatas.tail = direction;
		end	
		cancelTimer("resetAnim")
		goIdle = false

		runTimer("resetAnim", 0.7)
		characterToPlay = 'tail'
		animToPlay = noteDatas.tail;
		
		playAnimation(characterToPlay, animToPlay, true);
	end
end


function onEvent(name, value1, value2)
	if name == 'whiteflash' then --Isso só é usado aqui, então resolvi acoplar esse evento ao aparecimento da neve.
		setProperty("whiteflash.visible", true)
		setProperty('whiteflash.alpha', 1)
		doTweenAlpha('whiteflashbye', 'whiteflash', 0, 1, 'linear')
		setPropertyTiledLuaSprite("neve.visible", true)
		doTweenAlpha("gelo_overlay_tween", "gelo_overlay", 0.2, 3, "linear")
		doTweenX("neve_tweenX_direita", "neve", 3800+100, 3, "sineinout")
		flashed = true
	end
end

local speedchanger = 0
function onUpdate()
	speedchanger = speedchanger+1
	if flashed then
		setPropertyTiledLuaSprite('neve.scrollY', speedchanger*3)
	end
end

function onTweenCompleted(tag)
	if tag == 'whiteflashbye' then
		removeLuaSprite("whiteflash")
	end
	if tag == "neve_tweenX_direita" then
		doTweenX("neve_tweenX_esquerda", "neve", 3800 -100, 3, "sineinout")
	elseif tag == "neve_tweenX_esquerda" then
		doTweenX("neve_tweenX_direita", "neve", 3800 + 100, 3, "sineinout")
	end
end

function playAnimation(character, animId, forced)
	animName = animationsList[animId];
	if character == 'tail' then
		playAnim('tail', animName, forced); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
	end
end
--tails shit ends