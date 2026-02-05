local HudPieces = {'HUD.healthBarBG','HUD.healthBar','HUD.iconP1','HUD.iconP2','HUD.timeBar','HUD.timeBarBG'}
local index = 1
function onCreatePost()

	

------------------------------------------------------------------------
	--THE TOP BAR--
	makeLuaSprite('UpperBar', 'empty', -110, -350)
	makeGraphic('UpperBar', 1500, 350, '000000')
	setObjectCamera('UpperBar', 'camHUD')
	addLuaSprite('UpperBar', false)


	--THE BOTTOM BAR--
	makeLuaSprite('LowerBar', 'empty', -110, 730)
	makeGraphic('LowerBar', 1500, 350, '000000')
	setObjectCamera('LowerBar', 'camHUD')
	addLuaSprite('LowerBar', false)
	
------------------------------------------------------------------------

	UpperBar = getProperty('UpperBar.y')
	LowerBar = getProperty('LowerBar.y')
end



-- Você não faz ideia do quando eu xinguei o cara que programou essa bomba...
--FOR UPSCROLL ENTRANCE--
------------------------------------------------------------------------
function onEvent(name, value1, value2)
	if name == 'Better Cinematics' then
	
		Speed = tonumber(value1)
		Distance = tonumber(value2)

		doTheStuff(Speed, Distance)
	
		
		
	end
end

function doTheStuff(Speed, Distance)
	if Speed and Distance > 0 then	

		doTweenY('Cinematics1', 'UpperBar', UpperBar + Distance, Speed, 'QuadOut')
		doTweenY('Cinematics2', 'LowerBar', LowerBar - Distance, Speed, 'QuadOut')

		for Alphas = 1,8 do
			doTweenAlpha('Alpha'..Alphas, HudPieces[index], 0, Speed - 0.1)
			index = index + 1
					
			if index > #HudPieces then
			index = 1
				
			end
		end
	end


	--FOR DOWNSCROLL ENTRANCE--
	------------------------------------------------------------------------
	if downscroll and Speed and Distance > 0 then	

		doTweenY('Cinematics1', 'UpperBar', UpperBar + Distance, Speed, 'QuadOut')
		doTweenY('Cinematics2', 'LowerBar', LowerBar - Distance, Speed, 'QuadOut')

		for Alphas = 1,8 do
			doTweenAlpha('Alpha'..Alphas, HudPieces[index], 0, Speed - 0.1)
			index = index + 1
						
			if index > #HudPieces then
			index = 1
				
			end
		end
	end


	--FOR EXIT--
	------------------------------------------------------------------------
	if Distance <= 0 then		

		doTweenY('Cinematics1', 'UpperBar', UpperBar, Speed, 'QuadIn')
		doTweenY('Cinematics2', 'LowerBar', LowerBar, Speed, 'QuadIn')

		for Alphas = 1,8 do
		doTweenAlpha('Alpha'..Alphas, HudPieces[index], 1, Speed + 0.1)
		index = index + 1
					
			if index > #HudPieces then
			index = 1
				
			end
		end
		
	end	
end