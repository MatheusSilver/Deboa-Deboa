-- base do pendulo e pastapow por drawoon e blah blah blah...
--Anyway foi ele que fez a base disso que eu modifiquei pesadamente pra ser compatível com a engine
-- Yay créditos... Legal... Parabens ao total de 5 pessoas que estão lendo isso.

-- Na real... Considerando que essa é uma das músicas mais complexas do mod, imagino que mais do que 5 pessoas estão lendo isso... Mas anyway


bfChart=''
gfChart=''
dadChart=''

whoisMX=''

function onCreate()

    if stage ~= 'bar-hypno' then
        pushScriptData('Pendelum');
    end

    precacheSound('HandUp')
    precacheSound('POW')
    MX=''
    Scroll={screenHeight- 150,50}
    --DownScroll screenHeight- 150
    --UpScroll 50
    scrolling=2
    if not downscroll then
        scrolling=1
    end
    if dadName=='MX' then
        MX='dad'
    elseif gfName =='MX' then
        MX='gf'
    end

    HypnoScale=1
    ScaleMX=1
    
    makeAnimatedLuaSprite('HypnoArms', 'hypno_braco', 0,0)
    addAnimationByPrefix('HypnoArms','Idle','FrontIdle',24,true)
    addAnimationByPrefix('HypnoArms','0','FrontLeft',24,false)
    addAnimationByPrefix('HypnoArms','1','FrontDown',24,false)
    addAnimationByPrefix('HypnoArms','2','FrontUp',24,false)
    addAnimationByPrefix('HypnoArms','3','FrontRight',24,false)
    addOffset('HypnoArms',"Idle", -64*HypnoScale, -172*HypnoScale);
    addOffset('HypnoArms',"0", 70*HypnoScale, 120*HypnoScale);
    addOffset('HypnoArms',"1", -125*HypnoScale, -200*HypnoScale);
    addOffset('HypnoArms',"2", 80*HypnoScale, 280*HypnoScale);
    addOffset('HypnoArms',"3", -92*HypnoScale, -134*HypnoScale);
    scaleObject('HypnoArms',1.4,1.4)

    --MX
    makeAnimatedLuaSprite('MXArms','mx_braco',0,0)
    addAnimationByPrefix('MXArms','Idle','IdleFront',16,true)
    addAnimationByPrefix('MXArms','0','LeftFront',24,false)
    addAnimationByPrefix('MXArms','1','DownFront',24,false)
    addAnimationByPrefix('MXArms','2','UpFront',24,false)
    addAnimationByPrefix('MXArms','3','RightFront',24,false)
    addAnimationByPrefix('MXArms','Hit1','Hit1Front',24,false)
    addAnimationByPrefix('MXArms','Hit2','Hit2Front',24,false)

    addOffset('MXArms',"Idle", 60*ScaleMX, 5*ScaleMX);
    addOffset('MXArms',"2", 64*ScaleMX, 16*ScaleMX);
    addOffset('MXArms',"0", 451*ScaleMX, -124*ScaleMX);
    addOffset('MXArms',"3", -10*ScaleMX, -120*ScaleMX);
    addOffset('MXArms',"1", 64*ScaleMX, -122*ScaleMX);
    addOffset('MXArms',"Hit1", 111*ScaleMX, -2*ScaleMX);
    addOffset('MXArms',"Hit2", 144*ScaleMX, -110*ScaleMX);
    scaleObject('MXArms',ScaleMX,ScaleMX)

    makeAnimatedLuaSprite('POW','mxblock',0,0)
    addAnimationByPrefix('POW','bop','BlockIdle',24,false)

    --Braços e coisas

	LordX={350, 460}
	Hypno={700, 400}
	MX={-140,300}
	LordPos=''
	MXPos=''
	HypnoPos=''
    consistentPosition= {-625, -100};
	consistentSize= 1.25;

    makeLuaSprite('Sky','cenarios/SKY',consistentPosition[1]+914*consistentSize,consistentPosition[2]+263*consistentSize)
    setScrollFactor('Sky',0.9, 0.9)
    scaleObject('Sky',consistentSize+0.1,consistentSize+0.1)
    addLuaSprite('Sky',false)

    makeLuaSprite('Shine','cenarios/shine',consistentPosition[1]+916*consistentSize,consistentPosition[2]+265*consistentSize)
    setScrollFactor('Shine',0.9, 0.9)
    scaleObject('Shine',consistentSize,consistentSize)
    addLuaSprite('Shine',false)

    makeAnimatedLuaSprite('Widemouth','cenarios/MrWidemouth',consistentPosition[1]+1150*consistentSize,consistentPosition[2] + 390 * consistentSize)
    addAnimationByPrefix('Widemouth','bop','MrWidemouth instance 1',24,false)
    setScrollFactor('Widemouth',0.9, 0.9)
    scaleObject('Widemouth',consistentSize,consistentSize)
    addLuaSprite('Widemouth',false)
    setProperty('Widemouth.x',getProperty('Widemouth.x')-getProperty('Widemouth.width')/2)
    setProperty('Widemouth.y',getProperty('Widemouth.y')-getProperty('Widemouth.height')+8)

    makeLuaSprite('Bar','cenarios/5',consistentPosition[1],consistentPosition[2])
    setScrollFactor('Bar',0.9, 0.9)
    scaleObject('Bar',consistentSize,consistentSize)
    addLuaSprite('Bar',false)

    makeLuaSprite('Holder','cenarios/holder',consistentPosition[1]+1180*consistentSize,consistentPosition[2]+228*consistentSize)
    setScrollFactor('Holder',0.9, 0.9)
    scaleObject('Holder',consistentSize,consistentSize)
    addLuaSprite('Holder',false)

    makeAnimatedLuaSprite('Saled','cenarios/SFingers',consistentPosition[1]+1050*consistentSize,math.floor(consistentPosition[2]+390*consistentSize)-1)
    addAnimationByPrefix('Saled','bop','SFingers',24,true)
    setScrollFactor('Saled',0.9, 0.9)
    scaleObject('Saled',consistentSize,consistentSize)
    addLuaSprite('Saled',false)
    setProperty('Saled.x',getProperty('Saled.x')-getProperty('Saled.width')/2)
    setProperty('Saled.y',getProperty('Saled.y')-getProperty('Saled.height')+10)

    makeLuaSprite('Machine','cenarios/machine',200*1.55, 70*3.5)
    setScrollFactor('Machine',0.9, 0.9)
    scaleObject('Machine',consistentSize* 0.35,consistentSize* 0.35)
    addLuaSprite('Machine',false)

    makeAnimatedLuaSprite('Herobrine','cenarios/brian_idle',315,308)
    addAnimationByPrefix('Herobrine','bop','brian idle ',24,false)
    setScrollFactor('Herobrine',0.9, 0.9)
    scaleObject('Herobrine',consistentSize,consistentSize)
    addLuaSprite('Herobrine',false)

    makeAnimatedLuaSprite('CoronationPeach','cenarios/CoronationPeach',490*1.035, 279*1.11)
    addAnimationByPrefix('CoronationPeach','bop','CoronationPeach',24,false)
    setScrollFactor('CoronationPeach',0.9, 0.9)
    scaleObject('CoronationPeach',consistentSize* 0.5,consistentSize* 0.5)

    makeAnimatedLuaSprite('Shinto','cenarios/ShintoPastaNight',610*1.035, 312*1.08)
    addAnimationByPrefix('Shinto','bop','Shitno',24,false)
    setScrollFactor('Shinto',0.9, 0.9)
    scaleObject('Shinto',consistentSize* 0.5,consistentSize* 0.5)
    addLuaSprite('Shinto',false)

    addLuaSprite('CoronationPeach',false)

    makeAnimatedLuaSprite('Jack','cenarios/Jack',100*1.4, 180*1.4)
    addAnimationByPrefix('Jack','bop','Body with tar instance 1',24,false)
    setScrollFactor('Jack',0.9, 0.9)
    scaleObject('Jack',consistentSize* 0.5,consistentSize* 0.5)
    addLuaSprite('Jack',false)

    makeLuaSprite('OtherTable','cenarios/TableMisc',750+110,210*1.3+110)
    setScrollFactor('OtherTable',0.9, 0.9)
    scaleObject('OtherTable',consistentSize* 0.5,consistentSize* 0.5)


    makeAnimatedLuaSprite('SlenderBitch','cenarios/Buds_Slender_Effects',735*1.15,35*4)
    addAnimationByPrefix('SlenderBitch','bop','Slenderman Full',24,false)
    setScrollFactor('SlenderBitch',0.9, 0.9)
    scaleObject('SlenderBitch',consistentSize* 0.55,consistentSize* 0.55)
    addLuaSprite('SlenderBitch',false)

    makeAnimatedLuaSprite('Ben','cenarios/Ben_Drowned_BG',1145+55,175*1.5)
    addAnimationByPrefix('Ben','idle','ben drowned0',24,false)
    addAnimationByPrefix('Ben','look','ben drowned looking',24,false)
    setScrollFactor('Ben',0.9, 0.9)
    scaleObject('Ben',consistentSize* 0.55,consistentSize* 0.55)
    addLuaSprite('Ben',false)
    playAnim('Ben','idle')

    makeAnimatedLuaSprite('Squid','cenarios/Squirtward',750+40,210*1.18-20)
    addAnimationByPrefix('Squid','bop','Squidward_idleBody',24,false)
    setScrollFactor('Squid',0.9, 0.9)
    scaleObject('Squid',consistentSize* 0.6,consistentSize* 0.6)
    addLuaSprite('Squid',false)

    makeAnimatedLuaSprite('SquidHead','cenarios/Squirtward',750+40,210*1.18-20)
    addAnimationByPrefix('SquidHead','bop','Squidward_idleHead',24,false)
    setScrollFactor('SquidHead',0.9, 0.9)
    scaleObject('SquidHead',consistentSize* 0.6,consistentSize* 0.6)
    addLuaSprite('SquidHead',false)

    addLuaSprite('OtherTable',false)

    makeAnimatedLuaSprite('Jeff','cenarios/Jeff',472-90+90, 305-40+40)
    addAnimationByPrefix('Jeff','bop','mynamejeff instance ',24,false)
    setScrollFactor('Jeff',0.9, 0.9)
    scaleObject('Jeff',consistentSize* 0.78,consistentSize* 0.78)
    addLuaSprite('Jeff',false)

    makeAnimatedLuaSprite('Mousetable','cenarios/Mousetable',consistentPosition[1] + 825 * consistentSize, consistentPosition[2] + 630 * consistentSize)
    addAnimationByPrefix('Mousetable','bop','Mousetable',24,false)
    setScrollFactor('Mousetable',0.9, 0.9)
    scaleObject('Mousetable',consistentSize* 0.5,consistentSize* 0.5)
    addLuaSprite('Mousetable',false)
    setProperty('Mousetable.x',getProperty('Mousetable.x')-getProperty('Mousetable.width')/2+90)
    setProperty('Mousetable.y',getProperty('Mousetable.y')-getProperty('Mousetable.height')+40)

    makeAnimatedLuaSprite('JeffArm','cenarios/JeffArm',500-90+90, 445-40+40)
    addAnimationByPrefix('JeffArm','bop','Only the arm shit instance ',24,false)
    setScrollFactor('JeffArm',0.9, 0.9)
    scaleObject('JeffArm',consistentSize* 0.78,consistentSize* 0.78)
    addLuaSprite('JeffArm',false)

    makeLuaSprite('Table','cenarios/TABLE',0,0)
	scaleObject('Table',0.75,0.75)
	screenCenter('Table','xy')
	setProperty('Table.x',getProperty('Table.x')-50)
	setProperty('Table.y',getProperty('Table.y')+750)
	setObjectOrder('Table',40)
	addLuaSprite('Table',false)

    PosCharacters()
	
end
function PosCharacters()
	HypnoOffsetY=100
    HypnoOffsetX=50
    MXOffsetX=-75
    MXOffsetY=-45
    if stage == 'bar-lordx' then
    setCharacterX('bf',LordX[1])
    setCharacterY('bf',LordX[2])
    LordPos='bf'
    bfChart = 'lordx'

    setCharacterX('dad',Hypno[1])
	setCharacterY('dad',Hypno[2])
	
    HypnoPos='dad'
    dadChart='HypnoArms'
    setCharacterX('gf',MX[1])
	setCharacterY('gf',MX[2])
    setProperty('HypnoArms.x',getCharacterX('dad')+HypnoOffsetX)
    setProperty('HypnoArms.y',getCharacterY('dad')+HypnoOffsetY)
    setProperty('dad.flipX',false)

	MXPos='gf'
    whoisMX='gf'
    gfChart='MXArms'
    setProperty('MXArms.x',getCharacterX('gf')+MXOffsetX)
    setProperty('MXArms.y',getCharacterY('gf')+MXOffsetY)
    setObjectOrder('boyfriendGroup',getObjectOrder('Table')+1)
    setObjectOrder('dadGroup',getObjectOrder('Table')-1)
    setObjectOrder('gfGroup',getObjectOrder('Table')-1)
    setProperty('gf.flipX',false)

    elseif stage == 'bar' then
	setCharacterX('gf',LordX[1])
	setCharacterY('gf',LordX[2])
    LordPos='gf'
    gfChart = 'lordx'
    setProperty('gf.flipX',false)
    setCharacterX('bf',MX[1])
	setCharacterY('bf',MX[2])
	MXPos='bf'
    whoisMX='boyfriend'
    bfChart='MXArms'
    setProperty('MXArms.x',getCharacterX('bf')+MXOffsetX)
    setProperty('MXArms.y',getCharacterY('bf')+MXOffsetY)
    setCharacterX('dad',Hypno[1])
	setCharacterY('dad',Hypno[2])
	HypnoPos='dad'
    dadChart='HypnoArms'
    setProperty('dad.flipX',false)
    setProperty('HypnoArms.x',getCharacterX('dad')+HypnoOffsetX)
    setProperty('HypnoArms.y',getCharacterY('dad')+HypnoOffsetY)
	setObjectOrder('boyfriendGroup',getObjectOrder('Table')-1)
    setObjectOrder('dadGroup',getObjectOrder('Table')-1)
    setObjectOrder('gfGroup',getObjectOrder('Table')+1)
    else
	setCharacterX('dad',LordX[1])
	setCharacterY('dad',LordX[2])
    LordPos='dad'
    dadChart = 'lordx'
    setProperty('dad.flipX',false)
    setCharacterX('bf',Hypno[1])
	setCharacterY('bf',Hypno[2])
	HypnoPos='bf'
    bfChart='HypnoArms'
    setProperty('HypnoArms.x',getCharacterX('bf')+HypnoOffsetX)
    setProperty('HypnoArms.y',getCharacterY('bf')+HypnoOffsetY)
    setCharacterX('gf',MX[1])
	setCharacterY('gf',MX[2])
	MXPos='gf'
    whoisMX='gf'
    setProperty('gf.flipX',false)
    gfChart='MXArms'
    setProperty('MXArms.x',getCharacterX('gf')+MXOffsetX)
    setProperty('MXArms.y',getCharacterY('gf')+MXOffsetY)
	setObjectOrder('boyfriendGroup',getObjectOrder('Table')-1)
    setObjectOrder('dadGroup',getObjectOrder('Table')+1)
    setObjectOrder('gfGroup',getObjectOrder('Table')-1)
    end

    addLuaSprite('MXArms',true)
    addLuaSprite('HypnoArms',true)

    setObjectOrder('MXArms',getObjectOrder('Table')+1)
	setObjectOrder('HypnoArms',getObjectOrder('Table')+1)

    setProperty('POW.x',getProperty('MXArms.x')-MXOffsetX-195)
    setProperty('POW.y',getProperty('MXArms.y')-MXOffsetY+460)
    addLuaSprite('POW',true)

	
end

function onBeatHit()
	if curBeat % 2 == 0 then
        playAnim('Widemouth','bop')
        playAnim('Mousetable','bop')
        playAnim('Jack','bop')
        playAnim('Jeff','bop')
        playAnim('JeffArm','bop')
        playAnim('Squid','bop')
        playAnim('Herobrine','bop')
        playAnim('SquidHead','bop')
        playAnim('SlenderBitch','bop')
        playAnim('CoronationPeach','bop')
        playAnim('Shinto','bop')
        playAnim('POW','bop')
	end
	if getProperty('health') < 0.75 then
		playAnim('Ben','look')
    else
        playAnim('Ben','idle')  
    end
	
end
function onCreatePost()
	triggerEvent('Camera Follow Pos',tostring((LordX[1]+264.5-50)),tostring(LordX[2]+245-200)-35)
    setPropertyFromClass('GameOverSubstate', 'bgType', 'pasta'); --Character json file for the death animation

    setObjectOrder("healthBarBG", getObjectOrder("timeBarBG")-5)
    setObjectOrder("scoreTxt", getObjectOrder("timeBarBG")-4)
    setObjectOrder("healthBar", getObjectOrder("timeBarBG")-3)
    setObjectOrder("iconP2", getObjectOrder("timeBarBG")-2)
    setObjectOrder("iconP1", getObjectOrder("timeBarBG")-1)



    
end

function onUpdatePost(elapsed)
    if  getProperty('boyfriend.animation.curAnim.name')=='idle' then
        playAnim(bfChart,'Idle',true,false,getProperty('boyfriend.animation.curAnim.curFrame'))
    end
    if  getProperty('dad.animation.curAnim.name')=='idle' then
        playAnim(dadChart,'Idle',true,false,getProperty('dad.animation.curAnim.curFrame'))
    end
    if  getProperty('gf.animation.curAnim.name')=='idle' then
        playAnim(gfChart,'Idle',true,false,getProperty('gf.animation.curAnim.curFrame'))
    end
    
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if bfChart ~= 'lordx' then
        playAnim(bfChart,noteData,true)
    end
end

function thirdplayerNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if gfChart ~= 'lordx' then
        playAnim(gfChart,noteData,true)
    end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if dadChart ~= 'lordx' then
        playAnim(dadChart,noteData,true)
    end
end

local pos = 0;

function propriedadescomuns(var,name)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'hud'); --legenda por baixo das setas.
    --setLuaSpriteCamera(var, 'legenda'); --Legenda por cima das setas
    setGraphicSize(var, screenWidth) -- k
    setProperty(var..".alpha", opacidadeLegendas);
    
    screenCenter(var, 'xy')
    adjustPos(var, name)

    addLuaSprite(var)
end

function adjustPos(object, image)
    if string.find(image, "pastahyp") then
        setProperty(object..".y", getProperty(object..".y") + 80)
    else
        setProperty(object..".y", getProperty(object..".y") - 75)
    end
end

--opponent_legendas={"pastamx0", "pastalx0", "pastahyp0"}
--legenda_atual={"", "", ""}
--amigo_legendas={"pastamx","pastalx","pastahyp"}

function onEvent(name, value1, value2, value3)
    if name == 'Adicionar Imagens diferenciado' and legendas then
        if MXPos == 'bf' and value1~="pastamx0" then
            if value2=="pastalx0" then
                value2="pastalx"
            end
            if value3=="pastahyp0" then
                value3="pastahyp"
            end
        elseif LordPos == 'bf'  and value2~="pastalx0" then
            if value1=="pastamx0" then
                value1="pastamx"
            end
            if value3=="pastahyp0" then
                value3="pastahyp"
            end
        elseif HypnoPos == 'bf'  and value3~="pastahyp0" then
            if value1=="pastamx0" then
                value1="pastamx"
            end
            if value2=="pastalx0" then
                value2="pastalx"
            end
        end
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2, 0, pos)
            propriedadescomuns('exe1', value2)
        end
        if value3 == '' or value3 == 'null' or value3 == nil then
            removeLuaSprite('exe2', true);
        else
            makeLuaSprite('exe2', legendaPath..value3, 0, pos)
            propriedadescomuns('exe2', value3)
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe3', true)
        else
            makeLuaSprite('exe3', legendaPath..value1, 0, pos)
            propriedadescomuns('exe3', value1)
        end
    end
    
    if name=='PastaPow' then
    
    playAnim('MXArms','Hit1',true)
    playSound('HandUp',1)
    triggerEvent('Play Animation','Hit1',whoisMX)
    end

    if name=='CamPasta' then

        if tonumber(value1)==-1 then
            triggerEvent('Camera Follow Pos',tostring((LordX[1]+264.5-50)-200),tostring(LordX[2]+245-200-35))
        elseif tonumber(value1)==1 then
            triggerEvent('Camera Follow Pos',tostring((LordX[1]+264.5-50)+200),tostring(LordX[2]+245-200)-35)
        else
            triggerEvent('Camera Follow Pos',tostring((LordX[1]+264.5-50)),tostring(LordX[2]+245-200)-35)
        end
    end 
end

function onUpdate(elapsed)
    if getProperty(whoisMX..'.animation.curAnim.finished') and getProperty(whoisMX..'.animation.curAnim.name')=='Hit1' then
        triggerEvent('Play Animation','Hit2',whoisMX)
        playAnim('MXArms','Hit2',true)
        setProperty('POW.alpha',0)
        ScrollChanges()
        dropStart()
    end
    
    if  getProperty(whoisMX..'.animation.curAnim.name')~='Hit2' then
        setProperty('POW.alpha',1)
    end
    
end
    
function dropStart()
    playSound('POW',1)
    cameraShake('FlxG.camera',0.05,0.5)    
end

function WhoScrolling(a)
    if stage ~= 'bar' then
    if a == 2 then
        for i=0,3 do
            setPropertyFromGroup('playerStrums',i,'downScroll',false)
        end
        return 1
        
    else
        for i=0,3 do
            setPropertyFromGroup('playerStrums',i,'downScroll',true)
        end
        return 2
    end
    else
        if a == 2 then
            for i=0,3 do
                setPropertyFromGroup('opponentStrums',i,'downScroll',false)
                setPropertyFromGroup('thirdplayerStrums',i,'downScroll',false)
            end
            return 1
            
        else
            for i=0,3 do
                setPropertyFromGroup('opponentStrums',i,'downScroll',true)
                setPropertyFromGroup('thirdplayerStrums',i,'downScroll',true)
            end
            return 2
        end
    end

end

function ScrollChanges()
    if stage ~= 'bar' then
        if downscroll then
           noteTweenY('TweenScroll0',4,Scroll[scrolling],2.1,'bounceOut')
           noteTweenY('TweenScroll1',5,Scroll[scrolling],2.2,'bounceOut')
           noteTweenY('TweenScroll2',6,Scroll[scrolling],2.3,'bounceOut')
           noteTweenY('TweenScroll3',7,Scroll[scrolling],2.5,'bounceOut')
           
        else
            noteTweenY('TweenScroll0',4,Scroll[scrolling],2.1,'bounceOut')
            noteTweenY('TweenScroll1',5,Scroll[scrolling],2.2,'bounceOut')
            noteTweenY('TweenScroll2',6,Scroll[scrolling],2.3,'bounceOut')
            noteTweenY('TweenScroll3',7,Scroll[scrolling],2.5,'bounceOut')
        end
    else
        if downscroll then
            noteTweenY('TweenScroll0',0,Scroll[scrolling],2.1,'bounceOut')
            noteTweenY('TweenScroll1',1,Scroll[scrolling],2.2,'bounceOut')
            noteTweenY('TweenScroll2',2,Scroll[scrolling],2.3,'bounceOut')
            noteTweenY('TweenScroll3',3,Scroll[scrolling],2.5,'bounceOut')
            noteTweenY('TweenScroll4',8,Scroll[scrolling],2.1,'bounceOut')
            noteTweenY('TweenScroll5',9,Scroll[scrolling],2.2,'bounceOut')
            noteTweenY('TweenScroll6',10,Scroll[scrolling],2.3,'bounceOut')
            noteTweenY('TweenScroll7',11,Scroll[scrolling],2.5,'bounceOut')
            
         else
            noteTweenY('TweenScroll0',0,Scroll[scrolling],2.1,'bounceOut')
            noteTweenY('TweenScroll1',1,Scroll[scrolling],2.2,'bounceOut')
            noteTweenY('TweenScroll2',2,Scroll[scrolling],2.3,'bounceOut')
            noteTweenY('TweenScroll3',3,Scroll[scrolling],2.5,'bounceOut')
            noteTweenY('TweenScroll4',8,Scroll[scrolling],2.1,'bounceOut')
            noteTweenY('TweenScroll5',9,Scroll[scrolling],2.2,'bounceOut')
            noteTweenY('TweenScroll6',10,Scroll[scrolling],2.3,'bounceOut')
            noteTweenY('TweenScroll7',11,Scroll[scrolling],2.5,'bounceOut')
         end
    end

        scrolling=WhoScrolling(scrolling)
        for i = 0, getProperty('notes.length')-1 do
            setPropertyFromGroup('notes', i, 'multSpeed',0.7) 
        end


end