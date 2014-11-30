package  {
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import util.*;

	public class ImageResampling extends MovieClip {
		
		[Embed(source = "test.png", compression = "true", quality = "80")]
		public static const CarImg:Class;
		public var car:BitmapData;
		
		
		public var container:MovieClip = new MovieClip();
		public var sldSize:Slider;
		public var sldSizeTxt:Label;
		public var sldBlur:Slider;
		public var sldBlurTxt:Label;
		
		public var IMAGE_WIDTH:Number;
		
		public function ImageResampling() {
			super();
			car = (new CarImg() as Bitmap).bitmapData;
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			addChild(container);
			sldSize.addEventListener(SliderEvent.CHANGE, _update);
			sldBlur.addEventListener(SliderEvent.CHANGE, _update);
			trace();
			//_update();
		}
		
		private function _update(e:Event=null):void {
			DisplayUtil.removeAllChildren(container);
			IMAGE_WIDTH = sldSize.value;
			
			var car1:Bitmap = resize(car, IMAGE_WIDTH, "v1");
			var car2:Bitmap = resize(car, IMAGE_WIDTH, "v2");
			car2.x = car1.width + 5;
			container.addChild(car1);
			container.addChild(car2);
		}
		
		private function resize(data:BitmapData, width:Number, method:String) {
			var bd:BitmapData;
			     if (method == "v1") bd = BitmapUtil.resize(data, width, 10000,true,true);
			else if (method == "v2") bd = JacResize.resizeImage(data, width, 10000);
			else throw new ArgumentError("Invalid resize method passed.");
			return(BitmapUtil.makeBitmap(bd));
		}
	}

}