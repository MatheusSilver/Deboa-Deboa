local fall = {5}
local exclusion = '5'
local fallPos = {}
local ballScales = {}
local dead = false
local first = true
local alphaLoop = true
local gravity = 9.8
local speed = 0
local fadelooping = true

local bgs = {'depths', 'floor', 'ceiling'}
local xpos = {-50, -50, -70}
local ypos = {-80, 0, -50}

function onCreate()
	setCamMove(true);
	setPropertyFromClass('GameOverSubstate', 'characterName', 'dead')

	setProperty("defaultCamZoom",1.3)
    setProperty('camhud.visible', false)

	for i = 1,#bgs do
		makeLuaSprite(bgs[i], 'cenarios/depths/sink'..bgs[i], xpos[i], ypos[i])
		scaleObject(bgs[i], 1.11, 1.1)
		addLuaSprite(bgs[i])
		if i == 1 then
			for a = 1,10 do
				local scale = getRandomFloat(0.1, 1)
				ballScales[a] = scale
				makeLuaSprite('ball'..a, 'cenarios/depths/ball', -80 + 200*a, -380)
				scaleObject('ball'..a, scale, scale)
				addLuaSprite('ball'..a)
			end
		end
	end
	setScrollFactor('ceiling', 0.9, 0.9)
	setProperty("ceiling.y", -100)
	setProperty("depths.y", -100)

	speed = 240 / getPropertyFromClass('ClientPrefs', 'framerate')
	for i = 1,10 do fallPos[i] = 0 end
	--setGameover('sonic', 'drowning', 'breakfast')
	setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'drowning'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
end

function onCreatePost()

	--setProperty('healthLoss', 0)

	makeLuaSprite('vgpreto', 'blackvignette', 0, 0);
	setObjectCamera('vgpreto', 'camHUD2');
	setProperty('vgpreto.alpha', 0.6)
	addLuaSprite('vgpreto', true);

	-- Talvez um desperdicio, mas é mais econômico do que eu inventar outro evento para isso. (Usado na talassofobia)
	makeLuaSprite('vgpretoExtra', 'blackvignette', 0, 0);
	setObjectCamera('vgpretoExtra', 'camHUD2');
	setProperty('vgpretoExtra.alpha', 1)
	setProperty('vgpretoExtra.visible', true)
	screenCenter("vgpretoExtra", "xy")
	addLuaSprite('vgpretoExtra', true);

	if not lowQuality then
		makeAnimatedLuaSprite('waves', 'cenarios/depths/waves', 0, 0)
	end
	addAnimationByPrefix('waves', 'idle', 'idle', 13, true)
	setObjectCamera('waves', 'camhud2')
	setProperty('waves.alpha', 0.12)
	scaleObject('waves', 2.5, 1.6)
	addLuaSprite('waves', true)
	if not lowQuality then
	setBlendMode('waves', 'subtract') -- Pfv não me mate X02
									  --Assinado: Não foi o Dav
									  --Fonte: Confia (não foi o Sílvio)
									  --lesgal
	end
	objectPlayAnimation('waves','idle',true)



	addLuaSprite('r', true)

	makeLuaSprite("sonic_cuidado", "AlexisTransition", 0, 0)
    screenCenter("sonic_cuidado", "xy")
    setProperty("sonic_cuidado.alpha", 0)
    setProperty("sonic_cuidado.visible", false)
    setObjectCamera("sonic_cuidado", 'camHUD2');
    addLuaSprite("sonic_cuidado", true)
end

function onEvent(name, value1, value2)
	if name == 'CharacterAlphaTween' then
		if value1 == 'dad' then
			fadelooping = false -- Isso serve basicamente pra ajustar o finalzinho da musica e fazer o GHOUL sumir de vez
		end
	end

	if name == "TelaPreta" and value2 == "blackVGgo" then
		setProperty("vgpretoExtra.visible", true)
	end

	if name == "notestween" and value1 == "bf" and value2 == "1,0.4" then
		doTweenAlpha("vgpretoExtraOut", "vgpretoExtra", 0, 0.5, "linear")
	end

	if name == "cuidado_event" then
        if value1 == "intro" then
            setProperty("sonic_cuidado.visible", true)
            doTweenAlpha("cuidado_intro", "sonic_cuidado", 1, 0.5, "smoothstepin")
        elseif value1 == "out" then
            doTweenAlpha("cuidado_out", "sonic_cuidado", 0, 0.5, "smoothstepout")
		end
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if first and curBeat < 510 and dead == false and fadelooping then
		setProperty('dad.alpha', 0.4)
		setProperty('HUD.iconP2.alpha', 1)
		doTweenAlpha('boo1', 'dad', 0, 0.6, 'linear')
		first = false
	end
end

function onUpdate(elapsed)
	for i = 1,#fall do
		moveBall(fall[i])
	end
end

function moveBall(number) --ok
	fallPos[number] = fallPos[number] + 0.003 * speed * ballScales[number]
	local ypos = getHeight(-380, fallPos[number])
	local xpos = sin(getSongPosition()/1000 + number * 0.45) * 50 * ballScales[number] + -80 + 200 * number

	if ypos >= 1700 then
		fallPos[number] = 0
	end
	setProperty('ball'..number..'.y', ypos)
	setProperty('ball'..number..'.x', xpos)
end

function onStartCountdown() --ok
	setProperty('HUD.iconP2.alpha', 0)
	setProperty('dad.alpha', 0)
	setProperty('HUD.visible', false)
	setProperty('camHUD.visible', false)
	doTweenAlpha('b', 'waves', 0.06, 0.6, 'linear')
	doTweenAlpha("c", 'vgpreto', 0.3, 0.6, 'linear')
	return Function_Continue
end

function onStepHit()
	if curStep == 512 then alphaLoop = false end
	if curStep == 517 then 
	doTweenAlpha('first', 'waves', 0.35, 0.8, 'linear') 
	doTweenAlpha('third', 'vgpreto', 0.3, 0.8, 'linear') 
	end
end

function onTweenCompleted(tag)
	if tag == "vgpretoExtraOut" then removeLuaSprite("vgpretoExtra") end
	if tag == 'boo1' and fadelooping then doTweenAlpha('boo2', 'dad', 0.45, 0.6, 'linear') end
	if tag == 'boo2' and fadelooping then doTweenAlpha('boo1', 'dad', 0.1, 0.6, 'linear') end
	if tag == 'a' and alphaLoop then doTweenAlpha('b', 'waves', 0.06, 0.8, 'linear') end
	if tag == 'b' and alphaLoop then doTweenAlpha('a', 'waves', 0.12, 0.8, 'linear') end
	if tag == 'c' and alphaLoop then doTweenAlpha('d', 'vgpreto', 1, 0.8, 'linear') end
	if tag == 'd' and alphaLoop then doTweenAlpha('c', 'vgpreto', 0.6, 0.8, 'linear') end
	if tag == 'first' then alphaLoop = true; doTweenAlpha('b', 'waves', 0.06, 0.8, 'linear') end
	if tag == 'r1' then doTweenAlpha('r2', 'r', 0.5, 1, 'linear') end
	if tag == 'r2' then doTweenAlpha('r1', 'r', 1, 1, 'linear') end

	if tag == "cuidado_out" then removeLuaSprite("sonic_cuidado") end
end
local wasLooping = false
function onBeatHit()

	if curBeat == 30 then
		cameraFlash('other', 'FFFFFF', '0.5')
		setProperty('HUD.visible', true)
		setProperty('camHUD.visible', true)
		setProperty('vgpretoExtra.visible', false)
	end
	if curBeat % 16 == 0 and #fall < 10 then
		local rng = getRandomInt(1,10, exclusion)
		table.insert(fall, #fall+1, rng)
		exclusion = exclusion..','..rng
	end
	if curBeat == 326 then
		doTweenAlpha('vgVAI', 'vgpreto', 0.8, 0.5, 'linear') 
		setCamMove(false);
		wasLooping = alphaLoop
		alphaLoop=false
		triggerEvent("Camera Follow Pos", '1200', '475')
		setProperty("defaultCamZoom",getProperty("defaultCamZoom")+0.3);
	elseif curBeat == 340 then
		doTweenAlpha('vgVAI', 'vgpreto', 0.3, 0.5, 'linear') 
		setCamMove(true);
		alphaLoop= wasLooping
	end

end

function getHeight(baseH, tiempo)
    local height = 0

    height = baseH + ((gravity)*tiempo*tiempo)/2
    return height
end