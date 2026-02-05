StartStop = 0

Speed = 0

k = 60

function onCreate()
	

	--THE TOP BAR
	makeLuaSprite('UpperBar', 'empty', 0, -k)
	makeGraphic('UpperBar', 1280, k, '000000')
	setObjectCamera('UpperBar', 'camHUD')
	addLuaSprite('UpperBar', false)
	--setObjectOrder('UpperBar', getObjectOrder('HUD.timeTxt') - 2)


	--THE BOTTOM BAR
	makeLuaSprite('LowerBar', 'empty', 0, 720)
	makeGraphic('LowerBar', 1280, k, '000000')
	setObjectCamera('LowerBar', 'camHUD')
	addLuaSprite('LowerBar', false)
	--setObjectOrder('LowerBar', getObjectOrder('HUD.timeTxt') - 1)

	setProperty('UpperBar.visible', false)
	setProperty('LowerBar.visible', false)

end
function onCreatePost()
	setObjectOrder('LowerBar', getObjectOrder('HUD.healthBarBG')+1)	 
	setObjectOrder('UpperBar', getObjectOrder('HUD.healthBarBG')+1)

end


function onUpdate()

	if StartStop == 1 then -- Entrada upscroll
	
	setProperty('UpperBar.visible', true)
	setProperty('LowerBar.visible', true)
	doTweenY('Cinematics1entrada', 'UpperBar', 0, Speed, 'Linear')
	doTweenY('Cinematics2entrada', 'LowerBar', 660, Speed, 'Linear')
	setProperty('HUD.botplayTxt.text', '')
	--[[doTweenY('AlphaTween1', 'HUD.healthBarBG', 0, 0.1)
	doTweenY('AlphaTween2', 'HUD.healthBar', 0, 0.1)
	doTweenY('AlphaTween4', 'HUD.iconP1', 0, 0.1)
	doTweenY('AlphaTween5', 'HUD.iconP2', 0, 0.1)]]
	doTweenAlpha('AlphaTween3', 'HUD.scoreTxt', 0, 0.1)
	doTweenAlpha('AlphaTween6', 'HUD.timeBar', 0, 0.1)
	doTweenAlpha('AlphaTween7', 'HUD.timeBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween8', 'HUD.timeTxt', 0, 0.1)
	doTweenAlpha('AlphaTween9', 'HUD.judgementCounter', 0, 0.1)


	end

	if downscroll and StartStop == 1 then -- entrada downscroll
	setProperty('UpperBar.visible', true)
	setProperty('LowerBar.visible', true)
	doTweenY('Cinematics1entrada', 'UpperBar', 0, Speed, 'Linear')
	doTweenY('Cinematics2entrada', 'LowerBar', 660, Speed, 'Linear')
	setProperty('HUD.botplayTxt.text', '')
	--[[doTweenAlpha('AlphaTween1', 'HUD.healthBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween2', 'HUD.healthBar', 0, 0.1)
	doTweenAlpha('AlphaTween4', 'HUD.iconP1', 0, 0.1)
	doTweenAlpha('AlphaTween5', 'HUD.iconP2', 0, 0.1)]]
	doTweenAlpha('AlphaTween3', 'HUD.scoreTxt', 0, 0.1)
	doTweenAlpha('AlphaTween6', 'HUD.timeBar', 0, 0.1)
	doTweenAlpha('AlphaTween7', 'HUD.timeBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween8', 'HUD.timeTxt', 0, 0.1)
	doTweenAlpha('AlphaTween9', 'HUD.judgementCounter', 0, 0.1)

	end


	if StartStop == 2 then -- Saida upscroll
	
	doTweenY('Cinematics1saida', 'UpperBar', -120, Speed, 'Linear')
	doTweenY('Cinematics2saida', 'LowerBar', 720, Speed, 'Linear')
	setProperty('HUD.botplayTxt.text', 'BOTPLAY')
	doTweenAlpha('AlphaTween1', 'HUD.healthBarBG', 1, 0.1)
	doTweenAlpha('AlphaTween2', 'HUD.healthBar', 1, 0.1)
	doTweenAlpha('AlphaTween3', 'HUD.scoreTxt', 1, 0.1)
	doTweenAlpha('AlphaTween4', 'HUD.iconP1', 1, 0.1)
	doTweenAlpha('AlphaTween5', 'HUD.iconP2', 1, 0.1)
	doTweenAlpha('AlphaTween6', 'HUD.timeBar', 1, 0.1)
	doTweenAlpha('AlphaTween7', 'HUD.timeBarBG', 1, 0.1)
	doTweenAlpha('AlphaTween8', 'HUD.timeTxt', 1, 0.1)
	doTweenAlpha('AlphaTween9', 'HUD.judgementCounter', 1, 0.1)
	
	end

	if downscroll and StartStop == 2 then -- Saida downscroll
	
	doTweenY('Cinematics1saida', 'UpperBar', -120, Speed, 'Linear')
	doTweenY('Cinematics2saida', 'LowerBar', 720, Speed, 'Linear')
	setProperty('HUD.botplayTxt.text', 'BOTPLAY')
	--[[doTweenAlpha('AlphaTween1', 'HUD.healthBarBG', 1, 0.1)
	doTweenAlpha('AlphaTween2', 'HUD.healthBar', 1, 0.1)
	doTweenAlpha('AlphaTween4', 'HUD.iconP1', 1, 0.1)
	doTweenAlpha('AlphaTween5', 'HUD.iconP2', 1, 0.1)]]
	doTweenAlpha('AlphaTween3', 'HUD.scoreTxt', 1, 0.1)
	doTweenAlpha('AlphaTween6', 'HUD.timeBar', 1, 0.1)
	doTweenAlpha('AlphaTween7', 'HUD.timeBarBG', 1, 0.1)
	doTweenAlpha('AlphaTween8', 'HUD.timeTxt', 1, 0.1)
	doTweenAlpha('AlphaTween9', 'HUD.judgementCounter', 1, 0.1)
	
	end
	
end

function onTweenCompleted(tag)
	if tag == 'Cinematics1saida' then
		setProperty('UpperBar.visible', false)
		setProperty('LowerBar.visible', false)
	end
end

function onEvent(name,value1,value2)
	if name == 'Cinematics-CY' then
		StartStop = tonumber(value1)
		Speed = tonumber(value2)
	end
end
