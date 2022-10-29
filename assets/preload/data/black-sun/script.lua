	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()
	makeLuaSprite('vgblack', 'black_vignette', 0, 0);
	setProperty('vgblack.alpha', 0)
	setObjectCamera('vgblack', 'camHUD');
	addLuaSprite('vgblack', true);

	setProperty('health', 2)

	for i = 0, getProperty('unspawnNotes.length')-1 do
		setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0');
		setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.075');
	end
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
        doTweenZoom('bruh', 'camGame', 0.9, 0.4, 'cubeOut')
	elseif focus == 'dad' then
        doTweenZoom('bruh', 'camGame', 0.8, 0.4, 'cubeOut')
  end
end

function onUpdate()
    health = getProperty('health')
    if getProperty('health') > 0.00005 then
        setProperty('health', health- 0.00005);
  end
end

function onUpdate(elapsed)
-- This is how I do it
-- Alpha is +16
-- X is +0
-- Y is +8
-- Angle is +24

-- Opponent arrows: 0-3
-- Player arrows: 3-7
-- hide and show the opponents arrows
for i=0,3 do
-- Alpha is 0 (0 being invisible)
noteTweenAlpha(i+16, i, math.floor(curStep/9999), 0.01)
  end
end

function onEvent(name, value1, value2)

    if name == 'Adicionar Imagens' then
        if value1 == '' then
            makeLuaSprite('exe', 'fundosemnada', 0, -350)
            setScrollFactor('exe', 0, 0);
            scaleObject('exe', 1, 1);
            setLuaSpriteCamera('exe', 'camhud');
            addLuaSprite('exe', true);
        else
            if legendas == true then
                if downscroll == true then
                    if legendasporcima == true then
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        addLuaSprite('exe', true);
                    end
                else
                    if legendasporcima == true then
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, 0)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, 0)
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
