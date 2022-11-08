function onEvent(name, value1, value2)
    	if name == 'Zoom' then
		zoom = tonumber(value1);
        	doTweenZoom('asf', 'camGame', zoom, 2, 'cubeout')
        	setProperty('defaultCamZoom', zoom)
    	end
end