function onCreate()
    pushScriptData('intro');
    pushScriptData('run');
    pushScriptData('missRING');
    pushScriptData('dyingState');
end

--Por motivos de:
--O mobile não tanka usar FileSystem.readDirectory, então, ao invés de fazer uma array com multiplos scripts
--Preferi fazer um code em lua que é capaz de chamar os scripts adicionais caso eles existam.
