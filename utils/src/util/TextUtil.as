package util {
import flash.text.TextField;
import flash.text.TextFormat;

public class TextUtil {
	public static function autosize(txt:TextField, maxW:Number, maxH:Number):TextFormat {
		var maxTextWidth:Number = maxW;
		var maxTextHeight:Number = maxH;
		var f:TextFormat = txt.getTextFormat();
		while (txt.textWidth > maxTextWidth || txt.textHeight > maxTextHeight) {
			f.size = int(f.size)- 1;
			txt.setTextFormat(f);
		}
		return f;
	}
	public static function changeSize(txt:TextField, size:Number) {
		var tf:TextFormat = txt.getTextFormat();
		tf.size = size;
		txt.setTextFormat(tf);
	}
	public static function changeColor(txt:TextField, color:Number) {
		var tf:TextFormat = txt.getTextFormat();
		tf.color = color;
		txt.setTextFormat(tf);
	}
	public static function changeLetterSpacing(txt:TextField, spacing:Number) {
		var tf:TextFormat = txt.getTextFormat();
		tf.letterSpacing = spacing;
		txt.setTextFormat(tf);
	}
}}