	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onUpdate()
    if mustHitSection == true then
        setProperty('defaultCamZoom', 1);
   else
        setProperty('defaultCamZoom', 0.7); -- put the zoom for the opponent here
   end
end