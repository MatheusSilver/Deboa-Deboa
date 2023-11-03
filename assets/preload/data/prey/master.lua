function onCreate()
    pushScriptData('vgs');
    pushScriptData('Adicionar Imagens diferenciado');
    precacheImage('conquistas/medalhas/achievements (btt-alt)');
    precacheImage('conquistas/keydSTARS/star-alt');
    precacheImage('bad_ending');
    precacheImage('good_ending');
    precacheImage('true_ending')
    precacheImage('pixelUI/NOTE-FURNACE_assetszoom')
    precacheImage('pixelUI/NOTE-FURNACE_assetszoomENDS')
    precacheImage('pixelUI/NOTE-FURNACEBLU_assetszoom')
    precacheImage('pixelUI/NOTE-FURNACEBLU_assetszoomENDS')
    precacheImage('pixelUI/NOTE-STARVI_assetszoom')
    precacheImage('pixelUI/NOTE-STARVI_assetszoomENDS')
    precacheImage('pixelUI/NOTE-supa_assetszoom')
    precacheImage('pixelUI/NOTE-supa_assetszoomENDS')
    precacheImage('NOTE_assets')
    precacheImage('cenarios/starved/stardustBg')
    precacheImage('cenarios/starved/stardustBg2')
    precacheImage('cenarios/starved/stardustFloor1')
    precacheImage('cenarios/starved/stardustFloor2')
    precacheImage('cenarios/starved/stardustFloor3')
    precacheImage('cenarios/starved/stardustFloor4')

    precacheSound('AvisoSom')
    precacheSound('SonicDash')
    precacheSound('SonicJump')

    --setGameover('sonic', 'gameOverEndSonic', 'breakfast')
    setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
    --close();
end