
local ofs = 40;
local followchars = true; -- Yaaaaaaaaaaaaaaaaaaaay meu primeiro script em lua
-- Que pena que ele só funciona na BSL Engine k (Não que eu me importe muito com isso, claro)

function opponentNoteHit(id, direction, noteType, isSustainNote)
 if mustHitSection == false then
    if direction == 0 then
        triggerEvent('Camera Follow Pos',camPosDadX-ofs,camPosDadY)
    end
    if direction == 3 then
        triggerEvent('Camera Follow Pos',camPosDadX+ofs,camPosDadY)
    end
    if direction == 2 then
        triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY-ofs)
    end
    if direction == 1 then
        triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY+ofs)
    end
 end
end

function onUpdate()
    if followchars == true then
        if mustHitSection == true then
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',camPosBFX-ofs,camPosBFY)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',camPosBFX+ofs,camPosBFY)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY+ofs)
            end
	        if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
            end
        else
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
    
end