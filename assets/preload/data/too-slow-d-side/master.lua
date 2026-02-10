function onCreate()
	setProperty('cameraSpeed', getProperty('cameraSpeed') + 1)
	precacheImage('ICENOTE_assets')
	precacheSound('hitIce')
	precacheSound('struggle')
	precacheSound('breakout')
	setObjectOrder("frozenBF", getObjectOrder("boyfriendGroup") + 1)
end

function onCreatePost()
	setProperty("frozenBF.x", defaultBoyfriendX)
	setProperty("frozenBF.y", defaultBoyfriendY + 250)
end

function onUpdatePost()
	updateMirrors()
end



function setSuperZoom(status)
	if cameraZoomOnBeat then setProperty("supersuperZoomShit", status) end
end

function setDefaultZoom(value)
	if cameraZoomOnBeat then setProperty("defaultCamZoom", value) end
end


function onEvent(event, v1, v2)
	if event == "Change Character" then
		if v2 == "mighty-atacado-d-side" then
			setProperty("dadReflectionOffset", -160)
			refreshCharacterMirror("dad")
		end
	end
	if event == "eventos-d-side" then
		if v1 == "384" then
			doTweenAlpha('AlphaIcon', 'HUD.iconP2', 0, 0.45)
			resetDurationTween()
		elseif v1 == "447" then
			setProperty("urTooSlow.visible", true)
			setProperty("fakeTooSlow.visible", false)
			setSuperZoom(true)
		elseif v1 == "448" then
			updateTimeBar()
			setProperty("HUD.iconP1.alpha", 1)
			setProperty("HUD.iconP2.alpha", 1)
		elseif v1 == "1087" then
			setSuperZoom(false)
		elseif v1 == "1088" then
			setDefaultZoom(1.4)
			doTweenAlpha('camHUDalpha','camHUD', 0,0.45,'linear')
		elseif v1 == "1210" then
			doTweenAlpha('camHUDalpha','camHUD', 1,0.45,'linear')
		elseif v1 == "1344" then
			setDefaultZoom(0.8)
		elseif v1 == "1359" then
			setSuperZoom(true)
		elseif v1 == "1743" then
			setSuperZoom(false)
		elseif v1 == "1760" then
			setDefaultZoom(1.0)
		elseif v1 == "1765" then
			setDefaultZoom(1.2)
		elseif v1 == "1769" then
			setDefaultZoom(1.5)
		elseif v1 == "1776" then
			setDefaultZoom(1.7)
		-- elseif v1 == 40028922 then
			
		end
	end
end