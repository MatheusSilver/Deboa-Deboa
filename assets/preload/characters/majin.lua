function onBeatHit()
    if curBeat % 2 == 1 and not string.starts(getProperty('boyfriend.animation.curAnim.name'), 'sing') then
        characterDance('boyfriend');
    end
end

function onCountdownTick(counter)
    onBeatHit(); --Uses whatever is inside the function above, it doesn't actually call beatHit() function from PlayState or other Lua scripts again, just for being clear.
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end