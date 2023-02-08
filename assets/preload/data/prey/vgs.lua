-- Criado apenas pq não sei como fazer essas vignettes funcionarem de outra forma....

function onCreate()

	--BlackVG Stuff 
	makeLuaSprite('vgpreto', 'blackvignette', 0, 0);
	setObjectCamera('vgpreto', 'camHUD2');
	setProperty('vgpreto.alpha', 0)
	addLuaSprite('vgpreto', true);

    --RedVG Stuff
    makeLuaSprite('vg', 'RedVG', 0, 0);
	setObjectCamera('vg', 'camHUD2');
	setProperty('vg.alpha', 0)
	addLuaSprite('vg', true);

    --WhiteVG Stuff
    makeLuaSprite('vgbranco', 'VGBranco', 0, 0);
	setObjectCamera('vgbranco', 'camHUD2');
	setProperty('vgbranco.alpha', 0)
	addLuaSprite('vgbranco', true);

end

function onStepHit()

	-- RedVG Stuff
	--[[Início do eggman risadinha]] if curStep == 1625 or curStep == 1645 or curStep == 1665 or curStep == 1685 or curStep == 1705 or --[[Fim do eggman risadinha || Inicio do eggman papinha]] curStep == 4510 or curStep == 4530 or curStep == 4550 or curStep == 4570 or curStep == 4590 or curStep == 4610 or curStep == 4630 or curStep == 4650 or curStep == 4670 or curStep == 4690 or curStep == 4710 or curStep == 4730 or curStep == 4750 or curStep == 4770 or curStep == 4790 then
		doTweenAlpha('vignetteAlpha1', 'vg', 1, 1, 'linear');
	end

	--[[Inicio do eggman risadinha]] if curStep == 1635 or curStep == 1655 or curStep == 1675 or curStep == 1695 or--[[Fim do eggman risadinha pisca]] curStep == 1785 --[[Fim do eggman risadinha || Início do Eggman Papinha]] or curStep == 4520 or curStep == 4540 or curStep == 4560 or curStep == 4580 or curStep == 4600 or curStep == 4620 or curStep == 4640 or curStep == 4660 or curStep == 4680 or curStep == 4700 or curStep == 4720 or curStep == 4740 or curStep == 4760 or curStep == 4780 then
		doTweenAlpha('vignetteAlpha2', 'vg', 0, 1, 'linear');
	end

	if curStep > 1790 and curStep < 4500 then -- apenas para garantir que isso vai sumir mesmo
		setProperty('vg.visible', false)
	end

	if curStep > 1715 and curStep > 1784  or curStep < 4800 and curStep < 4900 then
		setProperty('vg.visible', true)
	end

	--whitebgstuff

	if curStep == 3430 then
        doTweenAlpha('vignetteAlpha3', 'vgbranco', 1, 1, 'linear');
    end
    if curStep == 4480 then
		doTweenAlpha('vignetteAlpha4', 'vgbranco', 0, 1, 'linear');
	end

	--black bg stuff
	if curStep == 127 or curStep == 3328 then
     	 doTweenAlpha('vignetteAlpha5', 'vgpreto', 1, 1, 'linear');
    end
    if curStep == 245 or curStep == 3443 then
		doTweenAlpha('vignetteAlpha6', 'vgpreto', 0, 1, 'linear');
	end

	-- Man... Eu devo ser muito burro com Lua não é possílvio


end