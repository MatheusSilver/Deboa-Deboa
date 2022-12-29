
local followchars = true
local modchart = true
local sickness = true

local xx = 1060
local yy = 760
local ofs = 50
local ofs2 = 0
local del = 0
local del2 = 0

local angleshit = 2;
local anglevar = 2;

function onUpdate(elapsed)
	setProperty('timeBar.alpha',0)
	setProperty('timeTxt.alpha',0)
	if followchars == true then
		if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
		triggerEvent('Camera Follow Pos',xx-ofs,yy)
		end
		if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
		triggerEvent('Camera Follow Pos',xx+ofs,yy)
		end
		if getProperty('dad.animation.curAnim.name') == 'singUP' then
		triggerEvent('Camera Follow Pos',xx,yy-ofs)
		end
		if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
		triggerEvent('Camera Follow Pos',xx,yy+ofs)
		end
		if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
		triggerEvent('Camera Follow Pos',xx-ofs,yy)
		end
		if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
		triggerEvent('Camera Follow Pos',xx+ofs,yy)
		end
		if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
		triggerEvent('Camera Follow Pos',xx,yy-ofs)
		end
		if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
		triggerEvent('Camera Follow Pos',xx,yy+ofs)
		end
		if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
		triggerEvent('Camera Follow Pos',xx,yy)
		end
		if getProperty('dad.animation.curAnim.name') == 'idle' then
		triggerEvent('Camera Follow Pos',xx,yy)
		end
		if curStep <= 1 then
			setProperty('dad.specialAnim', true);
			characterPlayAnim('dad', 'alt-idle', true);
		end
		if modchart == true then
			for i = 0,3 do
				setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
			end
		end
	else
		triggerEvent('Camera Follow Pos','','')
	end
end

function onCreate()
	local midX = screenWidth/2
	makeAnimatedLuaSprite('barrier','sprites/Thingy',0, 0)
	addAnimationByPrefix('barrier','barrier','thingy',24,false)
	setScrollFactor('barrier', 0, 0);
	setProperty('barrier.alpha',0)
	setObjectCamera('barrier','hud')
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

function onCountdownStarted()
	setPropertyFromClass('Conductor', 'songPosition', 0);
end

function onPause()
	return Function_Stop; --disabled for testing
end

function onGameOver()
	modchart = false
	return Function_Continue;
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
    if mustHitSection == false then
        if curStep > 192 then
            if curStep < 1728 then
                if curStep % 8 == 0 then
                    angleshit = anglevar;
                else
                    angleshit = -anglevar;
                end
                setProperty('hud.angle',angleshit*3)
                setProperty('game.angle',angleshit*3)
                doTweenAngle('turn', 'hud', angleshit, stepCrochet*0.002, 'circOut')
                doTweenX('tuin', 'hud', -angleshit*8, crochet*0.001, 'linear')
                doTweenAngle('tt', 'game', angleshit, stepCrochet*0.002, 'circOut')
                doTweenX('ttrn', 'game', -angleshit*8, crochet*0.001, 'linear')
            end
        end
    else
        setProperty('hud.angle',0)
        setProperty('game.angle',0)
    end
end