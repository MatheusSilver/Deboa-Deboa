
local xx = 520;
local yy = 550;
local xx2 = 620;
local yy2 = 550;
local ofs = 30;
local followchars = true;
local del = 0;
local del2 = 0;

function onCreate()
    makeLuaSpriteNoAntialiasing('green', 'battle', 0, 0);
    scaleObject('green', 0.5, 0.5);
    setLuaSpriteScrollFactor('green', 1, 1);
    setProperty('green.visible', false);
    addLuaSprite('green', false);
    makeLuaSprite('bg', 'hall', -300, -50);
	setLuaSpriteScrollFactor('bg', 1, 1);
	scaleObject('bg', 1, 1);
    setProperty('bg.visible', true);
	addLuaSprite('bg', false);

    --  setando os coiso
    setPropertyFromClass('PauseSubState', 'pauseMusicName', 'pauseSans');
end

function onUpdate()

    if curStep >= 792 then

        followchars = false;
        songPos = getSongPosition()
    
        local currentBeat = (songPos/1000)*(bpm/80)
    
        doTweenY(dadTweenY, 'boyfriend', 600-20*math.sin((currentBeat*0.25)*math.pi),0.001)
    
    end


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
