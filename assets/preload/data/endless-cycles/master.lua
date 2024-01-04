function onBeatHit()
	objectPlayAnimation('kill', 'bop');
	objectPlayAnimation('killer2', 'boopp');
	if curBeat % 2 == 0  and not string.find(getProperty('dad.animation.curAnim.name'), 'sing') then
		characterDance('dad');
	end
	if not string.find(getProperty('boyfriend.animation.curAnim.name'), 'sing') then
		characterDance('boyfriend');
	end


end

function onCountdownTick(counter)
    onBeatHit(); 
end