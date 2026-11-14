local intro = true
local moveCam = true
local camX = 512
local camY = 420

local weewoo = 0
local ofs = 30
local curHealth = 1
local shownHealth

local function healthStuff()
	curHealth = math.floor(getProperty('health')/2*100)
	local healthPercent = math.min(curHealth, 100)
	if healthPercent == shownHealth then
		return
	end
	shownHealth = healthPercent
	setTextString('funnyHud', 'Health: ' .. healthPercent)
end

function onCreate()
	setProperty('defaultCamZoom', 1.05)
	
	makeAnimatedLuaSprite('bloodfilter', 'cenarios/bloodfilter', -108, -100)
	addAnimationByPrefix('bloodfilter', 'bloodfilter', 'bloodfilter', 60, true)
	objectPlayAnimation('bloodfilter', 'bloodfilter', true)
	setObjectCamera('bloodfilter', 'camHUD')
	setGraphicSize('bloodfilter', screenWidth*1, screenHeight*1.5)
	screenCenter("bloodfilter", "xy")
	setProperty('bloodfilter.alpha', 0)
	addLuaSprite('bloodfilter', true)
	
	makeAnimatedLuaSprite('slash', 'cenarios/slash', 100, 0)
	addAnimationByPrefix('slash', 'slash', 'slash', 30, false)
	setObjectCamera('slash', 'camHUD')
	setProperty('slash.alpha', 0)
	setGraphicSize('slash', screenWidth, screenHeight)
	screenCenter("slash", "xy")
	setProperty("slash.x", getProperty("slash.x")+90)
	addLuaSprite('slash', true)

	makeLuaSprite('sideBarLeft', "empty", 0, 0)
	setObjectCamera("sideBarLeft", "camHUD")
	makeGraphic('sideBarLeft', screenWidth*0.1, screenHeight, '000000')
	setScrollFactor('sideBarLeft', 0, 0)
	addLuaSprite('sideBarLeft', true)

	makeLuaSprite('sideBarRight', "empty", 0, 0)
	setObjectCamera("sideBarRight", "camHUD")
	makeGraphic('sideBarRight', screenWidth*0.1, screenHeight, '000000')
	setProperty("sideBarRight.x", screenWidth-getProperty("sideBarRight.width"))
	setScrollFactor('sideBarRight', 0, 0)
	addLuaSprite('sideBarRight', true)
	
	makeLuaSprite('backdrop', "empty", 0, -500)
	makeGraphic('backdrop', screenWidth * 2, screenWidth * 2, '333333')
	setScrollFactor('backdrop', 0, 0)
	addLuaSprite('backdrop', false)

	makeLuaSprite('bg', 'cenarios/bg2', 150, -200)
	scaleObject('bg', 0.6, 1.1)
	setScrollFactor('bg', 0.9, 0.9)
	addLuaSprite('bg', false)

	makeLuaText('funnyHud', 'Health: 0', 999, 60, 800)
	setTextSize('funnyHud', 60)
	setTextFont('funnyHud', 'HelpMe.ttf')
	setTextColor('funnyHud', 'FFFFFF')
	setObjectCamera('funnyHud', 'camHUD')
	addLuaText('funnyHud', true)
	setProperty("funnyHud.x", -150)
	if not downscroll then
		setProperty("funnyHud.y", screenHeight-110)
	else
		setProperty("funnyHud.y", 90)
	end
	makeLuaSprite('shadow', 'cenarios/shadow', -520, -190)
	addLuaSprite('shadow', false)
	
	makeLuaSprite('bintro', "empty", 0, -500)
	makeGraphic('bintro', screenWidth * 2, screenWidth * 2, '000000')
	setProperty('bintro.alpha', 1)
	setScrollFactor('bintro', 0, 0)
	addLuaSprite('bintro', true)

end

function onCreatePost()
	for i = 0, 3 do
		setPropertyFromGroup('opponentStrums', i, 'x', getPropertyFromGroup('opponentStrums', i, 'x') + 35)
		setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') - 40)
	end

	if middlescroll then
		setPropertyFromGroup('playerStrums', 0, 'x', getPropertyFromGroup('playerStrums', 0, 'x') - 75)
		setPropertyFromGroup('playerStrums', 1, 'x', getPropertyFromGroup('playerStrums', 1, 'x') - 50)
		setPropertyFromGroup('playerStrums', 2, 'x', getPropertyFromGroup('playerStrums', 2, 'x') + 50)
		setPropertyFromGroup('playerStrums', 3, 'x', getPropertyFromGroup('playerStrums', 3, 'x') + 75)
	end
	
	setProperty('boyfriend.visible', false)
	setProperty('gf.visible', false)

	setProperty('HUD.healthBarBG.visible', false)
	setProperty('HUD.healthBar.visible', false)
	setProperty('HUD.iconP1.visible', false)
	setProperty('HUD.iconP2.visible', false)
	setProperty('HUD.scoreTxt.visible', false)
	setProperty('HUD.timeBarBG.visible', false)
	setProperty('HUD.timeBar.visible', false)
	setProperty('HUD.timeTxt.visible', false)

	setProperty('dad.x', -23)
	setProperty('dad.y', 17)

	setPropertyOnLuas("camPosBFX", camPosDadX)
	setPropertyOnLuas("camPosBFY", camPosDadY)
	triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY, "true")
end

function onUpdate(elapsed)
	weewoo = weewoo + (0.03 * elapsed * 60)

	if not intro then
		setProperty('dad.y', getProperty('dad.y') + math.sin(weewoo) * 0.8 * elapsed * 60)
	end

	healthStuff()
end

function onBeatHit()
	if curBeat == 1 then
		doTweenAlpha('bintroFade', 'bintro', 0.4, 25, 'sineOut')
	end

	if curBeat == 65 then
		intro = false
	end
end

function coolSlash()
	cancelTween('bloodTween')
	objectPlayAnimation('slash', 'slash', true)
	cameraFlash('camHUD', 'FF0000', 1, true)
	setProperty('bloodfilter.alpha', 1)
	setProperty('slash.alpha', 1)
	doTweenAlpha('bloodTween', 'bloodfilter', 0, 10, 'linear')

	setProperty("health", getProperty('health')/8)

	cameraShake('camGame', 0.01, 1)
	playSound('slash', 1)
end

function onEvent(name, value1, value2)
	if name == 'TDP2 Slash' then
		coolSlash()
	end
	if name == "Set Cam Zoom" and value1 == "0.9" then
		setPropertyOnLuas("camPosDadY", camPosDadY+50)
		setPropertyOnLuas("camPosBFY", camPosDadY)
	end
end
