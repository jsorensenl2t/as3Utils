package com.l2tmedia.util {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * DisplayUtil 1.0
	 */
	
	public class DisplayUtil {
		/**
		 * 
		 * @param	The display object to empty
		 * @param	The amount of children to leave
		 */
		public static function removeAllChildren(container:DisplayObjectContainer, leave:int = 0):void {
			while (container.numChildren > leave) {
				container.removeChildAt(leave);
			}
		}
		/**
		 * Resizes a DisplayObject to the specified width and height, optionally preserving it's aspect ratio.
		 * @param	A display object
		 * @param	Desired width
		 * @param	Desired height
		 * @param	Whether to maintain the display object's aspect ratio
		 */
		public static function resize(input:DisplayObject, w:uint, h:uint, maintainAspectRatio:Boolean = true):void {
			
			var bounds:Rectangle = DisplayUtil.getRealBounds(input, input.parent);
			var ratio:Number = Math.min(w / bounds.width, h / bounds.height);
			
			if (maintainAspectRatio) {
				input.width  = Math.round(input.width * ratio);
				input.height = Math.round(input.height * ratio);
			} else {
				input.width = w;
				input.height = h;
			}
		}
		/**
		 * Resizes a DisplayObject to the specified width and height (using scaleX and scaleY).
		 * @param	A display object
		 * @param	Desired width
		 * @param	Desired height
		 * @param	Whether to maintain the display object's aspect ratio
		 */
		public static function rescale(input:DisplayObject, w:uint, h:uint, maintainAspectRatio:Boolean = true):void {
			var bounds:Rectangle = DisplayUtil.getRealBounds(input, input.parent);
			if (maintainAspectRatio) input.scaleX = input.scaleY = Math.min(w / bounds.width, h / bounds.height);
			else {
				input.scaleX = w / bounds.width;
				input.scaleY = h / bounds.height;
			}
		}
		
		public static function getRealBounds(obj:DisplayObject, targetCoordinateSpace:DisplayObject, safeMargin:Number = 20, pad:uint = 0): Rectangle {
			
			// This is like DisplayObject.getBounds(), but correct
			// Safe margin does not expand the size, but should be as big as necessary - some items (like bottom of some fonts) fall outside the getBounds margin
			
			var rect:Rectangle = obj.getBounds(obj);
			
			var rx:Number = rect.x;
			var ry:Number = rect.y;
			var rw:Number = rect.width * obj.scaleX;
			var rh:Number = rect.height * obj.scaleY;
			
			if (rw <= 0) rw = 1;
			if (rh <= 0) rh = 1;
			
			var bmp:BitmapData = new BitmapData(Math.ceil(rw + safeMargin * 2 * obj.scaleX), Math.ceil(rh + safeMargin * 2 * obj.scaleY), true, 0x00000000);
			
			var mtx:Matrix = new Matrix();
			mtx.scale(obj.scaleX, obj.scaleY);
			mtx.translate(safeMargin * obj.scaleX, safeMargin * obj.scaleY);
			mtx.translate(-rx * obj.scaleX, -ry * obj.scaleY);
			bmp.draw(obj, mtx);
			
			// Remove contents
			var rr:Rectangle = bmp.getColorBoundsRect(0xff000000, 0x00000000, false);
			
			bmp.dispose();
			bmp = null;
			
			var fRect:Rectangle = obj.getBounds(targetCoordinateSpace);
			fRect.x += rr.x - safeMargin * obj.scaleX;
			fRect.y += rr.y - safeMargin * obj.scaleY;
			fRect.x -= pad;
			fRect.y -= pad;
			fRect.width = rr.width + (pad * 2);
			fRect.height = rr.height + (pad * 2);
			
			return fRect;
		}
	}
}