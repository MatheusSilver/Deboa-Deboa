local pos = 0;

function adjustPos(var, name)
    if downscroll then
        setProperty(var..".y", getProperty(var..".y")-318-72)
    else
        setProperty(var..".y", getProperty(var..".y")-100)
    end
    if string.find(name, "luigiccc") then
        if not string.find(name, "luigiccc10") and not string.find(name, "luigiccc11") and not string.find(name, "luigiccc12") and not string.find(name, "luigiccc13") and not string.find(name, "luigiccc14") then
            setProperty(var..".y", getProperty(var..".y")-44)
        else
            setProperty(var..".y", getProperty(var..".y")+3)
        end
    end
end

local altlegendas = {'marioccc', 'luigiccc',"sonicccc", 'tailsccc'}
local altanswers = {'marioccc34', 'luigiccc17',"sonicccc35", 'tailsccc20'}

function propriedadescomuns(var, pos, name)

    
    if difficulty == 3 then
        for i = 1,#altlegendas do
			if altlegendas[i] == name then
                name = altanswers[i]
                break
            end
		end
    end
    makeLuaSprite(var, legendaPath..name, 0, pos) --Transferi pra cá assim poderia fazer o check de alt legenda mais bonitin
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setObjectCamera(var, 'hud2');
    setGraphicSize(var, screenWidth*0.9)
    screenCenter(var, 'x')
    adjustPos(var, name)
    setObjectOrder(var, getObjectOrder("botplayTxt")-pos)
    addLuaSprite(var);

    
end

function onEvent(name, value1, value2, value3, value4)
    if name == 'Adicionar Imagens diferenciado' then
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            propriedadescomuns('exe1', 2, value2) 
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
            propriedadescomuns('exe', 1, value1)
        end
    end
end
