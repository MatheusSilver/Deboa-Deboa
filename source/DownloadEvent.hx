import flash.events.Event;
import flash.filesystem.File;

class DownloadEvent extends Event {
    public static var DOWNLOAD_COMPLETE:String = "DownloadComplete";

    public var url:String;
    public var file:File;

    public function new(type:String, url:String, file:File) {
        super(type, true);
        this.url = url;
        this.file = file;
    }

    override public function toString():String {
        return super.toString() + ": " + url + " -> " + file.nativePath;
    }
}