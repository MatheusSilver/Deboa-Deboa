local modchart = true
-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()
    makeLuaSprite('sSKY', 'cenarios/exeStage/sky', -560, -355.8)
    setScrollFactor('sSKY', 0.3, 0.3);
	scaleObject('sSKY', 1, 1);

    makeLuaSprite('bg', 'cenarios/exeStage/ground', -514.95, -350.2)
    setScrollFactor('bg', 0.7, 0.7);
	scaleObject('bg', 1, 1);


    makeAnimatedLuaSprite('treething', 'cenarios/exeStage/ExeAnimatedBG_Assets', -570, -480)
    addAnimationByPrefix('treething', 'ExeBGAnim', 'ExeBGAnim', 24, true)
	objectPlayAnimation('treething', 'ExeBGAnim', true)
    setScrollFactor('treething', 1, 1);
    scaleObject('treething', 1.15, 1.15);
    
    makeLuaSprite('tails', 'cenarios/exeStage/TailsCorpse', 700, 500)
    setScrollFactor('tails', 1, 1);

    makeLuaSprite('overlay', 'tentacles_black', 0, 0)
    setProperty("overlay.alpha", 0.1)
	setObjectCamera("overlay", "hud2")
    setGraphicSize("overlay", screenWidth, screenHeight)
    screenCenter("overlay", 'xy')
    
    addLuaSprite('sSKY', false)
    addLuaSprite('bg', false)
    addLuaSprite('treething', false)
    if gore then
        addLuaSprite('tails', false)
    end
    addLuaSprite("overlay")
end

function onUpdate()
    if mustHitSection == true then
        setProperty('defaultCamZoom', 1);
   else
        setProperty('defaultCamZoom', 0.7); -- put the zoom for the opponent here
   end
end