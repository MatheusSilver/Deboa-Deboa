function onCreate()
	-- Nome deveras... Peculiar...

	precacheImage('notesEye');

    makeAnimatedLuaSprite('static','effects/staticBACKGROUND2',-850,-400)
	addAnimationByPrefix('static','dance','menuSTATICNEW instance ',24,true)
    objectPlayAnimation('static','dance',false)
    setScrollFactor('static', 0.9, 0.9);
    scaleObject('static', 2, 2);

	makeLuaSprite('ground', 'cenarios/ground', -800, -100);
	setScrollFactor('ground', 0.9, 0.9);
	scaleObject('ground', 1.2, 1.1);

	makeAnimatedLuaSprite('gf-dark','cenarios/GF_dark',150,150)
	addAnimationByPrefix('gf-dark','dance','GF Dancing Beat',10,true)
    objectPlayAnimation('gf-dark','dance',false)
    setScrollFactor('gf-dark', 0.9, 0.9);

	addLuaSprite('static', false);
	addLuaSprite('ground', false);
	addLuaSprite('gf-dark', false);

end

function onEvent(name, value1, value2)
	if name == "Change Character" and value1 == 'dad' and value2 == 'tails-dark-altsidekick' then
		setProperty('gfGroup.visible', true)
    	setProperty('gf.visible', true)
    end
end