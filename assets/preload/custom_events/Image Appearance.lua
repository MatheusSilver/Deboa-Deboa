function onEvent(name, value1, value2)
	if name == "Image Appearance" then
		makeLuaSprite('appImage', value1, 0, 0);
		setProperty("appImage.visible", false)
		addLuaSprite('appImage');
		doTweenColor('hello', 'appImage', 'FFFFFFFF', 0.5, 'quartIn');
		setObjectCamera('appImage', 'achMenu');
		setGraphicSize("appImage", screenWidth, screenHeight)
		screenCenter("appImage", 'xy')
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