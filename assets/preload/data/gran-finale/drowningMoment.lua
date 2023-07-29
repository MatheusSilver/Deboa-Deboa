-- Ok eu acho...

--Ele tá afogando...
--E ele não é o Ben
--OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOMAGAWD
--https://youtu.be/BYdo3dz7QZc
local flashback_used = false;

function onEvent(name, value1, value2)
	if name == "flashback" then
        flashback_used = true
        cameraFlash('legenda', '0xffffff', 0.5, true)
        setProperty('drowningArt'..value1..'.visible', true) --MALDITO .VISIBLE AAAAAAAAAAAAAAAAAAAAAAA
        doTweenAlpha('drowningArt'..value1, 'drowningArt'..value1, 0, 1.5, 'linear')
    end
end

function onTweenCompleted(tag)
    if flashback_used then
        flashback_used = false
        if startsWith(tag, 'drowningArt') then
            removeLuaSprite(tag, true)
            if tag == 'drowningArt4' then
                close()
            end
        end
    end
end