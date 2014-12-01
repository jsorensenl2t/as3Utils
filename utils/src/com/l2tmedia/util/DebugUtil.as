package com.l2tmedia.util {
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	public class DebugUtil {
		public static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		public static function getSuperClass(o: Object): Object {
			var n: String = getQualifiedSuperclassName(o);
			if(n == null)return(null);
			return(getDefinitionByName(n));
		}
	}
}