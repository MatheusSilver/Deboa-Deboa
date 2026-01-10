local offsetx = 24
local offsety = 187

function onCreate()
    makeAnimatedLuaSprite('bfrunlegshand', 'characters/gran-finale/hislegHand', 0, 0);
    addAnimationByPrefix('bfrunlegshand', 'run', 'leg', 24, true);
    setProperty('bfrunlegshand.visible', false)
    addLuaSprite('bfrunlegshand', false)
    setObjectOrder('bfrunlegshand', getObjectOrder('dadGroup'))
end

function onEvent(event, v1, v2)
    if event == 'Change Character' and v2 == 'bfrunHand' then
        setProperty('bfrunlegshand.x', getPropertySpecial("boyfriend.x") + offsetx) -- just in case
        setProperty('bfrunlegshand.y', getPropertySpecial("boyfriend.y") + offsety)
        setProperty('bfrunlegshand.visible', true)
        playAnim('bfrunlegshand', 'run')
    elseif getProperty("bfrunlegshand.visible")  and v1 == 'bf' then
        setProperty('bfrunlegshand.visible', false) --Não tenho certeza, mas acho que esse sprite só é usado uma única vez.
    end

    if event == 'trocar ato' and value1 == 'lateralRun' then
        removeLuaSprite('bfrunlegshand', true)
        stop();
    end
end