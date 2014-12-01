package util {
	
import flash.display.DisplayObjectContainer;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

/**
 * TextUtil 1.0
 */
public class TextUtil {
	
	/**
	 * Decreases the font size of a textfield to fit specified bounds.
	 * 
	 * @param	textField
	 * @param	scope
	 * @param	bounds
	 * @return	A text format with the new size.
	 */
	public static function autosize(textField:TextField, scope:DisplayObjectContainer, bounds:Rectangle):TextFormat {
		
		if (!textField) throw new ArgumentError("Error: Null TextField");
		if (!scope) throw new ArgumentError("Error: Scope doesn't exist for" + textField + " (" + textField.name + ")");
		if (bounds.width < 3 || bounds.height < 3) throw new ArgumentError("Error: Specified bounds are too small: " + bounds);
		if (textField.autoSize == "none") throw new ArgumentError("Error: Textfield autoSize is set to 'none'");
		
		var f:TextFormat = textField.getTextFormat();
		
		var realBounds:Rectangle = DisplayUtil.getRealBounds(textField, scope);
		
		if (realBounds.width < textField.textWidth)
			bounds.width -= (textField.textWidth - realBounds.width);
		if (realBounds.height < textField.textHeight)
			bounds.height -= (textField.textHeight - realBounds.height);
		
		while (textField.textWidth > bounds.width || textField.textHeight > bounds.height) {
			f.size = int(f.size) - 1;
			textField.setTextFormat(f);
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