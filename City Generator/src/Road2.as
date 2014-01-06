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
		public var roadActive = true;
		private var _parent:City2;
		
		public function Road2(startPosition:Point, parent:City2) 
		{
			_roadParts = new Array();
			_roadStart = startPosition;
			_roadParts.push(_roadStart);
			_parent = parent;
			
			drawNextPart(calculateNextPart());
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
			
			trace(nextPosition.x + " <-- x y--> " + nextPosition.y);
			trace("draaawing");
			
			this._roadAge += 1;
			
			roadActive = calculateRoadEnded();
			
			if (calculateRoadSplit())
			{
				trace("split");
				_parent._roads.push(new Road2(nextPosition, _parent));
				_parent.addChild(_parent._roads[_parent._roads.length - 1]);
			}
			
			if (roadActive) drawNextPart(calculateNextPart());
		}
		
		private function calculateRoadEnded():Boolean
		{
			var randomInt:int = (int)(Math.random() * 100);
			
			return (85 > (randomInt - (120 / this._roadAge))); 
		}
		
		public function calculateRoadSplit():Boolean
		{
			var randomInt:int = (int)(Math.random() * 100);
			
			return (75 < (randomInt - (10 * this._roadAge)));
		}
		
		public function calculateMakeTurn():Boolean
		{
			var randomInt:int = (int)(Math.random() * 100);
			
			return (60 < (randomInt - (10 * this._roadAge)));
		}
		
		public function calculateNextPart():Point
		{
			var angle:int = 0;
			
			if (_roadParts.length < 2)
			{
				var randomAngle:int = (int)(Math.random() * 360);
				
				if (randomAngle < 45 || randomAngle > 315)
				{
					randomAngle = 0;
				}else if (randomAngle < 135)
				{
					randomAngle = 90;
				}else if (randomAngle < 225)
				{
					randomAngle = 180;
				}else 
				{
					randomAngle = 270;
				}
				
				angle = randomAngle;
			}else
			{
				var deltaY:int, deltaX:int;
				deltaY =  _roadParts[_roadParts.length - 2].y - _roadParts[_roadParts.length - 1].y;
				deltaX = _roadParts[_roadParts.length - 2].x - _roadParts[_roadParts.length - 1].x;
				angle = Math.atan2(deltaY, deltaX) * 180 / Math.PI;
			}
			
			trace(angle);
			
			
			return new Point(Math.sin(angle * Math.PI / 180) * 8, Math.cos(angle * Math.PI / 180) * 8);
			
		}
		
		public function getRoadAge():int
		{
			return this._roadAge;
		}
		
	}

}