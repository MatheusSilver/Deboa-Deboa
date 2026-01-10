local offsetx = -20
local offsety = 235
local scriptActive = false

function onCreate()
    makeAnimatedLuaSprite('bfrunlegsbobo', 'characters/gran-finale/hislegbobo', 0, 0);
    addAnimationByPrefix('bfrunlegsbobo', 'run', 'run legs', 24, true);
    setProperty('bfrunlegsbobo.visible', false)
    addLuaSprite('bfrunlegsbobo', false)
    setObjectOrder('bfrunlegsbobo', getObjectOrder('dadGroup'))
end

function onEvent(event, v1, v2)
    if event == 'Change Character' and v2 == 'bfrunbobo' then
        setProperty('bfrunlegsbobo.x', getPropertySpecial("boyfriend.x") + offsetx) -- just in case
        setProperty('bfrunlegsbobo.y', getPropertySpecial("boyfriend.y")  + offsety)
        setProperty('bfrunlegsbobo.visible', true)
        playAnim('bfrunlegsbobo', 'run')
        scriptActive = true
    elseif v1 == 'beef' then
        scriptActive = false
        removeLuaSprite('bfrunlegsbobo')
        stop();
    elseif getProperty("bfrunlegsbobo.visible")  and v1 == 'bf' then
        scriptActive = false
        setProperty('bfrunlegsbobo.visible', false) --Não tenho certeza, mas acho que esse sprite só é usado uma única vez.
    end
end

function onUpdate(elapsed)
    -- updateCamPos('all') -- Provavelmente isso deixaria essa parte um cadin lagada de mais.
    -- Provavelmente teremos que fazer uma modificação nesse script para o player com efeitos de camera desligados.
    if scriptActive then
        if getPropertySpecial('boyfriend.animation.curAnim.name') == 'parry' or getPropertySpecial('boyfriend.animation.curAnim.name') == 'oh' then
            setProperty('bfrunlegsbobo.alpha', 0)
        else
            setProperty('bfrunlegsbobo.alpha', 1)
        end
    end
end