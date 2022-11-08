function onCreate()
	makeLuaSprite('sky','Cenarios/crimge/sky', -850,-400)
		addLuaSprite('sky', false)
	
	makeLuaSprite('mountain','Cenarios/crimge/mountain', -900, 50)
		addLuaSprite('mountain', false)
	
	makeLuaSprite('grass', 'Cenarios/crimge/grass', -1150,600)
		addLuaSprite('grass', false)
	
	makeAnimatedLuaSprite('killer2', 'Cenarios/crimge/tree2', 700,-550)
		addAnimationByPrefix('killer2', 'boopp', 'trebacckk', 24, false)
			addLuaSprite('killer2', false)

	makeAnimatedLuaSprite('killer', 'Cenarios/crimge/tree2', 1100,-550)
		addAnimationByPrefix('killer', 'boop', 'trebacckk', 24, false)
			addLuaSprite('killer', false)

	makeAnimatedLuaSprite('trees','Cenarios/crimge/trees1', 500, -650)
		addAnimationByPrefix('trees','trees', 'trees', 24, false)
			addLuaSprite('trees', false)
	
	makeAnimatedLuaSprite('kill', 'Cenarios/crimge/kill', 1000,-600)
		addAnimationByPrefix('kill', 'bop', 'kill', 24, false)
			addLuaSprite('kill', false)

	makeAnimatedLuaSprite('knux', 'Cenarios/crimge/knux', -700, -500);
		addAnimationByPrefix('knux', 'first', 'knuckles', 24, true);
		objectPlayAnimation('knux', 'first');
		addLuaSprite('knux', false);
	
	makeLuaSprite ('flowey', 'Cenarios/crimge/flowey', 100, 500)
		addLuaSprite('flowey')
		setScrollFactor('mountain', 0.8,0.8)
		setScrollFactor('sky', 0.4,0.4)

end

function onBeatHit()
	if curBeat % 1 == 0 then
		objectPlayAnimation('kill', 'bop');
		objectPlayAnimation('trees', 'trees');
		objectPlayAnimation('killer', 'boop');
		objectPlayAnimation('killer2', 'boopp');
    end

end
function goodNoteHit(id, direction, noteType, isSustainNote)
	if dadName == 'x' and boyfriendName == 'majin' then
			characterPlayAnim('x', animationList[direction+1]..'-alt', false);
	end
end



function onCreatePost()
	setProperty('gf.visible',false)
end