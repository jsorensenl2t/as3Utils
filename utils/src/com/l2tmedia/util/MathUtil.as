package com.l2tmedia.util {
	/**
	 * MathUtil 1.0
	 */
	public class MathUtil {
		public static function normalize($value:Number, $min:Number, $max:Number):Number{
			return ($value - $min) / ($max - $min);
		}
		public static function interpolate($normValue:Number, $min:Number, $max:Number):Number{
			return $min + ($max - $min) * $normValue;
		}
		public static function map($value:Number, $min1:Number, $max1:Number, $min2:Number, $max2:Number):Number{
			return interpolate( normalize($value, $min1, $max1), $min2, $max2);
		}
	}
}