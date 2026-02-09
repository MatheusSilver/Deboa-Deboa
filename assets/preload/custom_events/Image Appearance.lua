function onEvent(name, value1, value2)
	if name == "Image Appearance" then
		makeLuaSprite('appImage', value1, 0, 0);
		setProperty("appImage.visible", true)
		setObjectCamera('appImage', 'hud2');
		setGraphicSize("appImage", screenWidth, screenHeight)
		screenCenter("appImage", 'xy')
		addLuaSprite('appImage');
		runTimer('wait', value2);
	end
end

function onTimerCompleted(tag, loops, loopsleft)
	if tag == 'wait' then
		setProperty("appImage.visible", true)
		doTweenAlpha('byebye', 'appImage', 0, 0.1, 'linear');
	end
end

function onTweenCompleted(tag)
	if tag == 'byebye' then
		removeLuaSprite('appImage', true);
	end
end