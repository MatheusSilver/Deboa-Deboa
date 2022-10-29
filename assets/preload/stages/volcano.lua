function onCreate()
	-- background shit
	makeLuaSprite('stageback', 'back', -450, -300);
	setLuaSpriteScrollFactor('stageback', 0.9, 0.9);

	makeLuaSprite('mon', 'mount', -250, 0);
	setLuaSpriteScrollFactor('mon', 0.9, 0.9);
	scaleObject('mon', 0.5, 0.5);

	makeLuaSprite('val', 'volc', -440, -800);
	setLuaSpriteScrollFactor('val', 0.9, 0.9);
	scaleObject('val', 0.9, 0.9);
	
	makeLuaSprite('stagefront', 'master', -395, -200);
	setLuaSpriteScrollFactor('stagefront', 0.9, 0.9);
	scaleObject('stagefront', 1.1, 1.1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		makeLuaSprite('stagelight_left', 'stage_light', -125, -100);
		setLuaSpriteScrollFactor('stagelight_left', 0.9, 0.9);
		scaleObject('stagelight_left', 1.1, 1.1);
		
		makeLuaSprite('stagelight_right', 'stage_light', 1225, -100);
		setLuaSpriteScrollFactor('stagelight_right', 0.9, 0.9);
		scaleObject('stagelight_right', 1.1, 1.1);
		setPropertyLuaSprite('stagelight_right', 'flipX', true); --mirror sprite horizontally

		makeLuaSprite('stagecurtains', 'stagecurtains', -500, -300);
		setLuaSpriteScrollFactor('stagecurtains', 1.3, 1.3);
		scaleObject('stagecurtains', 0.9, 0.9);
	end

	addLuaSprite('stageback', false);
	addLuaSprite('mon', false);
	addLuaSprite('val', false);
	addLuaSprite('stagefront', false);	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end