function onCreate()

	if lowQuality == false and legendas then
		makeLuaSprite("customBlack", 'empty', -750,-500)
		makeGraphic('customBlack', screenWidth*3, screenHeight*3, '000000')
		addLuaSprite("customBlack")
		setObjectOrder("customBlack", getObjectOrder("gfGroup"))
		setProperty("customBlack.visible", false)
		setProperty("customBlack.alpha", 0)
	end
	
	makeLuaSprite('MOONBACK','cenarios/piracy/BG',-500,-500)
	addLuaSprite('MOONBACK',false)
	setLuaSpriteScrollFactor('MOONBACK',0,0)
	--close(true);
		
	makeLuaSprite('TREESBACK','cenarios/piracy/BGTREES', -300,-0)
	addLuaSprite('TREESBACK',false)
	setLuaSpriteScrollFactor('TREESBG',0,0)
	
	makeLuaSprite('GROUND1','cenarios/piracy/GROUND',-750,-200)
	addLuaSprite('GROUND1', false)

	makeAnimatedLuaSprite('tailsd', 'cenarios/piracy/TBOP', -70, 300)
	addAnimationByPrefix('tailsd', 'bopidle', 'tailsbop', 24, null)
	addLuaSprite('tailsd', false)

	
	makeAnimatedLuaSprite('KNUCKLESD', 'cenarios/piracy/KNUXBOP', 900, 200)
	addAnimationByPrefix('KNUCKLESD', 'boppidle', 'knucklesbop', 24, null)
	addLuaSprite('KNUCKLESD', false)
end

function onTweenCompleted(tag)
	if tag == "customBlackOut" then
		setProperty("customBlack.visible", false)
	end
	if tag == "lyricsAway" then
		removeLuaSprite("lyricsVideo", true)
	end
end


function onEvent(event, v1, v2)
	if event == "Custom Blammed Lights" then
		if lowQuality or legendas == false then
			triggerEvent('Blammed Lights', v1, v2)
		else
			if v1 == "1" then
				setProperty("customBlack.visible", true)
				doTweenAlpha('customBlackIntro', 'customBlack', 1, 1, 'linear')
			elseif v1 == "0" then
				doTweenAlpha('customBlackOut', 'customBlack', 0, 0.5, 'linear')
			end
		end
	end
	if event == "illegalVideo" and legendas and lowQuality == false then
		if v1 == "goAway" then
			doTweenAlpha("lyricsAway", "lyricsVideo", 0, 0.35, "linear")
			doTweenAlpha("camLegendaIn", "camLegenda", 1, 0.35, "linear")
			triggerEvent("Adicionar Imagens", "bf")
		else
			doTweenAlpha("camLegendaOut", "camLegenda", 0, 0.1, "linear")
			makeLuaVideoSprite("lyricsVideo", 700, 200)
			addLuaSprite("lyricsVideo", true)
			setVideoObjectOrder('lyricsVideo', getObjectOrder('dadGroup'))
			playVideoSprite("lyricsVideo", "AnimacoesJogaveis/illegal_download", 1.3)
		end
	end
end

function onBeatHit()
	objectPlayAnimation('tailsd', 'bopidle', true)
	objectPlayAnimation('KNUCKLESD', 'boppidle', true)
end