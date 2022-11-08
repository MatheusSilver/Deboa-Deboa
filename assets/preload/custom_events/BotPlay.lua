function onEvent(name, value1, value2)
        if value1 == 'on' then
            setProperty('botPlay', true)
        else
            setProperty('botPlay', false)
    end
end