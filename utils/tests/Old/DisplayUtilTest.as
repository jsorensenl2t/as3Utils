package  {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.StageQuality;
	import util.*;
	
	public class DisplayUtilTest extends MovieClip {
		
		public var $container:MovieClip = new MovieClip();
		public var textmc:MovieClip;
		public var largeMc:MovieClip;
		
		public function DisplayUtilTest() {
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		///////////////////////////////////////
		// PRIVATE ////////////////////////////
		///////////////////////////////////////
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild($container);
			
			
			stage.quality = StageQuality.BEST;
			DisplayUtil.rescale(textmc, 200, 60);
			AlignUtil.align(textmc, largeMc.getBounds(this) , "top", "left", DisplayUtil.getRealBounds(textmc, this));
			AlignUtil.move(textmc, 5, 5);
			
			var r:Rectangle = DisplayUtil.getRealBounds(textmc, this, 20, 0);
			var debugRect:MovieClip = DrawUtil.drawRect(r, this);
			
			AlignUtil.align(debugRect, largeMc.getBounds(this), "bottom", "center");
			
			_addListeners();
			_update();
		}
		
		private function _addListeners():void {
		
		}
		
		private function _update(e:Event=null):void {
			
		}
		
		///////////////////////////////////////
		// PUBLIC /////////////////////////////
		///////////////////////////////////////
		
		///////////////////////////////////////
		// GET / SET //////////////////////////
		///////////////////////////////////////
		
	}
}