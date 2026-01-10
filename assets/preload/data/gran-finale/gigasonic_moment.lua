-- Ato do Exe segurando o bf full maneirasso e pistolasso oh yeah man

local angle = 2;

-- Parte desse código foi reaproveitado da Control
-- Poderia até fazer disso uma função a parte, mas talvez isso não vá ser usado em nenhum outro lugar.

function opponentNoteHit()
	triggerEvent('Screen Shake', '0.015, 0.015', '0, 0')
end

function onBeatHit()
    if mustHitSection then --No exe
        setProperty('defaultCamZoom', 0.6)
    else -- No BF
        setProperty('defaultCamZoom', 0.4)
    end

    if curBeat % 3 == 0 then
        tiltStuff(angle)
        angle = -angle;
    end
end

function tiltStuff(angleshit)
    setProperty('camHUD.angle',angleshit*3)
    setProperty('camGame.angle',angleshit*3)
    doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
    doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
    doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
    doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
end

function onEvent(name, value1, value2)
	if name == "trocar ato" then
        if value1 == 'circus_start' then
            if flashing then
            cameraFlash('legenda', '0x0000ff', 1, true)
            end
            fastChar('bfstring', 'invisibru')
            setProperty('camHUD.angle',0)
			setProperty('camGame.angle',0)
            setPropertyTiledLuaSprite("circusBG.visible", true)
            
            stop()
             -- A razão pra eu ter feito cada ato em um lua k
            -- Basicamente queria deixar esse mano que usa o Tiled Sprite bem isolado do resto.
        end
    end
end

function fastChar(bf, dad)
    triggerEvent("Change Character", 'bf', bf, 'nada', 'nada')
    triggerEvent("Change Character", 'dad', dad, 'nada', 'nada')
end