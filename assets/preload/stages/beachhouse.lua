local angleshit = 0.5;
local anglevar = 0.5;
function onCreate()
	-- background shit
	makeLuaSprite('sky', 'cenarios/beachhouse/sky', -600, -400);
	setLuaSpriteScrollFactor('forest', 1, 1);
	scaleObject('sky', 3, 3);

	makeLuaSprite('forest', 'cenarios/beachhouse/forest', -300, -390);
	setLuaSpriteScrollFactor('forest', .7, .7);
	scaleObject('forest', 0.6, 0.6);

    makeAnimatedLuaSprite('glitch1', 'cenarios/beachhouse/glitch1', -240, -280);
    addAnimationByPrefix('glitch1', 'Symbol 1', 'Symbol 1', 24);
    setLuaSpriteScrollFactor('glitch1', 1, 1);
    scaleObject('glitch1', 1, 1);

	makeLuaSprite('sandfloor', 'cenarios/beachhouse/sandfloor', -600, -475);
	setLuaSpriteScrollFactor('sandfloor', 1, 1);
	scaleObject('sandfloor', .6, .6);

	makeLuaSprite('tree', 'cenarios/beachhouse/tree', -600, -370);
	setLuaSpriteScrollFactor('tree', .9, .9);
	scaleObject('tree', .7, .7);

	makeLuaSprite('water', 'cenarios/beachhouse/water', -700, 520);
	setLuaSpriteScrollFactor('water', 1, 1);
	scaleObject('water', .7, .6);
	
	
	--makeAnimatedLuaSprite('glitch', 'static', -600, -300);
	--scaleObject('glitch', 2, 2);
    --addAnimationByPrefix('glitch', 'glitchout', 'static glitch', 24, true); -- WHAT?????
	--objectPlayAnimation('glitch', 'glitchout');
	
	addLuaSprite('sky', false);
	addLuaSprite('forest', false);
    addLuaSprite('glitch1', false);
	addLuaSprite('sandfloor', false);
	addLuaSprite('tree', false);
	addLuaSprite('water', false);
--	addLuaSprite('glitch', true); -- false = add behind characters, true = add over characters
-- Não faço a menor ideia de onde foi parar esse sprite ai.
end

function onStepHit()
    --cameraShake('hud', 0.003, 0.2);
end

function onBeatHit()
    if curBeat % 2 == 0 then
        objectPlayAnimation('pibby','bounce',true)
    end
end

function opponentNoteHit()	
    local luckyRoll = math.random(1, 50)
    local luckyRoll2 = math.random(1, 50)
    
    if mustHitSection == false then
        if (luckyRoll >= 45) then
            cameraShake('hud', 0.08, 0.05);
        end
    end
    if mustHitSection == false then
        if (luckyRoll2 >= 45) then
            cameraShake('game', 0.08, 0.05);
        end
    end
end

function onUpdate()
	currentBeat = (getSongPosition()/1000)*(bpm/120)
	doTweenY(waterTweenY, 'water', 530 -80 * math.sin((currentBeat * 0.10) * math.pi), 0.001)
end