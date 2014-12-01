package  {
	
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import util.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.filters.BlurFilter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	
	public class ResamplingTest extends MovieClip {
		
		public var $original:MovieClip;
		public var container:MovieClip = new MovieClip();
		public var src:MovieClip;
		public var tf:TextField;
		
		public var sldPrescale:Slider;
		public var sldPrescaleTxt:Label;
		public var sldFontSize:Slider;
		public var sldFontSizeTxt:Label;
		public var sldBlur:Slider;
		public var sldBlurTxt:Label;
		public var sldBlurQuality:Slider;
		public var sldBlurQualityTxt:Label;
		public var comboPixelsnapping:ComboBox;
		public var chkResize:CheckBox;
		public var chkSmoothingBmp:CheckBox;
		public var chkSmoothingBmd:CheckBox;
		public var chkSampling:CheckBox;
		public var chkBounds:CheckBox;
		public var lineHeightTxt:Label;
		
		public var FIXED_WIDTH:Number;
		public var FIXED_WIDTH_TEXTFIELD:Number;
		public var RESIZE_TEXT:Boolean = false;
		public var RESIZE_WIDTH_TO:Number = 171;
		public var RESIZE_PRE_SCALING:Number = 1;
		public var BLUR_AMOUNT:Number = 0;
		public var BLUR_QUALITY:Number = 5;
		public var SMOOTHING:Boolean = true;
		public var SMOOTHING_BMD:Boolean = true;
		public var SAMPLING:Boolean = false;
		public var PIXEL_SNAPPING:String = PixelSnapping.AUTO;
		public var SHOW_BOUNDS:Boolean = true;
		public var FONT_SIZE:int = 9;
		
		public function ResamplingTest() {
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			src 	= $original;
			tf 		= $original.tf
			src.x 	= -500;
			src.y 	= -500;
			
			tf.autoSize 	= TextFieldAutoSize.LEFT;
			tf.width 		= tf.width;
			tf.multiline 	= true;
			tf.wordWrap 	= true;
			
			container.x = 120;
			container.y = 120;
			addChild(container);
			container.buttonMode = true;
			
			comboPixelsnapping.selectedIndex = 0;
			
			_update();
			
			container.addEventListener(MouseEvent.MOUSE_DOWN,	_onDown);
			container.addEventListener(MouseEvent.MOUSE_UP, 	_onUp);
			
			sldPrescale.addEventListener(SliderEvent.CHANGE, 	_update);
			sldBlur.addEventListener(SliderEvent.CHANGE, 		_update);
			sldBlurQuality.addEventListener(SliderEvent.CHANGE, _update);
			comboPixelsnapping.addEventListener(Event.CHANGE, 	_update);
			chkResize.addEventListener(Event.CHANGE, 			_update);
			chkSmoothingBmp.addEventListener(Event.CHANGE, 		_update);
			chkSmoothingBmd.addEventListener(Event.CHANGE, 		_update);
			chkSampling.addEventListener(Event.CHANGE, 			_update);
			chkBounds.addEventListener(Event.CHANGE, 			_update);
			sldFontSize.addEventListener(SliderEvent.CHANGE,	_update);
			
		}
		
		public function _onDown(e:MouseEvent) {
			DisplayUtil.removeAllChildren(container);
			var mc:MovieClip = getSnapshot(tf, false, 0, 1, 0, 0, true, false, false, "auto", true);
			container.addChild(mc);
		}
		
		public function _onUp(e:MouseEvent) {
			_update();
		}
		
		public function _update(e:Event=null) {
			DisplayUtil.removeAllChildren(container);
			
			RESIZE_TEXT 		= chkResize.selected;
			RESIZE_PRE_SCALING 	= sldPrescale.value;
			BLUR_AMOUNT 		= sldBlur.value;
			BLUR_QUALITY 		= sldBlurQuality.value;
			SMOOTHING 			= chkSmoothingBmp.selected;
			SMOOTHING_BMD 		= chkSmoothingBmd.selected;
			SAMPLING 			= chkSampling.selected;
			PIXEL_SNAPPING 		= comboPixelsnapping.value;
			SHOW_BOUNDS 		= chkBounds.selected;
			FONT_SIZE			= sldFontSize.value;
			
			var format:TextFormat = tf.getTextFormat();
			format.size = FONT_SIZE;
			
			FIXED_WIDTH = getSnapshot(tf, false, 0, 1, 0, 0, true, false, false, "auto", false).width;
			
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
			
			sldFontSizeTxt.text		= "Font size: " + FONT_SIZE;
			sldPrescaleTxt.text 	= sldPrescale.value + "x";
			sldBlurTxt.text 		= sldBlur.value + "px";
			sldBlurQualityTxt.text 	= sldBlurQuality.value + "x";
			
			var mc:MovieClip = getSnapshot(tf, RESIZE_TEXT, FIXED_WIDTH, RESIZE_PRE_SCALING, BLUR_AMOUNT, BLUR_QUALITY, SMOOTHING, SAMPLING, SMOOTHING_BMD, PIXEL_SNAPPING, SHOW_BOUNDS);
			container.addChild(mc);
			
			
		}
		
		
		public static function getSnapshot(obj:DisplayObject, resize:Boolean, width:Number, prescale:Number, blur:Number, blurq:Number=3, smoothing:Boolean=true, sampling=false, drawSmoothing:Boolean=false, pixelSnapping:String=PixelSnapping.AUTO, showBounds:Boolean=false):MovieClip {
			var sbuf:Number;
			if (prescale > 1) {
				sbuf = obj.scaleX;
				obj.scaleX = prescale;
				obj.scaleY = prescale;
			}
			var bmd:BitmapData = BitmapUtil.getBitmapData(obj, true, true,5*prescale, 0, drawSmoothing, null);
			if(blur > 0) bmd.applyFilter(bmd.clone(), new Rectangle(0, 0, bmd.width, bmd.height), new Point(), new BlurFilter(blur,blur,blurq));
			if (resize) {
				bmd = BitmapUtil.resize(bmd, width, 100000,true,drawSmoothing,sampling);
			}
			var bm:Bitmap = new Bitmap(bmd, pixelSnapping, smoothing);
			var mc:MovieClip = new MovieClip();
			mc.addChild(bm);
			if(showBounds) mc.addChild(DrawUtil.drawRectIntoMc(bm.getBounds(mc), 1, 0, 0, 0xFF0000, .5));
			if (prescale > 1) {
				obj.scaleX = sbuf;
				obj.scaleY = sbuf;
			}
			return mc;
		}
		
	}
	
}