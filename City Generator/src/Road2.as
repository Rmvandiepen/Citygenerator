package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Hugo
	 */
	public class Road2 extends Sprite
	{
		private var _roadParts:Array;
		private var _roadStart:Point;
		private var _roadAge:int = 0;
		
		public function Road2(startPosition:Point) 
		{
			_roadParts = new Array();
			_roadParts.push(_roadStart);
		}
		
		public function drawNextPart(nextPosition:Point)
		{
			var lastPoint:Point;
			lastPoint = _roadParts[_roadParts.length - 1];
			
			_roadParts.push(nextPosition);
			
			this.graphics.beginFill(0xFF8000, 1);
			this.graphics.lineStyle(2, 0xFF8000);
			this.graphics.moveTo(lastPoint.x, lastPoint.y);
			this.graphics.lineTo(nextPosition.x, nextPosition.y);
			this.graphics.endFill();
			
			this._roadAge += 1;
		}
		
		public function getRoadAge():int
		{
			return this._roadAge;
		}
		
	}

}