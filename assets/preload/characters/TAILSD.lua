function onBeatHit()
    if curBeat % 2 == 1 and not string.starts(getProperty('dad.animation.curAnim.name'), 'sing') then
        characterDance('dad');
    end
end