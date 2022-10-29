function onCreate()
    makeAnimatedLuaSprite('trioStatic','Phase3Static',0,0)
    addAnimationByPrefix('trioStatic','staticwow','Phase3Static',24,false)
    scaleObject('trioStatic',3.3,3.3)
    setObjectCamera('trioStatic','other')
end
function onUpdate()
    if getProperty('trioStatic.animation.curAnim.finished') then
        removeLuaSprite('trioStatic',false)
    end
end
function onEvent(name)
    if name == 'Triple Static' then
        addLuaSprite('trioStatic',true)
        objectPlayAnimation('trioStatic','staticwow',true)

    end
end