package backend_specifics;
/**
 * Class for Windows-only functions, such as transparent windows, message boxes, and more.
 * Does not have any effect on other platforms.
 */
class NativeAPI {
	@:dox(hide) public static function registerAudio() {
		#if windows
		backend_specifics.Windows.registerAudio();
		#end
	}
}