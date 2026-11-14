import flixel.FlxG;

class PreCacheManager
{
    private var sounds:Array<String>;
    private var images:Array<String>;
    private var characters:Array<Character>;
    private var music:Array<String>;
    private var assetsToLoad:Int = 0;
    private var onLoadComplete:Void->Void;

    private var batchStarted:Bool = false;

    public var cancelled(default, null):Bool = false;

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
        characters = [];
    }

    public function requestSound(key:String):Void
    {
        if (batchStarted)
            Paths.sound(key);
        else
            sounds.push(key);
    }

    public function requestCharacter(char:Character):Void
    {
        if (batchStarted)
            char.onImageLoaded();
        else
            characters.push(char);
    }

    public function requestImage(key:String):Void
    {
        if (batchStarted)
            Paths.image(key);
        else
            images.push(key);
    }

    public function requestMusic(key:String):Void
    {
        if (batchStarted)
            Paths.music(key);
        else
            music.push(key);
    }

    public function loadAssets():Void
    {
        batchStarted = true;
        assetsToLoad = sounds.length + images.length + music.length + characters.length;

        if (assetsToLoad == 0)
        {
            finish();
            return;
        }

        for (k in characters)
            Paths.preloadImage(k.imageFile, this, "shared", k);

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

    public function cancel():Void
    {
        cancelled = true;
        onLoadComplete = null;
    }

    private function finish():Void
    {
        if (this.onLoadComplete != null)
            onLoadComplete();
    }
}
