package  {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.l2tmedia.util.*;
	
	public class AnimationTest extends MovieClip {
		
		public var $container:MovieClip = new MovieClip();
		public var smallMc:MovieClip;
		public var largeMc:MovieClip;
		
		public function AnimationTest() {
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		///////////////////////////////////////
		// PRIVATE ////////////////////////////
		///////////////////////////////////////
		
		private function _init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild($container);
			
			for (var i:int = 0, delay:Number = 0; i < this.numChildren; i++, delay+= .1) {
				var obj:DisplayObject = getChildAt(i);
				if (obj is MovieClip) {
					var a:Animator = new Animator();
					a.slideAndBlurIn(obj, { x: -200, delay:delay } );
				}
			}
			
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