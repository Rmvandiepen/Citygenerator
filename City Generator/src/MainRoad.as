package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Hugo
	 */
	public class MainRoad extends Sprite
	{
		private var _roadParts:Array;
		private var _roadStart:Point;
		private var _roadAge:int = 0;
		private var _angle:int = 0;
		public var roadActive = true;
		private var _parent:City2;
		private var size:int = 800;
		
		private var frame:int = 0;
		private var frames:int = 1;
		
		private const roadMaxLength:int = 10;
		
		public function MainRoad(startPosition:Point, angle:int, parent:City2) 
		{
			_roadParts = new Array();
			_roadStart = startPosition;
			_angle = angle;
			_roadParts.push(_roadStart);
			_parent = parent;
			
			drawNextPart(calculateNextPart(_roadStart, _angle));
			
			this.addEventListener(Event.ENTER_FRAME, update);
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
			
			this._roadAge += 1;
			
			roadActive = calculateRoadEnded();
			trace(roadActive + "age:" + this._roadAge);
			
			if (calculateRoadSplit() && roadActive)
			{
				trace("split");
				var randomAngle:int = 0;
				_parent._roads.push(new MainRoad(nextPosition, randomAngle, _parent));
				_parent.addChild(_parent._roads[_parent._roads.length - 1]);
			}
		}
		
		public function update(e:Event)
		{
			if (frame >= frames)
			{	
				if (roadActive)
				{
					drawNextPart(calculateNextPart(this._roadParts[_roadParts.length - 1], _angle));
				}else
				{
					this.removeEventListener(Event.ENTER_FRAME, update);
				}
				frame = 0;
			}
			else if ( frame < frames)
			{
				frame ++;
			}
		}
		
		private function calculateRoadEnded():Boolean
		{
			var randomInt:int = (int)(Math.random() * 100);
			
			return (85 > (randomInt - (120 / this._roadAge)));
		}
		
		public function calculateRoadSplit():Boolean
		{
			var randomInt:int = (int)(Math.random() * 100);
			
			var j:int = (randomInt - ((5 * this._roadAge) + (2 * this._parent._roads.length)));
			
			return (52 < j);
		}
		
		public function calculateMakeTurn():Boolean
		{
			var randomInt:int = (int)(Math.random() * 100);
			
			return (60 < (randomInt - (10 * this._roadAge)));
		}
		
		public function calculateNextPart(position:Point, angle:int):Point
		{
			if (position.x < 0 || position.y < 0 || position.x > 1500 || position.y > 1500)
			{
				roadActive = false;
			}
			if (angle >= 360) 
				angle -= 360;
			
			var newx:int = position.x + Math.sin(angle * Math.PI / 180) * roadMaxLength;
			var newy:int = position.y + Math.cos(angle * Math.PI / 180) * roadMaxLength;
			
			if (!calculateMakeTurn)
				return new Point(newx, newy);
			
			var allowedDir:Array = [];
			for (var i:int = -90; i <= 90; i+=90) 
			{
				var allowDir:Boolean;
				if (Math.cos((angle + i) * Math.PI / 180) <= 0.01 && Math.cos((angle + i) * Math.PI / 180) >= -0.01)
				{
					if (position.x > position.x + Math.sin((angle + i) * Math.PI / 180))
					{
						if (position.x < _roadStart.x)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(_roadStart.x - position.x))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(_roadStart.x - position.x)) < 0)
							{
								allowDir = false;
							}
						}
						else
						{
							allowDir = true;
						}
					}
					else
					{
						if (position.x > _roadStart.x)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(_roadStart.x - position.x))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(_roadStart.x - position.x)) < 0)
							{
								allowDir = false;
							}
						}
						else
						{
							allowDir = true;
						}
					}
					if (allowDir)
					{
						allowedDir.push(i);
					}
				}
				else
				{
					if (position.y > position.y + Math.cos((angle + i) * Math.PI / 180))
					{
						if (position.y < _roadStart.y)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(_roadStart.y - position.y))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(_roadStart.y - position.y)) < 0)
							{
								allowDir = false;
							}
						}
						else
						{
							allowDir = true;
						}
					}
					else
					{
						if (position.y > _roadStart.y)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(_roadStart.y - position.y))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(_roadStart.y - position.y)) < 0)
							{
								allowDir = false;
							}
						}
						else
						{
							allowDir = true;
						}
					}
					if (allowDir)
					{
						allowedDir.push(i);
					}
				}
			}
			var string:String = "dirs:";
			for (var j:int = 0; j < allowedDir.length; j++) 
			{
				string += allowedDir[j] + ", ";
			}
			
			var randomNum:int = Math.random() * 20;
			if (randomNum < 1)
			{
				if (allowedDir.indexOf(0) != -1)
				{
					return new Point(newx, newy);
				}
				else if(allowedDir.indexOf(-90) != -1)
				{
					angle -= 90;
				}
				if (allowedDir.indexOf(90) != -1)
				{
					angle += 90;
				}
				else if(allowedDir.indexOf(-90) != -1)
				{
					angle -= 90;
				}
			}
			else if (randomNum < 2)
			{
				if (allowedDir.indexOf(0) != -1)
				{
					return new Point(newx, newy);
				}
				else if(allowedDir.indexOf(90) != -1)
				{
					angle += 90;
				}
				if (allowedDir.indexOf(-90) != -1)
				{
					angle -= 90;
				}
				else if(allowedDir.indexOf(90) != -1)
				{
					angle += 90;
				}
			}
			else if(randomNum < 18)
			{
				if (allowedDir.indexOf(0) != -1)
				{
					return new Point(newx, newy);
				}
				else if(allowedDir.indexOf(90) != -1)
				{
					angle += 90;
				}
				else if(allowedDir.indexOf(-90) != -1)
				{
					angle -= 90;
				}
			}
			else if(randomNum < 19)
			{
				if (allowedDir.indexOf(-90) != -1)
				{
					angle -= 90;
				}
				else if(allowedDir.indexOf(0) != -1)
				{
					return new Point(newx, newy);
				}
				else if(allowedDir.indexOf(90) != -1)
				{
					angle += 90;
				}
			}
			else if(randomNum < 20)
			{
				if (allowedDir.indexOf(90) != -1)
				{
					angle += 90;
				}
				else if(allowedDir.indexOf(-90) != -1)
				{
					angle -= 90;
				}
				else if(allowedDir.indexOf(0) != -1)
				{
					return new Point(newx, newy);
				}
			}
			newx = position.x + Math.sin(angle * Math.PI / 180) * roadMaxLength;
			newy = position.y + Math.cos(angle * Math.PI / 180) * roadMaxLength;
			_angle = angle;
			
			return new Point(newx, newy);
		}
		
		public function getRoadAge():int
		{
			return this._roadAge;
		}
		
	}

}