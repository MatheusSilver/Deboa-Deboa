
local followchars = true
local modchart = true
local sickness = true

local angleshit = 2;
local anglevar = 2;
local newValue = -5
local mult = -5


function onUpdatePost(elapsed)
	mult = lerp(1, getProperty('iconP2.scale.x'), boundTo(1 - (elapsed * 9), 0, 1));
	scaleObject('cyclopIcon', mult, mult)
end

function lerp(a, b, ratio)
	return a + ratio * (b - a)
end

function boundTo(value, min, max)
	newValue = value
	if newValue < min then newValue = min elseif newValue > max then newValue = max end
	return newValue
end


function onUpdate(elapsed)
	setProperty('timeBar.alpha',0)
	setProperty('timeTxt.alpha',0)
	if curStep <= 1 then
		setProperty('dad.specialAnim', true);
		characterPlayAnim('dad', 'alt-idle', true);
	end

	setProperty('cyclopIcon.x', getProperty('healthBar.x') - 150 + getProperty('healthBar.width')*((2-getProperty('health'))/2))

	if getProperty('health') < 0.4 then
		objectPlayAnimation('cyclopIcon', 'perdendo', false);
	else
		objectPlayAnimation('cyclopIcon', 'idle', false);
	end
end

function onCreate()
	local midX = screenWidth/2

	-- nome da animação, prefixo do xml

	makeAnimatedLuaSprite('barrier','sprites/Thingy',0, 0)
	addAnimationByPrefix('barrier','barrier','thingy',24,false)
	setScrollFactor('barrier', 0, 0);
	setProperty('barrier.alpha',0)
	setObjectCamera('barrier','camHUD')
	setProperty("barrier.x", midX - getProperty("barrier.width")/2)
	if(downscroll)then
		setProperty("barrier.y", screenHeight*0.11 - getProperty("barrier.height")/2 )
	else
		setProperty("barrier.y", screenHeight*0.89 - getProperty("barrier.height")/2)
	end
end

function onStartCountdown()
	addLuaSprite('barrier', true)
	setProperty('gf.alpha', 0)
	setProperty('dad.alpha', 1)
	setProperty('boyfriend.alpha', 0)
	setProperty("dad.stunned",true)
	--setProperty('scoreTxt.alpha', 0)
	return Function_Continue
end

function onCreatePost()
	makeAnimatedLuaSprite('cyclopIcon', 'icon_cyclops', getProperty('healthBar.x')-150 + getProperty('healthBar.width')*getProperty('health')/2 ,getProperty('healthBarBG.y')-75)
	addAnimationByPrefix('cyclopIcon', 'perdendo', 'losing', 24, true)
	addAnimationByPrefix('cyclopIcon', 'idle', 'natural', 24, true)
	setObjectCamera('cyclopIcon', 'camHUD')
	setObjectOrder('cyclopIcon', getObjectOrder('healthBarBG') + 1)
	setProperty('iconP2.visible', false)
	addLuaSprite('cyclopIcon', true)
end

function onCountdownStarted()
	setPropertyFromClass('Song.Conductor', 'songPosition', 0);
end

function onPause()
--	return Function_Stop; --disabled for testing
end

function onGameOver()
	modchart = false
--	return Function_Continue;
end


function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') > 0.09 then
        setProperty('health', health- 0.04);
    end
end

function goodNoteHit()
    health = getProperty('health')
    setProperty('health', health+ 0.014);
	if(getProperty('health') > 1)then
		setProperty('health', 1);
		--barrier.alpha = 1;
		setProperty('barrier.alpha',1)
		doTweenAlpha("barrierAlpha","barrier","0","1","quadInOut");
		objectPlayAnimation('barrier', 'barrier', true);
	end
end

function onStepHit()
	if curStep <= 125 then
		setProperty('dad.specialAnim', true);
		characterPlayAnim('dad', 'alt-idle', true);
		noteTweenX('B2', 4, 740, 0.25, "quintOut")
		noteTweenX('A2', 5, 850, 0.25, "quintOut")
		noteTweenX('C2', 6, 960, 0.25, "quintOut")
		noteTweenX('D2', 7, 1070, 0.25, "quintOut")
	end
	if curStep == 126 then
		setProperty("dad.stunned",false)
		setProperty('dad.specialAnim', true);
		characterPlayAnim('dad', 'turn', true);
	end
end

function onBeatHit()
	scaleObject('cyclopIcon', 1.2, 1.2)
	if curBeat == 433 then
		cameraFade('camGame', '000000', '1')
	end
	if curBeat <= 1 then
		doTweenZoom('ZoomIn', 'camGame', '1.15', '13.2', 'linear')
		doTweenZoom('ZoomInHud', 'camHUD', '4', '0.2', 'linear')
	end
	if curBeat == 32 then
		doTweenZoom('ZoomIn', 'camGame', '0.92', '0.1', 'linear')
	end
	if curBeat == 31 then
		setProperty('camHUD.alpha',1)
		doTweenZoom('ZoomInHud', 'camHUD', '1', '0.5', 'linear')
	end
	if sickness then
		if mustHitSection == false then
			if curBeat > 48 then
				if curBeat < 432 then
					if curBeat % 2 == 0 then
						angleshit = anglevar;
					else
						angleshit = -anglevar;
					end
					setProperty('camHUD.angle',angleshit*3)
					setProperty('camGame.angle',angleshit*3)
					doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
					doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
					doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
					doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
				end
			end
		else
			setProperty('camHUD.angle',0)
			setProperty('camGame.angle',0)
		end
	end
end