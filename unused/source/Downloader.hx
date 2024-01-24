import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.OutputProgressEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.ByteArray;

class Downloader extends EventDispatcher
{

    private var file:File;
    private var fileStream:FileStream;
    private var url:String;
    private var urlStream:URLStream;

    private var waitingForDataToWrite:Bool = false;

    public function new()
    {
        super();
        urlStream = new URLStream();

        urlStream.addEventListener(Event.OPEN, onOpenEvent);
        urlStream.addEventListener(ProgressEvent.PROGRESS, onProgressEvent); 
        urlStream.addEventListener(Event.COMPLETE, onCompleteEvent);

        fileStream = new FileStream();
        fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler);

    }

    public function download(formUrl:String, toFile:File):Void {
        this.url = formUrl;
        this.file = toFile;
        fileStream.openAsync(file, FileMode.WRITE);
        urlStream.load(new URLRequest(url));
    }

    private function onOpenEvent(event:Event):Void {
        waitingForDataToWrite = true;
        dispatchEvent(event.clone());
    }

    private function onProgressEvent(event:ProgressEvent):Void {
        if (waitingForDataToWrite) {
            writeToDisk();
            dispatchEvent(event.clone());
        }
    }

    private function writeToDisk():Void {
        var buffer:ByteArray = new ByteArray();
        while (urlStream.bytesAvailable > 0) {
            var chunkSize:Int = Std.int(Math.min(urlStream.bytesAvailable, 4096));
            urlStream.readBytes(buffer, buffer.length, chunkSize);
        }
        fileStream.writeBytes(buffer, 0, buffer.length);
        fileStream.close();
    }

    private function onCompleteEvent(event:Event):Void {
        if (urlStream.bytesAvailable > 0) {
            writeToDisk();
        }
        fileStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler);
        dispatchEvent(event.clone());
        dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_COMPLETE, url, file));
    }

    private function writeProgressHandler(event:OutputProgressEvent):Void {
        dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, event.bytesPending, event.bytesTotal));
    }

}
