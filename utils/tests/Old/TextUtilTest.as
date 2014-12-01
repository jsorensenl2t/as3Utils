package  {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import util.*;
	
	public class TextUtilTest extends MovieClip {
		
		public var container:MovieClip;
		public var mytext:TextField;
		
		public function TextUtilTest() {
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		///////////////////////////////////////
		// PRIVATE ////////////////////////////
		///////////////////////////////////////
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			mytext.autoSize = "left";
			TextUtil.autosize(mytext, this, container.getBounds(this));
			
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