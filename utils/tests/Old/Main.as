package  {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends MovieClip {
		
		public var $container:MovieClip = new MovieClip();
		
		
		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		///////////////////////////////////////
		// PRIVATE ////////////////////////////
		///////////////////////////////////////
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild($container);
			
			
			
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