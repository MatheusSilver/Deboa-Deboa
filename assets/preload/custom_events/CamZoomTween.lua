function onEvent(name,value1,value2) -- Isso é essencialmente um Set Cam Zoom só que diferenciado
    if name == "CamZoomTween" then
        if value2 == '' then
      	  setProperty("defaultCamZoom",value1)
			--debugPrint(value2 )
		else
            doTweenZoom('camgamezoom','camGame',tonumber(value1),tonumber(value2),'sineInOut')
		end    
    end
end

function onTweenCompleted(name)

	if name == 'camgamezoom' then
    	setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
	end
end