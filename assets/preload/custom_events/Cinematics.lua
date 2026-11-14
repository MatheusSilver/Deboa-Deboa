-- Created by RamenDominoes (Feel free to credit or not I don't really care)
--Not bad for my first event created... I think

local FATOR_EXPO = 10 * math.log(2)

local pecasHud = {'healthBarBG', 'healthBar', 'scoreTxt', 'iconP1', 'iconP2', 'timeBar', 'timeBarBG', 'timeTxt', 'judgementCounter'}



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


local function tweenNotas(y, duracao)
	for i = 0, 7 do
		noteTweenY('NOTEMOVE'..(i + 1), i, y, duracao, 'expoOut')
	end
end

local function tweenPecaHud(i, alpha)
	doTweenAlpha('AlphaTween'..i, 'HUD.'..pecasHud[i], alpha, 0.1 * FATOR_EXPO, 'expoOut')
end

function onTweenCompleted(tag)
	if tag == "Cinematics1-out" then
		setProperty("UpperBar.visible", false)
		setProperty("LowerBar.visible", false)
	end
end

function onEvent(name,value1,value2)
	if name == 'Cinematics' then
		local startStop = tonumber(value1)
		local duracao = (tonumber(value2) or 0) * FATOR_EXPO

		if startStop == 1 then
			cancelTween('Cinematics1-out')
			cancelTween('Cinematics2-out')
			setProperty("UpperBar.visible", true)
			setProperty("LowerBar.visible", true)
			doTweenY('Cinematics1-in', 'UpperBar', 0, duracao, 'expoOut')
			doTweenY('Cinematics2-in', 'LowerBar', 600, duracao, 'expoOut')
			tweenNotas(downscroll and 480 or 130, duracao)
			setProperty('HUD.botplayTxt.text', '')
			for i = 1, #pecasHud do
				tweenPecaHud(i, 0)
			end
		elseif startStop == 2 then
			cancelTween('Cinematics1-in')
			cancelTween('Cinematics2-in')
			doTweenY('Cinematics1-out', 'UpperBar', -120, duracao, 'expoOut')
			doTweenY('Cinematics2-out', 'LowerBar', 720, duracao, 'expoOut')
			tweenNotas(downscroll and 570 or 50, duracao)
			setProperty('HUD.botplayTxt.text', 'BOTPLAY')
			for i = 1, #pecasHud do
				tweenPecaHud(i, 1)
			end
		end
	end
end
