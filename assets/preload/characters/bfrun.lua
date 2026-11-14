local offsetx = 55
local offsety = 191

function onCreate()
    makeAnimatedLuaSprite('bfrunlegs1', 'characters/gran-finale/hisleg', 0, 0);
    addAnimationByPrefix('bfrunlegs1', 'run', 'leg', 24, true);
    setProperty('bfrunlegs1.visible', false)
    addLuaSprite('bfrunlegs1', true)
end

function onEvent(event, v1, v2)
    if event == 'Change Character' and v2 == 'bfrun' then
        setProperty('bfrunlegs1.x', getProperty("boyfriend.x") + offsetx) -- just in case
        setProperty('bfrunlegs1.y', getProperty("boyfriend.y") + offsety)
        setProperty('bfrunlegs1.visible', true)
        playAnim('bfrunlegs1', 'run')
    elseif getProperty("bfrunlegs1.visible") == true and v1 == 'bf' then
        setProperty('bfrunlegs1.visible', false) --Não tenho certeza, mas acho que esse sprite só é usado uma única vez.
    end

    if event == 'trocar ato' and v1 == 'maoboba' then
        removeLuaSprite('bfrunlegs1', true)
        stop();
    end
end