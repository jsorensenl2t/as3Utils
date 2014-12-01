package util
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * AlignUtil 1.0
	 */
	public class AlignUtil
	{
		static public const TOP:String 		= "top";
		static public const BOTTOM:String 	= "bottom";
		static public const CENTER:String 	= "center";
		static public const LEFT:String 	= "left";
		static public const RIGHT:String 	= "right";
		static public const NONE:String 	= "none";
		
		public static function align(target:DisplayObject, to:Rectangle, vertical:String, horizontal:String, customBounds:Rectangle=null):void {
			var objectBounds:Rectangle;
			
			if (!customBounds) objectBounds = target.getBounds(target.parent);
			else objectBounds = customBounds;
			
			var x:Number = objectBounds.x;
			var y:Number = objectBounds.y;
			
			if (horizontal == LEFT)
				x = to.left;
			else if (horizontal == CENTER)
				x = 0.5 * (to.left + to.right - objectBounds.width);
			else if (horizontal == RIGHT)
				x = to.right - objectBounds.width;
				
			if (vertical == TOP)
				y = to.top;
			else if (vertical == CENTER)
				y = 0.5 * (to.top + to.bottom - objectBounds.height);
			else if (vertical == BOTTOM)
				y = to.bottom - objectBounds.height;
				
			target.x += x - objectBounds.left;
			target.y += y - objectBounds.top;
		}
		public static function move(target:DisplayObject, x:int, y:int):void {
			target.x += x;
			target.y += y;
		}
		public static function alignCenter(target:DisplayObject, bounds:Rectangle):void
		{
			align(target, bounds, CENTER, CENTER);
		}		
		
	}

}