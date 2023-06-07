	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

	function onCreate()
		makeLuaSprite('sponge', 'SpingeBinge', 79.5, 467);
		setProperty('sponge.visible', false)
		addLuaSprite('sponge', true);

		precacheImage('conquistas/medalhas/achievements (btt-meme maker)');
        precacheImage('conquistas/keydSTARS/star-meme maker');
	
		if lowQuality == true then
			makeLuaSprite('luanzito', 'luaznito', 0, 0);
			setObjectCamera('luanzito', 'other');
			setProperty('luanzito.visible', false)
			precacheImage('luaznito');
		else
			precacheImage('luanzitoanim');
			makeAnimatedLuaSprite('inicio', 'luanzitoanim', 0, 0);
			addAnimationByPrefix('inicio', 'luanzitoanim play', 'luanzitoanim play', 30, false)
			setObjectCamera('inicio', 'other');
			setScrollFactor('inicio', 1, 1);
			setProperty('inicio.antialiasing', true)
			setProperty('inicio.visible', false)
			addLuaSprite('inicio', false);
		end
		
	end
	
	function onTimerCompleted(tag)	
		if tag == 'FatherReturn' then
			setProperty('sponge.visible', false)
			setProperty('dad.visible', true)
		end
	end
	
	function onStepHit()
		if curStep == 538 or curStep == 2273 then
			setProperty('sponge.visible', true)
			setProperty('dad.visible', false)
			runTimer('FatherReturn', 0.7)
		end
	
		if curStep == 69 then
			--doTweenZoom('bruh', 'camGame', 2.2, 4, 'linear')
		end
	
		if curStep == 96 then
			--doTweenZoom('bruh', 'camGame', 0.9, 0.001, 'linear')
		end
	
		if curStep == 53 then
			if lowQuality == true then
				setProperty('luanzito.visible', true)
			else
				setProperty('inicio.visible', true)
				objectPlayAnimation('inicio', 'luanzitoanim play', false)
			end
		end
	
		if curStep == 96 then
			if lowQuality == true then
				removeLuaSprite('luanzito', false);
			else
				removeLuaSprite('inicio', false);
			end
		end
	end