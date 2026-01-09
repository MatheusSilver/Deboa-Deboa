import flixel.FlxG;

class PreCacheManager
{
    private var sounds:Array<String>;
    private var images:Array<String>;
    private var music:Array<String>;
    private var assetsToLoad:Int = 0;
    private var onLoadComplete:Void->Void;

    public function new(onLoadComplete:Void->Void)
    {
        clearLoadList();
        this.onLoadComplete = onLoadComplete;
    }

    inline private function clearLoadList():Void
    {
        sounds = [];
        images = [];
        music  = [];
    }

    inline public function requestSound(key:String):Void
        sounds.push(key);

    inline public function requestImage(key:String):Void
        images.push(key);

    inline public function requestMusic(key:String):Void
        music.push(key);

    public function loadAssets():Void
    {
        assetsToLoad = sounds.length + images.length + music.length;

        if (assetsToLoad == 0)
        {
            finish();
            return;
        }

        for (k in sounds)
            Paths.preloadSound(k, "sounds", this);

        for (k in music)
            Paths.preloadSound(k, "music", this);

        for (k in images)
            Paths.preloadImage(k, this);

        clearLoadList();
    }

    public function decreaseLoadedObjects():Void
    {
        assetsToLoad--;

        if (assetsToLoad < 0)
        {
            //Se isso aqui rodar, é porque eu fiz muita merda...
            FlxG.log.error("foram carregados mais assets do que o esperado! " + this.assetsToLoad);
            return;
        }

        // E se isso aqui não rodar, é porque novamente eu fiz muita muita merda...
        if (assetsToLoad == 0)
            finish();
    }

    private function finish():Void
    {
        if (this.onLoadComplete != null)
            onLoadComplete();
    }
}
