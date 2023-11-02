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


function onCreatePost()
    if downscroll then
        pos = -350
    else
        pos = 0
    end
end

function onEvent(name, value1, value2)
	if name == "Change Character" and value1 == 'dad' and value2 == 'tails-dark-altsidekick' then
		setProperty('gfGroup.visible', true)
    	setProperty('gf.visible', true)
    end
	if name == 'Adicionar Imagens diferenciado' and legendas then
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2, 0, pos)
            propriedadescomuns('exe1', value2)
            addLuaSprite('exe1', true);
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
        makeLuaSprite('exe', legendaPath..value1, 0, pos)
        propriedadescomuns('exe', value1)
        addLuaSprite('exe', true);
        end
    end
end

local pos = 0;

function propriedadescomuns(var, value)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'camlegenda');
    --setGraphicSize(var, screenWidth) -- k
    if var == "exe1" and string.find(value, "tailside") then
        adjustPos(var)
    end
    screenCenter(var, 'x')
end

function adjustPos(var) 
    setProperty(var..".y", getProperty(var..".y")+72)
end