
local xx = 520;
local yy = 350;
local xx2 = 820;
local yy2 = 350;
local ofs = 30;
local followchars = true;
local del = 0;
local del2 = 0;


function onUpdate()
	if del > 0 then
		del = del - 1
	end
	if del2 > 0 then
		del2 = del2 - 1
	end
    if followchars == true then
        if mustHitSection == false then
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
        else

            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
	    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end

    if curStep == 1088 then
        makeAnimatedLuaSprite('jump', 'Jumpscr01', 400, 165)
        setScrollFactor('jump', 0, 0);
        luaSpriteAddAnimationByPrefix('jump', 'Heyyy bitch instance ', 'Heyyy bitch instance ', 24, false)
        setLuaSpriteCamera('jump', 'camhud');
        addLuaSprite('jump', false);
        playSound('out', 0.2);
        --removeLuaSprite('jump');
    end
    if curStep == 1 then
        removeLuaSprite('jump');
    end
    if curStep == 1420 then
        makeAnimatedLuaSprite('jump', 'Jumpscr02', 400, 50)
        setScrollFactor('jump', 0, 0);
        luaSpriteAddAnimationByPrefix('jump', 'Jumppp instance ', 'Jumppp instance ', 24, false)
        setLuaSpriteCamera('jump', 'camhud');
        addLuaSprite('jump', false);
        playSound('out', 0.2);
        --removeLuaSprite('jump');
    end
    if curStep == 1459 then
        removeLuaSprite('jump');
    end
    if curStep == 1853 then
        makeAnimatedLuaSprite('jump', 'Jumpscr03', 400, 0)
        setScrollFactor('jump', 0, 0);
        luaSpriteAddAnimationByPrefix('jump', 'U instance ', 'U instance ', 24, false)
        setLuaSpriteCamera('jump', 'camhud');
        addLuaSprite('jump', false);
        playSound('out', 0.2);
        --removeLuaSprite('jump');
    end
    if curStep == 1875 then
        removeLuaSprite('jump');
    end
    if curStep == 2186 then
        makeAnimatedLuaSprite('jump', 'Jumpscr04', 870, 360)
        setScrollFactor('jump', 0, 0);
        luaSpriteAddAnimationByPrefix('jump', 'Grr instance ', 'Grr instance ', 24, false)
        setLuaSpriteCamera('jump', 'camhud');
        addLuaSprite('jump', false);
        playSound('out', 0.2);
        --removeLuaSprite('jump');
    end

    setPropertyFromClass('PauseSubState', 'pauseMusicName', 'pauseBendy');
end

function onCreate()
    precacheImage('Jumpscr01')
    precacheImage('Jumpscr02')
    precacheImage('Jumpscr03')
    precacheImage('Jumpscr04')
    precacheSound('out')
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
            if legendas == true then
                if downscroll == true then
                    if legendasporcima == true then
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'other');
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
                        setLuaSpriteCamera('exe', 'other');
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
