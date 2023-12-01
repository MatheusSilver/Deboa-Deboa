function onCreate()
    precacheImage('conquistas/medalhas/achievements (btt-alt)');
    precacheImage('conquistas/keydSTARS/star-alt');
    precacheImage('bad_ending');
    precacheImage('good_ending');
    precacheImage('true_ending')
    precacheImage('pixelUI/NOTE-FURNACE_assetszoom')
    precacheImage('pixelUI/NOTE-FURNACE_assetszoomENDS')
    precacheImage('pixelUI/NOTE-STARVI_assetszoom')
    precacheImage('pixelUI/NOTE-STARVI_assetszoomENDS')
    precacheImage('pixelUI/NOTE-supa_assetszoom')
    precacheImage('pixelUI/NOTE-supa_assetszoomENDS')
    precacheImage('NOTE_assets')
    precacheSound('AvisoSom')

    --setGameover('sonic', 'gameOverEndSonic', 'breakfast')
    setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
    
    close(); --Antes os scripts data eram puxados por aqui, mas como agora, o controle todo é feito no stage
    -- Podemos então fechar esse script pra poupar um cadin.
end