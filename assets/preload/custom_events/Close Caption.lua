function onEvent(n, v1, v2)

	if n == "Close Caption" then
        removeLuaText('text', true)

        makeLuaText('text', v1, 1280, 0, 500); 
        setTextBorder('text', 2, '000000');
        setTextAlignment('text', 'center');
        setObjectOrder('text', 99)
        setTextSize('text', 30);  
        end
        addLuaText('text')
    end
end