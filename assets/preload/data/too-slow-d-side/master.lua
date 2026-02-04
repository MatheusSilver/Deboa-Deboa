function onCreate()
	setProperty('cameraSpeed', getProperty('cameraSpeed') + 1)
end

function setSuperZoom(status)
	if cameraZoomOnBeat then setProperty("supersuperZoomShit", status) end
end

function setDefaultZoom(value)
	if cameraZoomOnBeat then tsetProperty("defaultCamZoom", value) end
end


function onEvent(event, v1, v2)
	if event == "eventos-d-side" then
		if v1 == 384 then
			setProperty("blackFuck.alpha", 0)
			setProperty("blackFuck.visible", true)
			doTweenAlpha('AlphaBlack', 'blackFuck', 1, 0.45)
			doTweenAlpha('AlphaIcon', 'HUD.iconP2', 0, 0.45)
			resetDurationTween()
		elseif v1 == 447 then
			setProperty("urTooSlow.visible", true)
			setProperty("fakeTooSlow.visible", false)
			setSuperZoom(true)
		elseif v1 == 448 then
			updateTimeBar()
			setProperty("blackFuck.alpha", 0)
			setProperty("blackFuck.visible", false)
			setProperty("hud.iconP1.alpha", 1)
		elseif v1 == 1087 then
			setSuperZoom(false)
		elseif v1 == 1088 then
			setDefaultZoom(1.4)
			doTweenAlpha('camHUDalpha','camHUD', 0,0.45,'linear')
		elseif v1 == 1210 then
			doTweenAlpha('camHUDalpha','camHUD', 1,0.45,'linear')
		elseif v1 == 1344 then
			setDefaultZoom(0.8)
		elseif v1 == 1359 then
			setSuperZoom(true)
		elseif v1 == 1743 then
			setSuperZoom(false)
		elseif v1 == 1760 then
			setDefaultZoom(1.0)
		elseif v1 == 1765 then
			setDefaultZoom(1.2)
		elseif v1 == 1769 then
			setDefaultZoom(1.5)
		elseif v1 == 1776 then
			setDefaultZoom(1.7)
		elseif v1 == 40028922 then
			
		end
end