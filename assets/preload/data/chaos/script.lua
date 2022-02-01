--original pos dad = -900, 100
--modded pos dad = -700, 600
--local allowCountdown = false
function onStartCountdown()
	--if not allowCountdown then
		setProperty('dad.alpha', 0);
		setProperty('dad.x', -700);
		setProperty('dad.y', 600);
		setProperty('camHUD.visible', false);
            	doTweenZoom('zoom', 'camGame', 1, 1, 'sineOut');
		triggerEvent('Camera Follow Pos','-400','350')
		--playSound('sonic', 1, 'sonic');
		--allowCountdown = true;
		--return Function_Stop;
	--end
	--return Function_Continue;
end

--function onSoundFinished(tag)
	--if tag == 'sonic' then
		--startCountdown()
	--end
--end

function onStepHit()
	if curStep == 7 then
		doTweenZoom('zoom', 'camGame', 0.67, 0.5, 'sineOut');
		triggerEvent('Camera Follow Pos','','')
	end
	if curStep == 64 then
		setProperty('camHUD.visible', true) ;
	end
	if curStep == 8 then
		setProperty('dad.alpha', 1);
		doTweenY('dady', 'dad', -300, 0.8, 'sineOut');
            	setProperty('defaultCamZoom',0.67)

	end
	if curStep == 20 then
		doTweenX('dadx', 'dad', -1100, 1.8, 'circInOut');
	        started = true
		--setProperty('opponentDefault.x', -900)
		--setProperty('opponentDefault.y', 100)
	end
function onUpdate(elapsed)
	songPos = getSongPosition()
	local currentBeat = (songPos/5000)*(curBpm/60)
	doTweenY('opponentmove', 'dad', -400 - 150*math.sin((currentBeat+12*12)*math.pi), 2)
	doTweenX('disruptor2', 'disruptor2.scale', 0 - 50*math.sin((currentBeat+1*0.1)*math.pi), 6)
	doTweenY('disruptor2', 'disruptor2.scale', 0 - 31*math.sin((currentBeat+1*1)*math.pi), 6)
	end

	if curStep > 63 then
        songPos = getSongPosition()
    
        local currentBeat = (songPos/1000)*(bpm/80)
    
        doTweenY(dadTweenY, 'dad', -500-40*math.sin((currentBeat*0.25)*math.pi),0.001)
	end
end

function onEvent(name, value1, value2)
    if name == 'Adicionar Imagens' then
        if value1 == '' then
            makeLuaSprite('exe', 'fundosemnada', 0, -350)
            setScrollFactor('exe', 0, 0);
            scaleObject('exe', 1, 1);
            setLuaSpriteCamera('exe', 'other');
            addLuaSprite('exe', true);
        else
			if curStep < 12 then
				if legendas == true then
					imagem = tostring(value1);
					makeLuaSprite('exe', "chaos/"..imagem, 0, 0)
					setScrollFactor('exe', 0, 0);
					setProperty('exe.alpha', 0);
					doTweenAlpha('exe.alpha', 'exe', 1, 0.1, 'linear')
					scaleObject('exe', 1, 1);
					setLuaSpriteCamera('exe', 'other');
					addLuaSprite('exe', true);
				end
			elseif curStep < 63 then
				if legendas == true then
					imagem = tostring(value1);
					makeLuaSprite('exe', "chaos/"..imagem, 0, 0)
					setScrollFactor('exe', 0, 0);
					scaleObject('exe', 1, 1);
					setLuaSpriteCamera('exe', 'other');
					addLuaSprite('exe', true);
				end
			else
				if legendas == true then
					if downscroll == true then
						if legendasporcima == true then
							imagem = tostring(value1);
							makeLuaSprite('exe', "chaos/"..imagem, 0, -350)
							setScrollFactor('exe', 0, 0);
							scaleObject('exe', 1, 1);
							setLuaSpriteCamera('exe', 'camhud');
							addLuaSprite('exe', true);
						else
							imagem = tostring(value1);
							makeLuaSprite('exe', "chaos/"..imagem, 0, -350)
							setScrollFactor('exe', 0, 0);
							scaleObject('exe', 1, 1);
							addLuaSprite('exe', true);
						end
					else
						if legendasporcima == true then
							imagem = tostring(value1);
							makeLuaSprite('exe', "chaos/"..imagem, 0, 0)
							setScrollFactor('exe', 0, 0);
							scaleObject('exe', 1, 1);
							setLuaSpriteCamera('exe', 'camhud');
							addLuaSprite('exe', true);
						else
							imagem = tostring(value1);
							makeLuaSprite('exe', "chaos/"..imagem, 0, 0)
							setScrollFactor('exe', 0, 0);
							scaleObject('exe', 1, 1);
							addLuaSprite('exe', true);
						end
					end
				else
					--nada
				end
			end
        end
    end
end