package util {
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * RectangleUtil 1.0
	 */
	public class RectangleUtil {
		/* Helpers */
		private static const sHelperPoint:Point = new Point();
		private static const sPositions:Vector.<Point> = new <Point>[ new Point(0, 0), new Point(1, 0), new Point(0, 1), new Point(1, 1) ];
		
		/** Calculates the bounds of a rectangle after transforming it by a matrix.
		 *  If you pass a 'resultRect', the result will be stored in this rectangle
         *  instead of creating a new object. */
        public static function transformRect(rectangle:Rectangle, transformationMatrix:Matrix, resultRect:Rectangle = null):Rectangle {
			var transform = function(matrix:Matrix, x:Number, y:Number, resultPoint:Point):void {
				resultPoint.x = matrix.a * x + matrix.c * y + matrix.tx;
				resultPoint.y = matrix.d * y + matrix.b * x + matrix.ty;
			}
            if (resultRect == null) resultRect = new Rectangle();
			
            var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
            var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
            
            for (var i:int=0; i<4; ++i) {
                transform(transformationMatrix, sPositions[i].x * rectangle.width, sPositions[i].y * rectangle.height, sHelperPoint);
                if (minX > sHelperPoint.x) minX = sHelperPoint.x;
                if (maxX < sHelperPoint.x) maxX = sHelperPoint.x;
                if (minY > sHelperPoint.y) minY = sHelperPoint.y;
                if (maxY < sHelperPoint.y) maxY = sHelperPoint.y;
            }
			resultRect.x = minX;
			resultRect.y = minY;
			resultRect.width = maxX - minX;
			resultRect.height = maxY - minY;
            return resultRect;
        }
	}
}