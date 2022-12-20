	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()
	makeLuaSprite('vgblack', 'blackvignette', 0, 0);
	setProperty('vgblack.alpha', 0)
	setObjectCamera('vgblack', 'camHUD');
	addLuaSprite('vgblack', true);

	setProperty('health', 2)

	for i = 0, getProperty('unspawnNotes.length')-1 do
		setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0');
		setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.075');
	end
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
        doTweenZoom('bruh', 'camGame', 0.9, 0.4, 'cubeOut')
	elseif focus == 'dad' then
        doTweenZoom('bruh', 'camGame', 0.8, 0.4, 'cubeOut')
  end
end

function onUpdate()
    health = getProperty('health')
    if getProperty('health') > 0.00005 then
        setProperty('health', health- 0.00005);
  end
end