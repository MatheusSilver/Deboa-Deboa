-- Created by RamenDominoes (Feel free to credit or not I don't really care)
--Not bad for my first event created... I think

StartStop = 0

Speed = 0



function onCreate()
	

	--THE TOP BAR
	makeLuaSprite('UpperBar', 'empty', 0, -120)
	makeGraphic('UpperBar', 1280, 120, '000000')
	-- setObjectCamera('UpperBar', 'other') -- Desse jeito, as notas são encobertas pelas pretas + dificil
	setObjectCamera('UpperBar', 'hud') -- Desse jeito as notas passam por cima da barra preta + facil (só que talvez mais feio)
	setProperty("UpperBar.visible", false)
	addLuaSprite('UpperBar', false)


	--THE BOTTOM BAR
	makeLuaSprite('LowerBar', 'empty', 0, 720)
	makeGraphic('LowerBar', 1280, 120, '000000')
	-- setObjectCamera('UpperBar', 'other') -- Desse jeito, as notas são encobertas pelas pretas + dificil
	setObjectCamera('LowerBar', 'hud') -- Desse jeito as notas passam por cima da barra preta + facil (só que talvez mais feio)
	addLuaSprite('LowerBar', false)


end


function onUpdate()

	if StartStop == 1 then
	
	setProperty("UpperBar.visible", true)
	setProperty("LowerBar.visible", true)
	doTweenY('Cinematics1-in', 'UpperBar', 0, Speed, 'Linear')
	doTweenY('Cinematics2-in', 'LowerBar', 600, Speed, 'Linear')
	noteTweenY('NOTEMOVE1', 0, 130, Speed, 'Linear')	
	noteTweenY('NOTEMOVE2', 1, 130, Speed, 'Linear')
	noteTweenY('NOTEMOVE3', 2, 130, Speed, 'Linear')
	noteTweenY('NOTEMOVE4', 3, 130, Speed, 'Linear')
	noteTweenY('NOTEMOVE5', 4, 130, Speed, 'Linear')
	noteTweenY('NOTEMOVE6', 5, 130, Speed, 'Linear')
	noteTweenY('NOTEMOVE7', 6, 130, Speed, 'Linear')
	noteTweenY('NOTEMOVE8', 7, 130, Speed, 'Linear')
	setProperty('HUD.botplayTxt.text', '')
	doTweenAlpha('AlphaTween1', 'HUD.healthBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween2', 'HUD.healthBar', 0, 0.1)
	doTweenAlpha('AlphaTween3', 'HUD.scoreTxt', 0, 0.1)
	doTweenAlpha('AlphaTween4', 'HUD.iconP1', 0, 0.1)
	doTweenAlpha('AlphaTween5', 'HUD.iconP2', 0, 0.1)
	doTweenAlpha('AlphaTween6', 'HUD.timeBar', 0, 0.1)
	doTweenAlpha('AlphaTween7', 'HUD.timeBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween8', 'HUD.timeTxt', 0, 0.1)
	doTweenAlpha('AlphaTween9', 'HUD.judgementCounter', 0, 0.1)


	end

	if downscroll and StartStop == 1 then
	
	setProperty("UpperBar.visible", true)
	setProperty("LowerBar.visible", true)
	doTweenY('Cinematics1-in', 'UpperBar', 0, Speed, 'Linear')
	doTweenY('Cinematics2-in', 'LowerBar', 600, Speed, 'Linear')
	noteTweenY('NOTEMOVE1', 0, 480, Speed, 'Linear')	
	noteTweenY('NOTEMOVE2', 1, 480, Speed, 'Linear')
	noteTweenY('NOTEMOVE3', 2, 480, Speed, 'Linear')
	noteTweenY('NOTEMOVE4', 3, 480, Speed, 'Linear')
	noteTweenY('NOTEMOVE5', 4, 480, Speed, 'Linear')
	noteTweenY('NOTEMOVE6', 5, 480, Speed, 'Linear')
	noteTweenY('NOTEMOVE7', 6, 480, Speed, 'Linear')
	noteTweenY('NOTEMOVE8', 7, 480, Speed, 'Linear')
	setProperty('HUD.botplayTxt.text', '')
	doTweenAlpha('AlphaTween1', 'HUD.healthBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween2', 'HUD.healthBar', 0, 0.1)
	doTweenAlpha('AlphaTween3', 'HUD.scoreTxt', 0, 0.1)
	doTweenAlpha('AlphaTween4', 'HUD.iconP1', 0, 0.1)
	doTweenAlpha('AlphaTween5', 'HUD.iconP2', 0, 0.1)
	doTweenAlpha('AlphaTween6', 'HUD.timeBar', 0, 0.1)
	doTweenAlpha('AlphaTween7', 'HUD.timeBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween8', 'HUD.timeTxt', 0, 0.1)
	doTweenAlpha('AlphaTween9', 'HUD.judgementCounter', 0, 0.1)

	end


	if StartStop == 2 then
	
	doTweenY('Cinematics1-out', 'UpperBar', -120, Speed, 'Linear')
	doTweenY('Cinematics2-out', 'LowerBar', 720, Speed, 'Linear')
	noteTweenY('NOTEMOVE1', 0, 50, Speed, 'Linear')	
	noteTweenY('NOTEMOVE2', 1, 50, Speed, 'Linear')
	noteTweenY('NOTEMOVE3', 2, 50, Speed, 'Linear')
	noteTweenY('NOTEMOVE4', 3, 50, Speed, 'Linear')
	noteTweenY('NOTEMOVE5', 4, 50, Speed, 'Linear')
	noteTweenY('NOTEMOVE6', 5, 50, Speed, 'Linear')
	noteTweenY('NOTEMOVE7', 6, 50, Speed, 'Linear')
	noteTweenY('NOTEMOVE8', 7, 50, Speed, 'Linear')
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
	--doTweenAlpha('AlphaTween9', 'HUD.botplayTxt', 1, 0.1)
	
	end

	if downscroll and StartStop == 2 then
	
	doTweenY('Cinematics1-out', 'UpperBar', -120, Speed, 'Linear')
	doTweenY('Cinematics2-out', 'LowerBar', 720, Speed, 'Linear')
	noteTweenY('NOTEMOVE1', 0, 570, Speed, 'Linear')	
	noteTweenY('NOTEMOVE2', 1, 570, Speed, 'Linear')
	noteTweenY('NOTEMOVE3', 2, 570, Speed, 'Linear')
	noteTweenY('NOTEMOVE4', 3, 570, Speed, 'Linear')
	noteTweenY('NOTEMOVE5', 4, 570, Speed, 'Linear')
	noteTweenY('NOTEMOVE6', 5, 570, Speed, 'Linear')
	noteTweenY('NOTEMOVE7', 6, 570, Speed, 'Linear')
	noteTweenY('NOTEMOVE8', 7, 570, Speed, 'Linear')
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
	--doTweenAlpha('AlphaTween9', 'HUD.botplayTxt', 1, 0.1)
	
	end
	
end

function onTweenCompleted(tag)
	if tag == "Cinematics1-out" then
		setProperty("UpperBar.visible", false)
		setProperty("LowerBar.visible", false)
	end
end

function onEvent(name,value1,value2)
	if name == 'Cinematics' then
		StartStop = tonumber(value1)
		Speed = tonumber(value2)
	end
end
