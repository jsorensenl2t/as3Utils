package com.l2tmedia.util {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	/**
	 * BitmapUtil v1.0
	 */
	public class BitmapUtil {
		
		public static function snapshot(source:DisplayObject, alpha:Boolean = true, cropAlpha:Boolean = true, pad:uint = 0, bounds:Rectangle = null, fill:uint = 0xAAAAAA, smoothing:Boolean = false):BitmapData {
			// source.getBounds(source) is always going to return the actual dimensions of the object (no transformations)
			// source.getBounds(source.parent) will return dimensions + transformations applied
			if (!source) throw new ArgumentError("Input DisplayObject is null.");
			var scope = (!source.parent) ? source : source.parent; // if the object is on the displaylist, capture it from the parent container so we can get transformations
			if (!bounds) bounds = source.getBounds(scope);
			var b:BitmapData = new BitmapData(int(bounds.width + 0.5) + (pad * 2), int(bounds.height + 0.5) + (pad * 2), alpha, fill);
			b.draw(scope, new Matrix(1, 0, 0, 1, -bounds.x + pad, -bounds.y + pad), null, null, null, smoothing);
			if (cropAlpha && alpha) {
				var temp:BitmapData = b;
				b = crop(temp, temp.getColorBoundsRect(0xFF000000, 0x00000000, false), pad);
				if (temp != b) temp.dispose();
			}
			return b;
		}
		
		public static function cropAlpha(bmd:BitmapData, pad:uint=0):BitmapData {
			var temp:BitmapData = bmd;
			bmd = crop(temp, temp.getColorBoundsRect(0xFF000000, 0x00000000, false), pad);
			if (temp != bmd) temp.dispose();
			return bmd;
		}
		
		public static function bitmap(bmd:BitmapData, smoothing:Boolean = false, pixelSnapping:String = "never"):Bitmap {
			if (!bmd) throw new ArgumentError("Input BitmapData is null.");
			return new Bitmap(bmd, pixelSnapping, smoothing);
		}
		public static function crop(bmd:BitmapData, rect:Rectangle, pad:int = 0):BitmapData {
			if (!bmd) throw new ArgumentError("Input BitmapData is null.");
			var b:BitmapData = new BitmapData(rect.width + (pad * 2), rect.height + (pad * 2), bmd.transparent);
			b.copyPixels(bmd, rect, new Point(pad, pad));
			return b;
		}
		
		/**
		 * Makes the entire image visible at the specified width and height
		 * without distortion while maintaining the original aspect ratio.
		 */
		public static const RESIZE_METHOD_CONSTRAIN_PROPORTIONS:String = "constrainProportions";
		
		/**
		 * Scales the image to fill the specified width and height, without
		 * distortion but centers it and fills any empty space with transparent
		 * pixels, while maintaining the original aspect ratio.
		 */
		public static const RESIZE_METHOD_CENTER:String = "center";
		
		/**
		 * Scales the image to fill the specified width and height, without
		 * distortion but possibly with some cropping, while maintaining the
		 * original aspect ratio.
		 */
		public static const RESIZE_METHOD_CROP:String = "crop";
		
		/**
		 * Makes the entire image visible in the specified width and height
		 * without trying to preserve the original aspect ratio. Distortion can
		 * occur.
		 */
		public static const RESIZE_METHOD_STRETCH:String = "stretch";
		
		/**
		 * Return a new bitmap data object resized to the provided size.
		 * Algorithm as outlined here: http://jacwright.com/221/high-quality-high-performance-thumbnails-in-flash/
		 * 
		 * @param The source bitmap data object to resize.
		 * @param The size the bitmap data object needs to be or needs to fit
		 * within.
		 * @param Whether to keep the proportions of the image or allow it to
		 * squish into the size.
		 * 
		 * @return A resized bitmap data object.
		 */
		public static function resize(source:BitmapData, width:uint, height:uint, resizeStyle:String = "constrainProportions"):BitmapData {
			
			var idealResizePercent:Number = .5;
			var bitmapData:BitmapData;
			var crop:Boolean = false;
			var fill:Boolean = false;
			var constrain:Boolean = false;
			switch (resizeStyle) {
				case RESIZE_METHOD_CROP: // these are supposed to not have break; statements
					crop = true;
				case RESIZE_METHOD_CENTER:
					fill = true;
				case RESIZE_METHOD_CONSTRAIN_PROPORTIONS:
					constrain = true;
					break;
				case RESIZE_METHOD_STRETCH:
					fill = true;
					break;
				default:
					throw new ArgumentError("Invalid resizeStyle provided.");
			}
			// Find the scale to reach the final size
			var scaleX:Number = width/source.width;
			var scaleY:Number = height/source.height;
			
			if (width == 0 && height == 0) {
				scaleX = scaleY = 1;
				width = source.width;
				height = source.height;
			}
			else if (width == 0) {
				scaleX = scaleY;
				width = scaleX  * source.width;
			}
			else if (height == 0) { 
				scaleY = scaleX; 
				height = scaleY * source.height;
			}
			
			if (crop) {
				if (scaleX < scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			} else if (constrain) {
				if (scaleX > scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			}
			
			var originalWidth:uint = source.width;
			var originalHeight:uint = source.height;
			var originalX:int = 0;
			var originalY:int = 0;
			var finalWidth:uint = Math.round(source.width*scaleX);
			var finalHeight:uint = Math.round(source.height*scaleY);
			
			if (fill) {
				originalWidth = Math.round(width/scaleX);
				originalHeight = Math.round(height/scaleY);
				originalX = Math.round((originalWidth - source.width)/2);
				originalY = Math.round((originalHeight - source.height)/2);
				finalWidth = width;
				finalHeight = height;
			}
			
			if (scaleX >= 1 && scaleY >= 1) {
				try {
					bitmapData = new BitmapData(finalWidth, finalHeight, true, 0);
				} catch (error:ArgumentError) {
					error.message += " Invalid width and height: " + finalWidth + "x" + finalHeight + ".";
					throw error;
				}
				bitmapData.draw(source, new Matrix(scaleX, 0, 0, scaleY, originalX*scaleX, originalY*scaleY), null, null, null, true);
				return bitmapData;
			}
			
			// scale it by the IDEAL for best quality
			var nextScaleX:Number = scaleX;
			var nextScaleY:Number = scaleY;
			while (nextScaleX < 1) nextScaleX /= idealResizePercent;
			while (nextScaleY < 1) nextScaleY /= idealResizePercent;
			
			if (scaleX < idealResizePercent) nextScaleX *= idealResizePercent;
			if (scaleY < idealResizePercent) nextScaleY *= idealResizePercent;
			
			bitmapData = new BitmapData(Math.round(originalWidth*nextScaleX), Math.round(originalHeight*nextScaleY), true, 0);
			bitmapData.draw(source, new Matrix(nextScaleX, 0, 0, nextScaleY, originalX*nextScaleX, originalY*nextScaleY), null, null, null, true);
			
			nextScaleX *= idealResizePercent;
			nextScaleY *= idealResizePercent;
			
			while (nextScaleX >= scaleX || nextScaleY >= scaleY) {
				var actualScaleX:Number = nextScaleX >= scaleX ? idealResizePercent : 1;
				var actualScaleY:Number = nextScaleY >= scaleY ? idealResizePercent : 1;
				var temp:BitmapData = new BitmapData(Math.round(bitmapData.width*actualScaleX), Math.round(bitmapData.height*actualScaleY), true, 0);
				temp.draw(bitmapData, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
				bitmapData.dispose();
				nextScaleX *= idealResizePercent;
				nextScaleY *= idealResizePercent;
				bitmapData = temp;
			}
			return bitmapData;
		}
		
		public static function getLetterboxRatio(bmd:BitmapData, maxw:uint, maxh:uint):Number {
			if (!bmd) throw new ArgumentError("Input BitmapData is null.");
			return Math.min(maxw / bmd.width, maxh / bmd.height);
		}
		
		public static function getLetterboxWidthHeight(bmd:BitmapData, maxw:uint, maxh:uint):Array {
			if (!bmd) throw new ArgumentError("Input BitmapData is null.");
			var ratio:Number = getLetterboxRatio(bmd, maxw, maxh);
			return [Math.round(bmd.width * ratio), Math.round(bmd.height * ratio)];
		}
	}
}