package util {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	/**
	 * DrawUtil 1.0
	 */
	public class DrawUtil {
		public static function drawRect(rect:Rectangle, target:DisplayObjectContainer=null, fillColor:Number = 0xF91559, fillAlpha:Number = .2, borderColor:Number = 0xF91559, borderAlpha:Number = .6):MovieClip {
			var r:Shape = new Shape();
			r.graphics.lineStyle(1, borderColor, borderAlpha, false);
			r.graphics.beginFill(fillColor, fillAlpha);
			r.graphics.drawRect(0, 0, rect.width, rect.height);
			r.graphics.endFill();
			var mc:MovieClip = new MovieClip();
			mc.x = rect.x;
			mc.y = rect.y;
			mc.addChild(r);
			if (target) target.addChild(mc);
			return mc;
		}
	}
}