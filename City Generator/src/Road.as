package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class Road extends Sprite
	{
		private var _numNewRoads:int = 0;
		private var _angle:int = 0;
		private var _endX:int;
		private var _endY:int;
		public var reachedMax:Boolean = false;
	public function Road(x:int, y:int, angle:int, maxLength:int, procFromCenter:Number)
		{
			this.x = x;
			this.y = y;
			_angle = angle;
			var length:int = Math.floor(Math.random() * Main.NUM_ROAD_STEPS ) * (((Main.MAX_ROAD_LENGTH - Main.MIN_ROAD_LENGTH)*(procFromCenter*0.0)+1.1)/Main.NUM_ROAD_STEPS) + Main.MIN_ROAD_LENGTH;
			if (length >= maxLength)
			{
				length = maxLength;
				reachedMax = true;
			}
			_endX = Math.sin(angle * Math.PI / 180) * length;
			_endY = Math.cos(angle * Math.PI / 180) * length;
			this.graphics.beginFill(0x00ff00, 1);
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.lineTo(_endX, _endY);
			this.graphics.endFill();
		}
		
		public function endPoint():Point
		{
			return new Point(this.x + _endX, this.y + _endY);
		}
		public function startPoint():Point
		{
			return new Point(this.x, this.y);
		}
	}
}