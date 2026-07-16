local valor_pi = 3.14159265359
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

function propriedadescomuns(var)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setProperty(var..".alpha", opacidadeLegendas);
    setLuaSpriteCamera(var, 'camlegenda');
    --setGraphicSize(var, screenWidth) -- k
    screenCenter(var, 'x')
    addLuaSprite(var, true);
end
	
function onUpdate(elapsed)
	songPos = getSongPosition()
	local currentBeat = (songPos/5000)*(curBpm/60)

	doTweenY('opponentmove', 'dad', -400 - 150 * sin((currentBeat+12*12) * valor_pi), 2)
	doTweenX('disruptor2', 'disruptor2.scale', 0 - 50* sin((currentBeat+1*0.1) * valor_pi), 6)
	doTweenY('disruptor2', 'disruptor2.scale', 0 - 31* sin((currentBeat+1*1) * valor_pi), 6)

	if curBeat >= 16 then
        songPos = getSongPosition()
    
        local currentBeat = (songPos/1000)*(bpm/80)
    
        doTweenY(dadTweenY, 'dad', -500-40 * sin((currentBeat*0.25) * valor_pi),0.001)
	end
end

function onEvent(name, value1, value2, value3, value4)
    if name == 'Adicionar Imagens diferenciadasso' then
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
        makeLuaSprite('exe', legendaPath..value1, 0, 0)
        propriedadescomuns('exe')
        addLuaSprite('exe', true);
        --traceLog("value 1 invocou, "..value1.." em: "..getSongPosition())
        end
    end
end