function onCreate()

    makeLuaSprite('sky','Cenarios/PolishedP2/sky',-200,-200)
    setLuaSpriteScrollFactor('sky',1,1)
    scaleObject('sky',0.8,0.8)
    addLuaSprite('sky',false)

    makeLuaSprite('backtrees','Cenarios/PolishedP2/backtrees',-200,0)
    setLuaSpriteScrollFactor('backtrees',1,1)
    scaleObject('backtrees',0.9,0.9)
    addLuaSprite('backtrees',false)

    makeLuaSprite('trees','Cenarios/PolishedP2/trees',-200,-100)
    setLuaSpriteScrollFactor('trees',1,1)
    scaleObject('trees',0.9,0.9)
    addLuaSprite('trees',false)

    makeLuaSprite('ground','Cenarios/PolishedP2/ground',-400,-100)
    setLuaSpriteScrollFactor('ground',1,1)
    scaleObject('ground',1,1)
    addLuaSprite('ground',false)

    makeLuaSprite('greenhill','Cenarios/PolishedP2/GreenHill',-200,-1750)
    setLuaSpriteScrollFactor('greenhill',1,1)
    scaleObject('greenhill',8,8)
    setProperty('greenhill.antialiasing',false)
    addLuaSprite('greenhill',false)
end
