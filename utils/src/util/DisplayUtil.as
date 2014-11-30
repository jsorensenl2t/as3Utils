package util {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	public class DisplayUtil {
		public static function removeAllChildren(container:DisplayObjectContainer, leave:int = 0):void {
			while (container.numChildren > leave) {
				container.removeChildAt(leave);
			}
		}
	}
}