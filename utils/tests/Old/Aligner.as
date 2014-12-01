package  {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import util.*;
	
	public class Aligner extends MovieClip {
		
		public var $container:MovieClip = new MovieClip();
		public var smallMc:MovieClip;
		public var largeMc:MovieClip;
		
		public function Aligner() {
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		///////////////////////////////////////
		// PRIVATE ////////////////////////////
		///////////////////////////////////////
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild($container);
			
			AlignUtil.align(smallMc, largeMc.getBounds(this), "bottom", "left", DisplayUtil.getRealBounds(smallMc, this));
			
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