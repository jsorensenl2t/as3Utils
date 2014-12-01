package com.l2tmedia.events {

import flash.display.DisplayObject;
import flash.events.Event;

public class AnimatorEvent extends Event {

	public static const ON_ANIMATION_COMPLETE:String = "onAnimationComplete";
	public var animationTarget:DisplayObject;
	
	public function AnimatorEvent(type:String, target:DisplayObject, bubbles:Boolean=true, cancelable:Boolean=false) {
		animationTarget = target;
		super(type, bubbles, cancelable);
	}
}}