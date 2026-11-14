k = 60

local FATOR_EXPO = 10 * math.log(2)

local pecasHud = {'healthBarBG', 'healthBar', 'scoreTxt', 'iconP1', 'iconP2', 'timeBar', 'timeBarBG', 'timeTxt', 'judgementCounter'}

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


local function tweenPecaHud(i, alpha)
	doTweenAlpha('AlphaTween'..i, 'HUD.'..pecasHud[i], alpha, 0.1 * FATOR_EXPO, 'expoOut')
end

function onTweenCompleted(tag)
	if tag == 'Cinematics1saida' then
		setProperty('UpperBar.visible', false)
		setProperty('LowerBar.visible', false)
	end
end

function onEvent(name,value1,value2)
	if name == 'Cinematics-CY' then
		local startStop = tonumber(value1)
		local duracao = (tonumber(value2) or 0) * FATOR_EXPO

		if startStop == 1 then -- Entrada
			cancelTween('Cinematics1saida')
			cancelTween('Cinematics2saida')
			setProperty('UpperBar.visible', true)
			setProperty('LowerBar.visible', true)
			doTweenY('Cinematics1entrada', 'UpperBar', 0, duracao, 'expoOut')
			doTweenY('Cinematics2entrada', 'LowerBar', 660, duracao, 'expoOut')
			setProperty('HUD.botplayTxt.text', '')
			for _, i in ipairs({3, 6, 7, 8, 9}) do
				tweenPecaHud(i, 0)
			end
		elseif startStop == 2 then -- Saida
			cancelTween('Cinematics1entrada')
			cancelTween('Cinematics2entrada')
			doTweenY('Cinematics1saida', 'UpperBar', -120, duracao, 'expoOut')
			doTweenY('Cinematics2saida', 'LowerBar', 720, duracao, 'expoOut')
			setProperty('HUD.botplayTxt.text', 'BOTPLAY')
			for i = 1, #pecasHud do
				tweenPecaHud(i, 1)
			end
		end
	end
end
