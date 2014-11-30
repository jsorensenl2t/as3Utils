package  {
	import fl.controls.CheckBox;
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import util.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	public class ResamplingTest2 extends MovieClip {
		
		public var $car:MovieClip;
		public var $text:MovieClip;
		public var tfmc:MovieClip;
		public var tf:TextField;
		public var carbmd:BitmapData;
		public var carbmp:Bitmap;
		public var container:MovieClip = new MovieClip();
		
		public var sldSampling:Slider;
		public var sldSamplingTxt:Label;
		public var sldBlur:Slider;
		public var sldBlurQuality:Slider;
		public var sldFontSize:Slider;
		public var chkResize:CheckBox;
		
		
		public var CF_WIDTH:Number;
		public var CF_SAMPLING:Number;
		public var CF_RESIZE:Boolean;
		
		[Embed(source = "test.png", compression = "true", quality = "80")]
		public static const CarImage:Class;
		
		
		public function ResamplingTest2() {
			
			carbmd = (new CarImage() as Bitmap).bitmapData;
			carbmp = BitmapUtil.makeBitmap(carbmd, true);
			tfmc = $text;
			tf = $text.tf;
			tfmc.x = 0;
			tfmc.y = 0;
			
			var t1:BitmapData;
			t1 = BitmapUtil.getBitmapData(tfmc, true, true, 0, 0x00FFFFFF, true, null);
			CF_WIDTH = t1.width;
			t1.dispose();
			
			tf.multiline = true;
			tf.wordWrap = true;
			
			addEventListener(Event.ADDED_TO_STAGE, _init);
			
		}
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			addChild(container);
			container.x = 30;
			container.y = 30;
			container.addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
			container.addEventListener(MouseEvent.MOUSE_UP, _onUp);
			container.buttonMode = true;
			sldSampling.addEventListener(SliderEvent.CHANGE, _update);
			sldBlur.addEventListener(SliderEvent.CHANGE, _update);
			sldBlurQuality.addEventListener(SliderEvent.CHANGE, _update);
			sldFontSize.addEventListener(SliderEvent.CHANGE, _update);
			chkResize.addEventListener(Event.CHANGE, _update);
			_update();
		}
		
		private function _onUp(e:MouseEvent):void {
			_update();
		}
		
		private function _onDown(e:MouseEvent):void {
			CF_SAMPLING = 1;
			//CF_RESIZE = true;
			sldSamplingTxt.text = CF_SAMPLING + "x";
			redraw();
		}
		
		private function _update(e:Event=null):void {
			CF_SAMPLING = sldSampling.value;
			
			
			var fmt:TextFormat = tf.getTextFormat();
			fmt.size = sldFontSize.value;
			tf.defaultTextFormat = fmt;
			tf.setTextFormat(fmt);
			
			CF_RESIZE = chkResize.selected;
			
			
			
			sldSamplingTxt.text = CF_SAMPLING + "x";
			redraw();
		}
		
		public function redraw():void {
			
			DisplayUtil.removeAllChildren(container);
			
			tfmc.visible = true;
			var h:Number = 10000;
			container.addChild(tfmc);
			tfmc.scaleX = tfmc.scaleY = CF_SAMPLING;
			var t2:BitmapData = BitmapUtil.getBitmapData(tfmc, true, true, 0, 0x00FF0000, true, null);
			if(CF_RESIZE) t2 = JacResize.resizeImage(t2, CF_WIDTH, h);
			var b:Bitmap = new Bitmap(t2);
			var g:MovieClip = DrawUtil.drawRectIntoMc(new Rectangle(0, 0, b.width, b.height), .2);
			b.x = g.x = 0;
			b.y = g.y = 0;
			tfmc.visible = false;
			container.addChild(b);
			
			//container.addChild(g);
			
		}
		
	}

}