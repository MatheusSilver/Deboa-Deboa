	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

	function onCreate()
		makeLuaSprite('sponge', 'SpingeBinge', 79.5, 467);
		setProperty('sponge.visible', false)
		addLuaSprite('sponge', true);

		precacheImage('conquistas/medalhas/achievements (btt-meme maker)');
        precacheImage('conquistas/keydSTARS/star-meme maker');

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
	
		if curStep == 53 then
			triggerEvent('video player','AnimacoesJogaveis/luanzito', '0', 'false', 'false')
		end
	
		if curStep == 96 then
			triggerEvent('stop video', "true")
		end
	end