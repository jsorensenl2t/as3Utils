package util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	public class BitmapUtil {
		
		public static function bitmap(bmd:BitmapData, smoothing:Boolean=true, pixelSnapping:String=PixelSnapping.AUTO):Bitmap {
			return new Bitmap(bmd, pixelSnapping, smoothing);
		}
		private static function snapshot(source:DisplayObject, alpha:Boolean = true, cropAlpha:Boolean = true, matrix:Matrix=null, pad:uint = 0, bounds:Rectangle = null, fill:uint = 0,smoothing:Boolean=false):BitmapData {
			if (!src) throw new ArgumentError("DisplayObject is null.");
			var scope = (!source.parent) ? source : source.parent;
			if (!bounds) bounds = source.getBounds(scope);
			var b : BitmapData = new BitmapData(int(bounds.width + 0.5) + (pad * 2), int(bounds.height + 0.5) + (pad * 2), alpha, fill);
			b.draw(scope, new Matrix(1, 0, 0, 1, -bounds.x + pad, -bounds.y + pad),null,null,null,smoothing);
			if (cropAlpha && alpha) b = crop(b, b.getColorBoundsRect(0xFF000000, 0, false), pad);
			return b;
		}
		public static function crop(bmp:BitmapData, rect:Rectangle, pad:int = 0):BitmapData {
			var bmp : BitmapData = new BitmapData(rect.width+(pad*2), rect.height+(pad*2), bmp.transparent);
			bmp.copyPixels(bmp, rect, new Point(pad,pad));
			return bmp;
		}
		
		public static function rescale(bmp:BitmapData, ratio:Number, smoothing:Boolean = true):BitmapData {
			return getResizedBitmapData(bmp, Math.round(bmp.width * ratio), Math.round(bmp.height * ratio), smoothing);
		}
		
		public static function resize(bmp:BitmapData, width:uint, height:uint, respectRatio:Boolean = true, smoothing:Boolean = true):BitmapData {
			if (!respectRatio) {
				return getResizedBitmapData(bmp, width, height, smoothing);
			} else {
				var ratio:Number = Math.min(width / bmp.width, height / bmp.height);
				return getResizedBitmapData(bmp, Math.round(bmp.width * ratio), Math.round(bmp.height * ratio), smoothing);
			}
		}
		public static function fill(bmp : BitmapData, width : uint, height : uint, align : String = "TL", smoothing : Boolean = true) : BitmapData {
			var ratio:Number = Math.max(width / bmp.width, height / bmp.height);
			var bd:BitmapData = getResizedBitmapData(bmp, Math.round(bmp.width * ratio), Math.round(bmp.height * ratio), smoothing);
			// crop
			var x : uint = 0;
			var y : uint = 0;
			switch(align.charAt(1)) {
				case "L": 
					x = 0; 
					break;
				case "C": 
					x = (bd.width - width) / 2; 
					break;
				case "R": 
					x = bd.width - width; 
					break;
			}
			switch(align.charAt(0)) {
				case "T": 
					y = 0; 
					break;
				case "M": 
					y = (bd.height - height) / 2; 
					break;
				case "B": 
					y = bd.height - height; 
					break;
			}
			var r : Rectangle = new Rectangle(x, y, width, height);
			return crop(bd, r);
		}
		private static function getResizedBitmapData(bmp : BitmapData, width : uint, height : uint, smoothing : Boolean) : BitmapData {
			var bmpData:BitmapData = new BitmapData(width, height, bmp.transparent, 0x00FFFFFF);
			var scaleMatrix:Matrix = new Matrix(width / bmp.width, 0, 0, height / bmp.height, 0, 0);
			bmpData.draw(bmp, scaleMatrix, new ColorTransform(), null, null, smoothing);
			return bmpData;
		}
	}
}