package util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * Image utilities that help to resize images, take snapshots of display
	 * objects, and other various helpers which are useful when working with
	 * images.
	 */
	public class JacResize
	{
		private static const IDEAL_RESIZE_PERCENT:Number = .5;
		
		/**
		 * Makes the entire image visible at the specified width and height
		 * without distortion while maintaining the original aspect ratio.
		 */
		public static const CONSTRAIN_PROPORTIONS:String = "constrainProportions";
		
		/**
		 * Scales the image to fill the specified width and height, without
		 * distortion but centers it and fills any empty space with transparent
		 * pixels, while maintaining the original aspect ratio.
		 */
		public static const CENTER:String = "center";
		
		/**
		 * Scales the image to fill the specified width and height, without
		 * distortion but possibly with some cropping, while maintaining the
		 * original aspect ratio.
		 */
		public static const CROP:String = "crop";
		
		/**
		 * Makes the entire image visible in the specified width and height
		 * without trying to preserve the original aspect ratio. Distortion can
		 * occur.
		 */
		public static const STRETCH:String = "stretch";
		
		
		/**
		 * Takes a snapshot of a display object or bitmap data object. The
		 * snapshot may be a subsection of the whole as defined by
		 * <code>area</code> and may be resized.
		 * 
		 * @param The display object or bitmap data object to take a snapshot of.
		 * @param The area which will be snapshotted. If null the entire object
		 * will be used as the area.
		 * @param The size of the snapshot to be returned. If null then the
		 * original size will be used.
		 * @param Whether the snapshot should keep proportions when resizing or
		 * resize to fit the size exactly.
		 */
		public static function snapshot(source:IBitmapDrawable, width:uint = 0, height:uint = 0, resizeStyle:String = "constrainProportions", area:Rectangle = null):BitmapData
		{
			var bitmapData:BitmapData = source as BitmapData;
			if (area) {
				bitmapData = new BitmapData(area.width, area.height, true, 0);
				var matrix:Matrix = new Matrix();
				matrix.translate(-area.x, -area.y);
				bitmapData.draw(source, matrix);
			} else if (!bitmapData) {
				bitmapData = new BitmapData(DisplayObject(source).width, DisplayObject(source).height, true, 0);
				bitmapData.draw(source);
			}
			if (width || height) {
				var temp:BitmapData = bitmapData;
				bitmapData = resizeImage(temp, width, height, resizeStyle);
				if (temp != source) {
					temp.dispose();
				}
			}
			return bitmapData;
		}
		
		
		/**
		 * Return a new bitmap data object resized to the provided size.
		 * 
		 * @param The source bitmap data object to resize.
		 * @param The size the bitmap data object needs to be or needs to fit
		 * within.
		 * @param Whether to keep the proportions of the image or allow it to
		 * squish into the size.
		 * 
		 * @return A resized bitmap data object.
		 */
		public static function resizeImage(source:BitmapData, width:uint, height:uint, resizeStyle:String = "constrainProportions"):BitmapData
		{
			var bitmapData:BitmapData;
			var crop:Boolean = false;
			var fill:Boolean = false;
			var constrain:Boolean = false;
			switch (resizeStyle) {
				case CROP: // these are supposed to not have break; statements
					crop = true;
				case CENTER:
					fill = true;
				case CONSTRAIN_PROPORTIONS:
					constrain = true;
					break;
				case STRETCH:
					fill = true;
					break;
				default:
					throw new ArgumentError("Invalid resizeStyle provided. Use options available on the ImageResizeStyle lookup class");
			}
			
			// Find the scale to reach the final size
			var scaleX:Number = width/source.width;
			var scaleY:Number = height/source.height;
			
			if (width == 0 && height == 0) {
				scaleX = scaleY = 1;
				width = source.width;
				height = source.height;
			} else if (width == 0) {
				scaleX = scaleY;
				width = scaleX * source.width;
			} else if (height == 0) {
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
			while (nextScaleX < 1) nextScaleX /= IDEAL_RESIZE_PERCENT;
			while (nextScaleY < 1) nextScaleY /= IDEAL_RESIZE_PERCENT;
			
			if (scaleX < IDEAL_RESIZE_PERCENT) nextScaleX *= IDEAL_RESIZE_PERCENT;
			if (scaleY < IDEAL_RESIZE_PERCENT) nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			bitmapData = new BitmapData(Math.round(originalWidth*nextScaleX), Math.round(originalHeight*nextScaleY), true, 0);
			bitmapData.draw(source, new Matrix(nextScaleX, 0, 0, nextScaleY, originalX*nextScaleX, originalY*nextScaleY), null, null, null, true);
			
			nextScaleX *= IDEAL_RESIZE_PERCENT;
			nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			while (nextScaleX >= scaleX || nextScaleY >= scaleY) {
				var actualScaleX:Number = nextScaleX >= scaleX ? IDEAL_RESIZE_PERCENT : 1;
				var actualScaleY:Number = nextScaleY >= scaleY ? IDEAL_RESIZE_PERCENT : 1;
				var temp:BitmapData = new BitmapData(Math.round(bitmapData.width*actualScaleX), Math.round(bitmapData.height*actualScaleY), true, 0);
				temp.draw(bitmapData, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
				bitmapData.dispose();
				nextScaleX *= IDEAL_RESIZE_PERCENT;
				nextScaleY *= IDEAL_RESIZE_PERCENT;
				bitmapData = temp;
			}
			
			return bitmapData;
		}
	}
}