function onBeatHit()
    if curBeat % 2 == 1 and not string.find(getProperty('dad.animation.curAnim.name'), 'sing') then
        characterDance('dad');
        --Esse code faz o boneco ir duas vezes para o mesmo lado k
        -- Só isso mesmo :D
    end
end

function onCountdownTick(counter)
    onBeatHit(); --Uses whatever is inside the function above, it doesn't actually call beatHit() function from PlayState or other Lua scripts again, just for being clear.
end