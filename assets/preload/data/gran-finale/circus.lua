local speedChanger = 10

function onUpdate(elapsed)
    speedChanger = speedChanger + 1
    setPropertyTiledLuaSprite("circusBG.scrollX", -speedChanger*10)
end

function onTweenCompleted(tag)
    if tag == 'frompositive' then
        doTweenAngle('fromnegative', 'camHUD', -5, stepCrochet*0.01, 'sineinout') --No fim... acabei usando algo muito parecido logo em seguida k
        doTweenAngle('tt', 'camGame', -5, stepCrochet*0.01, 'sineinout')
    elseif tag == 'fromnegative' then
        doTweenAngle('frompositive', 'camHUD', 5, stepCrochet*0.01, 'sineinout')
        doTweenAngle('tt', 'camGame', 5, stepCrochet*0.01, 'sineinout')
    end
end

function onEvent(name, value1, value2)
	if name == "trocar ato" then
        if value1 == 'sayajin_transform' then
            cancelTween('frompositive')
            cancelTween('fromnegative')
            cancelTween('tt')
            setProperty('camHUD.angle', 0)
			setProperty('camGame.angle', 0)
            if flashing then
            cameraFlash('legenda', '0xffff00', 1, true)
            end
            fastChar('sbf1', 'xenomad')
            removeLuaSprite('circusBG', true)
            -- Basicamente queria deixar esse mano que usa o Tiled Sprite bem isolado do resto.
            stop()
        end
    end
end

function fastChar(bf, dad)
    triggerEvent("Change Character", 'bf', bf, 'nada', 'nada')
    triggerEvent("Change Character", 'dad', dad, 'nada', 'nada')
end