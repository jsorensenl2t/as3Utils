package util {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Rectangle;
public class DrawUtil {
	public static function drawRectIntoMc(rect:Rectangle, alpha:Number = 1, fillColor:Number = 0xCA3349, fillAlpha:Number = 1, borderColor:Number = 0x000000, borderAlpha:Number = 0):MovieClip {
		var r:Shape = new Shape();
		r.graphics.lineStyle(1, borderColor, borderAlpha, false);
		r.graphics.beginFill(fillColor, fillAlpha);
		r.graphics.drawRect(0, 0, rect.width, rect.height);
		r.graphics.endFill();
		var mc:MovieClip = new MovieClip();
		mc.x = rect.x;
		mc.y = rect.y;
		mc.alpha = alpha;
		mc.addChild(r);
		return mc;
	}
	public static function drawRectIntoMcWxH(x:Number, y:Number, w:Number, h:Number, alpha:Number = 1, fillColor:Number = 0x13D9AC, fillAlpha:Number=1, borderColor:Number = 0x0D8E72, borderAlpha:Number = 0):MovieClip {
		var rect:Rectangle = new Rectangle(x, y, w, h);
		return drawRectIntoMc(rect,alpha,fillColor,fillAlpha,borderColor,borderAlpha);
	}
}}