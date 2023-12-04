-- Criado apenas pq não sei como fazer essas vignettes funcionarem de outra forma....

function onCreate()

	--BlackVG Stuff 
	makeLuaSprite('vgpreto', 'blackvignette', 0, 0);
	setObjectCamera('vgpreto', 'other');
	setProperty('vgpreto.alpha', 0)
	setProperty("vgpreto.visible", false)
	addLuaSprite('vgpreto', true);

    --RedVG Stuff
    makeLuaSprite('vg', 'RedVG', 0, 0);
	setObjectCamera('vg', 'other');
	setProperty('vg.alpha', 0)
	setProperty("vg.visible", false)
	addLuaSprite('vg', true);

    --WhiteVG Stuff
    makeLuaSprite('vgbranco', 'VGBranco', 0, 0);
	setObjectCamera('vgbranco', 'other');
	setProperty('vgbranco.alpha', 0)
	setProperty("vgbranco.visible", false)
	addLuaSprite('vgbranco', true);

end

function onEvent(name, value1, value2)
	if name == "eventos-prey" and value1 == '100000000' then
		removeLuaSprite('vgbranco')
		setProperty('vg.visible', true)
		setProperty('vg.alpha', 0.7)
    end
end

function onBeatHit()

	-- RedVG Stuff
	--[[Início do eggman risadinha]] if curBeat == 406 or curBeat == 411 or curBeat == 416 or curBeat == 421 or curBeat == 426 or --[[Fim do eggman risadinha || Inicio do eggman papinha]] curBeat == 1127 or curBeat == 1132 or curBeat == 1137 or curBeat == 1142 or curBeat == 1147 or curBeat == 1152 or curBeat == 1157 or curBeat == 1162 or curBeat == 1167 or curBeat == 1172 or curBeat == 1177 or curBeat == 1182 or curBeat == 1187 or curBeat == 1192 or curBeat == 1197 then
	setProperty("vg.visible", true)	
	doTweenAlpha('vignetteAlpha1', 'vg', 1, 0.7, 'linear');
	end

	--[[Inicio do eggman risadinha]] if curBeat == 409 or curBeat == 414 or curBeat == 419 or curBeat == 424 or--[[Fim do eggman risadinha pisca]] curBeat == 446 --[[Fim do eggman risadinha || Início do Eggman Papinha]] or curBeat == 1130 or curBeat == 1135 or curBeat == 1140 or curBeat == 1145 or curBeat == 1150 or curBeat == 1155 or curBeat == 1160 or curBeat == 1165 or curBeat == 1170 or curBeat == 1175 or curBeat == 1180 or curBeat == 1185 or curBeat == 1190 or curBeat == 1195 then
		doTweenAlpha('vignetteAlpha2', 'vg', 0, 0.7, 'linear');
	end

	if curBeat == 448 then -- apenas para garantir que isso vai sumir mesmo
		setProperty('vg.visible', false)
	end

	if curBeat == 429  or curBeat == 1200 then
		setProperty('vg.visible', true)
	end

	--whitebgstuff

	if curBeat == 857 then
        setProperty("vgbranco.visible", true)	
		doTweenAlpha('vignetteAlpha3', 'vgbranco', 0.6, 1, 'linear');
    end

	--black bg stuff
	if curBeat == 32 or curBeat == 832 then
		setProperty("vgpreto.visible", true)	
     	 doTweenAlpha('vignetteAlpha5', 'vgpreto', 1, 1, 'linear');
    end
    if curBeat == 61 or curBeat == 861 then
		doTweenAlpha('vignetteAlpha6', 'vgpreto', 0, 1, 'linear');
	end

	if curBeat == 1258 then
		doTweenAlpha('vignetteAlpha1', 'vg', 0, 0.7, 'linear');
	end

	-- Man... Eu devo ser muito burro com Lua não é possílvio


end