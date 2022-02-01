
local xx = 720;
local yy = 600;
local xx2 = 820;
local yy2 = 600;
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

function onCreate()

    -- efeitos da hud
    makeAnimatedLuaSprite('grain', 'Grainshit', 0, 0);
	setLuaSpriteScrollFactor('grain', 0, 0);
	luaSpriteAddAnimationByPrefix('grain', 'Geain instance ', 'Geain instance ', 24, true);
	setLuaSpriteCamera('grain', 'other');
	scaleObject('grain', 1, 1);

    makeLuaSprite('vig', 'vignette');
    setLuaSpriteScrollFactor('vig', 0, 0);
    scaleObject('vig', 1, 1);    
    setLuaSpriteCamera('vig', 'other');
    
    makeAnimatedLuaSprite('cups', 'CUpheqdshid', 0, 0);
    setLuaSpriteScrollFactor('cup', 0, 0);
	luaSpriteAddAnimationByPrefix('cups', 'Cupheadshit_gif instance ', 'Cupheadshit_gif instance ', 24, true);
    setLuaSpriteCamera('cups', 'other');

    makeAnimatedLuaSprite('con', 'ready_wallop', 0, 0);
    luaSpriteAddAnimationByPrefix('con', 'Ready? WALLOP!', 'Ready? WALLOP!', 24, false);
    setLuaSpriteCamera('con', 'other');

    addLuaSprite('cups', true);
    addLuaSprite('vig', true);
    addLuaSprite('grain', true);

    setPropertyFromClass('PauseSubState', 'pauseMusicName', 'pauseCup');

    -- shaders yeyyyyyyy
    if (lowQuality == false) then
        addVCREffect('camgame', true, 0.3, false, false)
        addVCREffect('camhud', true, 0.01, false, false)  
        addVCREffect('camother', true, 0.01, false, false)
    end
end