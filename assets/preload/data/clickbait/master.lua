function onCreate()

    addLuaScript('custom_scripts/ytb_player')

    makeLuaSprite('blckfade', 'empty', 0, 0);
	makeGraphic('blckfade', 1, 1, '000000');
    setGraphicSize("blckfade", screenWidth, screenHeight)
    screenCenter("blckfade", "xy")
	setProperty('blckfade.alpha', 1.0)
    setObjectCamera('blckfade', 'other')
	addLuaSprite('blckfade', false);

    makeLuaSprite('fleeplay', 'gameovers/fleeplay', 0, 0);
    setObjectCamera('fleeplay', 'camHUD2')
    scaleObject('fleeplay', 1.0,1.0)
    screenCenter('fleeplay');
    setProperty('fleeplay.alpha', 0)
    addLuaSprite('fleeplay', false);
    setProperty("healthBar.visible", not hideHud)
    setProperty("healthBarBG.visible", not hideHud)
end

function onCreatePost() -- Tirado de Hud.lua pq na real... Um script só pra fazer isso é sacanagem
	setObjectOrder('healthBar', 11)
	setObjectOrder('healthBarBG', 12)
    setObjectOrder('iconP1', 13)
	setObjectOrder('iconP2', 14) --CATORZE UHAUHAHUAHUAHUAHA
end

function onStepHit()
    if curStep == 1 then
        doTweenAlpha('fleeplayAlpha', 'fleeplay', 1, 0.5, 'linear');
    elseif curStep == 656 then
        setProperty('blckfade.alpha', 1)
        doTweenAlpha('fleeplayAlpha', 'fleeplay', 1, 1, 'linear');
    end
end

function onBeatHit()
    if curBeat == 5 then
        setProperty('fleeplay.alpha', 0)
        setProperty('blckfade.alpha', 0)
    elseif curBeat == 169 then
        setProperty('fleeplay.alpha', 0)
        setProperty('blckfade.alpha', 0)
    end
end

function onEvent(name, value1, value2)
	if name == "events-clickbait" then
		doTweenAlpha('fadeOFF', 'blckfade', 1, 1, 'linear');
		doTweenZoom('zoom', 'camGame', 10, 1, 'linear')
    end
end