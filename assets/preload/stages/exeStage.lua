local modchart = true
-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()
    makeLuaSprite('sSKY', 'cenarios/exeStage/sky', -560, -355.8)
    setScrollFactor('sSKY', 1, 1);
	scaleObject('sSKY', 0.98, 0.93);
    
    makeLuaSprite('trees', 'cenarios/exeStage/backtrees', -260.55, -298.3)
    setScrollFactor('trees', 1.1, 1);
	scaleObject('trees', 1.2, 1.2);
    
    makeLuaSprite('bg2', 'cenarios/exeStage/trees', -562, -474.65)
    setScrollFactor('bg2', 1.2, 1);
	scaleObject('bg2', 1.2, 1.2);
    
    makeLuaSprite('bg', 'cenarios/exeStage/ground', -514.95, -350.2)
    setScrollFactor('bg', 1.3, 1);
	scaleObject('bg', 1.18, 1.17);


    makeAnimatedLuaSprite('treething', 'cenarios/exeStage/ExeAnimatedBG_Assets', -409.95, -340.2)
    addAnimationByPrefix('treething', 'ExeBGAnim', 'ExeBGAnim', 24, true)
	objectPlayAnimation('treething', 'ExeBGAnim', true)
    setScrollFactor('treething', 1, 1);
    
    makeLuaSprite('tails', 'cenarios/exeStage/TailsCorpse', 700, 500)
    setScrollFactor('tails', 1, 1);
    
    addLuaSprite('sSKY', false)
    addLuaSprite('trees', false)
    addLuaSprite('bg2', false)
    addLuaSprite('bg', false)
    addLuaSprite('treething', false)
    addLuaSprite('tails', false)
end

function onUpdate(elapsed)
		if modchart == true then
			for i = 0,3 do
				setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
			end
		end
end