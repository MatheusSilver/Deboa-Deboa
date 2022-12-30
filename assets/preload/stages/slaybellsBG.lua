local DataDDS = {
 isPixelStage = false,
 defaultZoom = 0.55}
 local stageData = {
    run = {
        x = -1263,
        isGraphic = false,
        antialiasing = true,
        isText = false,
        flipX = false,
        image = "run",
        alpha = 1,
        isAnimated = false,
        angle = 0,
        scaleX = 1,
        visible = true,
        camera = "game",
        flipY = false,
        y = -734,
        scrollX = 1,
        order = 0,
        scrollY = 1,
        scaleY = 1
    },
    ["Sunky Christmas"] = {
        x = -500,
        isGraphic = false,
        antialiasing = true,
        isText = false,
        flipX = false,
        image = "Sunky Christmas",
        alpha = 1,
        isAnimated = true,
        angle = 0,
        scaleX = 0.8,
        visible = true,
        camera = "game",
        flipY = false,
        y = -570,
        scrollX = 1,
        order = 58,
        scrollY = 1,
        scaleY = 0.8
    }
}
 local charData ={
    gf = {
        order = 60,
        x = 40,
        scrollY = 1,
        y = -310,
        flipY = false,
        flipX = true,
        scaleY = 0.8,
        camOffsets = {
            y = 0,
            x = 0
        },
        visible = true,
        alpha = 1,
        scrollX = 1,
        angle = 0,
        antialiasing = true,
        scaleX = 0.8
    },
    dad = {
        order = 59,
        x = -540,
        scrollY = 1,
        y = -420,
        flipY = false,
        flipX = false,
        scaleY = 0.8,
        camOffsets = {
            y = 0,
            x = 0
        },
        visible = true,
        alpha = 1,
        scrollX = 1,
        angle = 0,
        antialiasing = true,
        scaleX = 0.8
    },
    boyfriend = {
        order = 61,
        x = 410,
        scrollY = 1,
        y = -10,
        flipY = false,
        flipX = false,
        scaleY = 0.8,
        camOffsets = {
            y = 0,
            x = 0
        },
        visible = true,
        alpha = 1,
        scrollX = 1,
        angle = 0,
        antialiasing = true,
        scaleX = 0.8
    }
}
--[--------------------------------------------------------------------]--

function loadData()
    for _s, _d in pairs(stageData) do
        if not _d.isText then
            if not _d.isGraphic then
                if not _d.isAnimated then
                    makeLuaSprite(_s, _d.image, _d.x, _d.y)
                else
                    makeAnimatedLuaSprite(_s, _d.image, _d.x, _d.y)
                    for _, a in pairs(_d.animations) do
                        addAnimationByPrefix(_s, _, a.animation, a.FPS, a.loop)
                    end
                end
            else
                makeLuaSprite(_s, "", _d.x, _d.y)
                makeGraphic(_s, _d.width, _d.height, _d.hex)
            end
            addLuaSprite(_s, true)
        else
            makeLuaText(_s, _d.text, 0, _d.x, _d.y)
            setTextSize(_s, _d.size)
            setTextColor(_s, _d.hex)
            addLuaText(_s, true)
        end
        setObjectCamera(_s, _d.camera)
        setScrollFactor(_s, _d.scrollX, _d.scrollY)
        setProperty(_s..'.flipX', _d.flipX)
        setProperty(_s..'.flipY', _d.flipY)
        setProperty(_s..'.alpha', _d.alpha)
        setProperty(_s..'.visible', _d.visible)
        setProperty(_s..'.scale.x', _d.scaleX)
        setProperty(_s..'.scale.y', _d.scaleY)
        setProperty(_s..'.angle', _d.angle)
        setObjectOrder(_s, _d.order)
    end
end

function loadCharData()
    for _s, _d in pairs(charData) do
        setScrollFactor(_s, _d.scrollX, _d.scrollY)
        setProperty(_s..'.flipX', _d.flipX)
        setProperty(_s..'.flipY', _d.flipY)
        setProperty(_s..'.alpha', _d.alpha)
        setProperty(_s..'.angle', _d.angle)
        setProperty(_s..'.visible', _d.visible)
        setProperty(_s..'.scale.x', _d.scaleX)
        setProperty(_s..'.scale.y', _d.scaleY)
        setObjectOrder(_s, _d.order)
    end
end

function onCreate()
    loadData()
end

function onCreatePost()
    loadCharData()
end

-- Made By Cherif's Stage Editor
        
return {stageData, charData, DataDDS}

