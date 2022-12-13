	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

local allowCountdown = false;
local darknotevisibility = false;

--local usertimebar = '';
function onCreate()
    setProperty('gf.visible', false);

    addCharacterToList('TailsDoll', 'dad')
    addCharacterToList('SSBF', 'bf')

  --  usertimebar = getPropertyFromClass('ClientPrefs', 'timeBarType');

end

--Lembrar de fazer o ínicio dessa música HARDCODE

function opponentNoteHit()
    if darknotevisibility == true then
        setPropertyFromGroup('strumLineNotes', 4, 'alpha', 0.5);
        setPropertyFromGroup('strumLineNotes', 5, 'alpha', 0.5);
        setPropertyFromGroup('strumLineNotes', 6, 'alpha', 0.5);
        setPropertyFromGroup('strumLineNotes', 7, 'alpha', 0.5);
    end
end

function onUpdate()

 --  if keyJustPressed('space') == true then
     --   debugPrint('setting: ', getPropertyFromClass('ClientPrefs', 'timeBarType'))
      --  debugPrint(usertimebar);
        -- debugPrint(getPropertyFromGroup('strumLineNotes', 4, 'x'));
        -- debugPrint(getPropertyFromGroup('strumLineNotes', 5, 'x'));
        -- debugPrint(getPropertyFromGroup('strumLineNotes', 6, 'x'));
        -- debugPrint(getPropertyFromGroup('strumLineNotes', 7, 'x'));

    if darknotevisibility == true then
        if getPropertyFromGroup('strumLineNotes', 4, 'alpha') > 0 then
            setPropertyFromGroup('strumLineNotes', 4, 'alpha', getPropertyFromGroup('strumLineNotes', 4, 'alpha') - 0.02);
            setPropertyFromGroup('strumLineNotes', 5, 'alpha', getPropertyFromGroup('strumLineNotes', 5, 'alpha') - 0.02);
            setPropertyFromGroup('strumLineNotes', 6, 'alpha', getPropertyFromGroup('strumLineNotes', 6, 'alpha') - 0.02);
            setPropertyFromGroup('strumLineNotes', 7, 'alpha', getPropertyFromGroup('strumLineNotes', 7, 'alpha') - 0.02);

            setPropertyFromClass('Note', 'note.noteSplashDisabled', false);
            setProperty('comboSpr.visible', false);
            setProperty('rating.visible', false);
        end
    end
end

--function onDestroy()
   --     setPropertyFromClass('ClientPrefs', 'timeBarType', usertimebar)
--end

function onStepHit()
    if curStep == 588 then
        setPropertyFromClass('ClientPrefs', 'timeBarType', 'Song Name')
        
        triggerEvent('Change Character', '1', 'TailsDoll');
        triggerEvent('Change Character', '0', 'SSBF');
        setProperty('defaultCamZoom', 0.9);
        setProperty('stage.alpha', 0);
        setProperty('boyfriend.visible', false);
        setProperty('healthBar.visible', false);
        setProperty('healthBarBG.visible', false);
        -- setProperty('timeBar.visible', false);
        -- setProperty('timeBarBG.visible', false);
        setProperty('iconP1.visible', false);
        setProperty('iconP2.visible', false);
        setProperty('scoreTxt.visible', false);

        noteTweenX('left', 0, -2000, 0.01, 'linear');
        noteTweenX('down', 1, -2000, 0.01, 'linear');
        noteTweenX('up', 2, -2000, 0.01, 'linear');
        noteTweenX('right', 3, -2000, 0.01, 'linear');

        setPropertyFromGroup('strumLineNotes', 4, 'x', 412);
        setPropertyFromGroup('strumLineNotes', 5, 'x', 524);
        setPropertyFromGroup('strumLineNotes', 6, 'x', 636);
        setPropertyFromGroup('strumLineNotes', 7, 'x', 748);
        setPropertyFromGroup('strumLineNotes', 4, 'alpha', 0.5);
        setPropertyFromGroup('strumLineNotes', 5, 'alpha', 0.5);
        setPropertyFromGroup('strumLineNotes', 6, 'alpha', 0.5);
        setPropertyFromGroup('strumLineNotes', 7, 'alpha', 0.5);

        darknotevisibility = true;
        
        
    end

    if curStep == 860 then
          --  setPropertyFromClass('ClientPrefs', 'timeBarType', usertimebar)

        triggerEvent('Change Character', '1', 'tailsdoll-cartoon');
        triggerEvent('Change Character', '0', 'bf');
        setProperty('defaultCamZoom', 0.86);
        setProperty('stage.alpha', 1);
        setProperty('boyfriend.visible', true);
        setProperty('healthBar.visible', true);
        setProperty('healthBarBG.visible', true);
        setProperty('timeTxt.visible', true);
        -- setProperty('timeBar.visible', true);
        -- setProperty('timeBarBG.visible', true);
        setProperty('iconP1.visible', true);
        setProperty('iconP2.visible', true);
        setProperty('scoreTxt.visible', true);

        noteTweenX('left', 0, defaultOpponentStrumX0, 0.01, 'linear');
        noteTweenX('down', 1, defaultOpponentStrumX1, 0.01, 'linear');
        noteTweenX('up', 2, defaultOpponentStrumX2, 0.01, 'linear');
        noteTweenX('right', 3, defaultOpponentStrumX3, 0.01, 'linear');

        setPropertyFromGroup('strumLineNotes', 4, 'x', defaultPlayerStrumX0);
        setPropertyFromGroup('strumLineNotes', 5, 'x', defaultPlayerStrumX1);
        setPropertyFromGroup('strumLineNotes', 6, 'x', defaultPlayerStrumX2);
        setPropertyFromGroup('strumLineNotes', 7, 'x', defaultPlayerStrumX3);
        setPropertyFromGroup('strumLineNotes', 4, 'alpha', 1);
        setPropertyFromGroup('strumLineNotes', 5, 'alpha', 1);
        setPropertyFromGroup('strumLineNotes', 6, 'alpha', 1);
        setPropertyFromGroup('strumLineNotes', 7, 'alpha', 1);

        darknotevisibility = false;
    end
end