
local ofs = 40;
local followchars = true; -- Yaaaaaaaaaaaaaaaaaaaay meu primeiro script em lua
-- Que pena que ele só funciona na BSL Engine k (Não que eu me importe muito com isso, claro)
local k = 0;
if isRing == true then
    k = 1 -- assim ele não ira fazer movimento de camera ao pegar um anel.
end

local curHitting = false;

function onCreate()
    if not cameraZoomOnBeat then
        ofs = 0
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
 if mustHitSection == false and getCamMove() then
    if direction == 0 then
        triggerEvent('Camera Follow Pos',camPosDadX-ofs,camPosDadY)
    end
    if direction == 3+k then
        triggerEvent('Camera Follow Pos',camPosDadX+ofs,camPosDadY)
    end
    if direction == 2+k then
        triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY-ofs)
    end
    if direction == 1 then
        triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY+ofs)
    end
    cancelTimer('returnDAD')
 end
 runTimer('returnDAD', 1)
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if mustHitSection == true and getCamMove() then
       if direction == 0 then
           triggerEvent('Camera Follow Pos',camPosBFX-ofs,camPosBFY)
       end
       if direction == 3+k then
           triggerEvent('Camera Follow Pos',camPosBFX+ofs,camPosBFY)
       end
       if direction == 2+k then
           triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY-ofs)
       end
       if direction == 1 then
           triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY+ofs)
       end
       cancelTimer('returnBF')
    end
    runTimer('returnBF', 1)
end

function onUpdate()
    if not curHitting == mustHitSection and getCamMove() then
        if mustHitSection == true then
            triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
        elseif getCamMove() then
            triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
        end
    end
    curHitting = mustHitSection
end

function onTimerCompleted(tag)
    if tag == 'returnBF' and mustHitSection == true and getCamMove() then
        triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
    elseif tag == 'returnDAD' and mustHitSection == false and getCamMove() then
        triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
    end
end
