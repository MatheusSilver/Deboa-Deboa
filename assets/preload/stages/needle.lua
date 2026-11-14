local floaty2=0

function onCreate()
    floaty2 = 0
end

function onUpdate(elapsed)
    if getProperty("dad2.visible")then
        local frameScale = elapsed * 60
        floaty2=floaty2+0.01*frameScale
        setProperty("dad2.y", getProperty("dad2.y")+sin(floaty2)*0.5*frameScale)
    end
end