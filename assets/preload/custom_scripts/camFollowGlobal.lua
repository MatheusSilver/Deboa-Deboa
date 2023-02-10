
local ofs = 40;
local followchars = true; -- Yaaaaaaaaaaaaaaaaaaaay meu primeiro script em lua
-- Que pena que ele só funciona na BSL Engine k (Não que eu me importe muito com isso, claro)
local k = 0;
if isRing == true then
    k = 1 -- assim ele não ira fazer movimento de camera ao pegar um anel.
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
 if mustHitSection == false then
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
 end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if mustHitSection == true then
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
    end
   end
   
function onStepHit()
    if curStep % 16 == 0 then --Em tese esse é o tempo de uma section...
        if mustHitSection == true then
            triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
        else
            triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
        end
    end
end