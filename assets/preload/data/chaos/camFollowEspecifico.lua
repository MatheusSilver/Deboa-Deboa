
local ofs = 40;
local followchars = true; -- Yaaaaaaaaaaaaaaaaaaaay meu primeiro script em lua
-- Que pena que ele só funciona na BSL Engine k (Não que eu me importe muito com isso, claro)


-- Sim... Esse é o camFollowGlobal mas com uma pequena sutileza, agora ele atualiza o tempo todo
-- Movimento de camera mais liso, sabe como é né?
-- O bixo fica voando pra cima e pra baixo o tempo todo té doido...

function onUpdate(elapsed)
    -- updateCamPos('all') -- Provavelmente isso deixaria essa parte um cadin lagada de mais.
    -- Provavelmente teremos que fazer uma modificação nesse script para o player com efeitos de camera desligados.
    if getCamMove() then    
        if mustHitSection == false then
            updateCamPos('dad')
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',camPosDadX-ofs,camPosDadY)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',camPosDadX+ofs,camPosDadY)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
            end
        else
            --updateCamPos('bf') -- Tenho minhas duvidas se o bf real vai precisar disso... Mas acho que não
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
        end
    end
end