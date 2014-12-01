package  {
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import util.*;
	import com.isnowfox.core.image.AreaAvgScale;
	import flash.display.StageQuality;

	public class ImageResampling extends MovieClip {
		
		[Embed(source = "test.png", compression = "true", quality = "80")]
		public static const CarImg:Class;
		[Embed(source = "test2.png", compression = "true", quality = "80")]
		public static const TextImg:Class;
		
		public var car:BitmapData;
		public var textimg:BitmapData;
		public var textimage:MovieClip;
		public var textimagebd:BitmapData;
		public var testmc:MovieClip;
		
		public var container:MovieClip = new MovieClip();
		public var sldSize:Slider;
		public var sldSizeTxt:Label;
		public var sldBlur:Slider;
		public var sldBlurTxt:Label;
		public var btnReset:Button;
		
		public var IMAGE_TARGET:DisplayObject;
		public var IMAGE_WIDTH:Number;
		public var ORIGINAL_WIDTH:Number;
		
		public function ImageResampling() {
			super();
			//stage.quality = StageQuality.BEST;
			car = (new CarImg() as Bitmap).bitmapData;
			textimg = (new TextImg() as Bitmap).bitmapData;
			textimage = (new TextMovie() as MovieClip);
			textimagebd = BitmapUtil.snapshot(textimage);
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			addChild(container);
			
			IMAGE_TARGET 	= textimage;
			ORIGINAL_WIDTH 	= IMAGE_TARGET.width;
			IMAGE_WIDTH 	= ORIGINAL_WIDTH;
			
			sldSize.addEventListener(SliderEvent.CHANGE, _onUpdateSize);
			btnReset.addEventListener(MouseEvent.CLICK, _onReset);
			_update();
		}
		
		private function _onUpdateSize(e:SliderEvent):void {
			IMAGE_WIDTH = sldSize.value;
			_update();
		}
		
		private function _onReset(e:MouseEvent):void {
			IMAGE_WIDTH = ORIGINAL_WIDTH;
			_update();
		}
		
		private function _update():void {
			
			DisplayUtil.removeAllChildren(container);

			var mc:MovieClip = textimage;
			mc.scaleX = 1;
			mc.rotation = 75;
	
			var matrix:Matrix = mc.transform.matrix;
			var b1:Rectangle = mc.getBounds(mc);
			var b2:Rectangle = b1.clone();
			
			b2.width  = b2.width + b2.x;
			b2.height = b2.height + b2.y;
			b2.x = 0;
			b2.y = 0;

			RectangleUtil.transformRect(b1, matrix, b1);
			RectangleUtil.transformRect(b2, matrix, b2);
			
			trace("b1:" + b1);
			trace("b2:" + b2);
			
			var oy:Number = b2.height - b1.height;
			var ox:Number = b2.width - b1.width;
		
			matrix.translate(-b2.x, -b2.y);
			
			var b:BitmapData = new BitmapData(b2.width, b2.height, false, 0xAAAAAA);
			b.draw(mc, matrix, null, null, null, false);
			
			container.addChild(BitmapUtil.bitmap(b));
			b1.x = 0;
			b1.y = 0;
			b2.x += -b2.x;
			b2.y += -b2.y;
			container.addChild(DrawUtil.drawRectIntoMc(b1, 1, 0, 0, 0xFF0000, 1));
			container.addChild(DrawUtil.drawRectIntoMc(b2, 1, 0, 0, 0xFF00FF, 1));
			container.addChild(mc);
			mc.visible = true;
			mc.alpha = .3
			
		}
		
		private function resize(data:BitmapData, width:Number) {
			var bd:Bitmap = BitmapUtil.bitmap(BitmapUtil.resize(data, width, 10000),false);
			return bd;
		}
	}

}