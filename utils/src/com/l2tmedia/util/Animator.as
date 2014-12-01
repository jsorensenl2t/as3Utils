package com.l2tmedia.util {
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.DisplayObject;
    import flash.filters.BlurFilter;
	
	import com.greensock.TweenLite;
	import com.greensock.TimelineLite;
	import com.greensock.plugins.TweenPlugin; 
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.easing.Expo;
	
	import com.l2tmedia.events.AnimatorEvent;
	
	public class Animator extends EventDispatcher {
		
		public function Animator() {
			_initPlugins();
		}
		
		private function _initPlugins():void {
			TweenPlugin.activate([ColorTransformPlugin, BlurFilterPlugin]);
		}
		
		/**
		 * Called by all animation routines after animation completes. Dispatches an AnimatorEvent.onAnimationComplete event.
		 * @param	target
		 * @param	callback
		 */
		private function _completeAnimation(target:DisplayObject, callback:Function = null) {
			if (callback is Function) {
				if (callback is Function) callback(target);
				else throw new ArgumentError("The passed callback is not a function");
			}
			dispatchEvent(new AnimatorEvent(AnimatorEvent.ON_ANIMATION_COMPLETE, target));
		}
		
		///////////////////////////////////////
		// PUBLIC /////////////////////////////
		///////////////////////////////////////
		
		/**
		 * Simple fade in function.
		 * @param	target
		 * @param	fadeInTime
		 * @param	blur
		 * @param	callback
		 */
		public function fadeIn(target:DisplayObject, fadeInTime:Number = .5, blur:Number = 20, callback:Function = null) {
			var origAlpha:Number = target.alpha;
			target.alpha = 0;
			target.filters = [new BlurFilter(blur, blur)];
			TweenLite.to(target, fadeInTime, { alpha:origAlpha, blurFilter: { blurX:0, blurY:0 }, onComplete:_completeAnimation, onCompleteParams:[target, callback] } );
		}
		
		/**
		 * Simple fade-out function.
		 * @param	target
		 * @param	fadeOutTime
		 * @param	blur
		 * @param	callback
		 */
		public function fadeOut(target:DisplayObject, fadeOutTime:Number = .5, blur:Number = 20, callback:Function = null) {
			target.filters = [new BlurFilter(0, 0)];
			TweenLite.to(target, fadeOutTime, { alpha:0, blurFilter: { blurX:blur, blurY:blur }, onComplete:_completeAnimation, onCompleteParams:[target, callback] } );
		}
		
		/**
		 * Simple delay function.
		 * @param	target
		 * @param	delay
		 * @param	callback
		 */
		public function wait(target:DisplayObject, delay:Number, callback:Function = null) {
			TweenLite.to(target, 0, {delay:delay, onComplete:_completeAnimation, onCompleteParams:[target, callback]} );
		}
		
		/**
		 * Slide and blur the movieclip in.
		 * @param	settings	Object
		 * <code>{ x:Number=0, y:Number=0, alpha:Number=100, delay:Number=0, duration:Number=0.5, callback:Function=null, ease:Ease=Expo.easeOut, blur=0.4, flashAtEnd:Boolean=false} </code>
		 */
		public function slideAndBlurIn(target:DisplayObject, settings:Object) {
			
			var _origStageX  = target.x;
			var _origStageY  = target.y;
			var _origAlpha 	 = target.alpha;
			var _origFilters = target.filters;
			
			var s:Object 	= {};
			s.x 			= 0;
			s.y				= 0;
			s.alpha 		= 1;
			s.delay 		= 0;
			s.duration 		= 0.5;
			s.callback 		= null;
			s.ease			= Expo.easeOut;
			s.blur 			= 0.4;
			s.flashAtEnd	= true;
			
			for (var i:String in settings) s[i] = settings[i];
			
			target.visible 	 	 = false;
			target.x 			 = target.x + s.x;
			target.y 			 = target.y + s.y;
			target.alpha 		 = s.alpha
			
			var blrX:Number = Math.abs(s.x) * s.blur;
			var blrY:Number = Math.abs(s.y) * s.blur;
			
			target.filters = [new BlurFilter(blrX, blrY)];
			
			var _onStart = function() {
				target.visible = true;
			}
			
			var _onComplete = function() {
				if (s.flashAtEnd) {
					
					target.filters = _origFilters;
					var tl:TimelineLite = new TimelineLite( { onComplete:_completeAnimation, onCompleteParams:[target, s.callback] } );	
					tl.to(target, .1, { colorTransform: { exposure:2 }} );
					tl.to(target, .2, { colorTransform: { exposure:1 }} );
					tl.play();
					
				} else {
					target.filters = _origFilters;
					_completeAnimation(target, s.callback);
				}
			}
			
			TweenLite.to(target, s.duration, 
						{ 	ease:			s.ease, 
							x:				_origStageX, 
							y:				_origStageY, 
							alpha:			_origAlpha, 
							delay:			s.delay, 
							blurFilter: 	{ blurX:0, blurY:0 },
							onStart:		_onStart, 
							onComplete:		_onComplete 
						});
		}
	}
}