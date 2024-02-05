local floaty2=0

function onCreate()
    floaty2 = 0
end

function onUpdate()
    if getProperty("dad2.visible")then
        floaty2=floaty2+0.01
        setProperty("dad2.y", getProperty("dad2.y")+math.sin(floaty2)*0.5)
    end
end