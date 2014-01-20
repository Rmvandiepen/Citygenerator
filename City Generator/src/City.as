package  
{
	import adobe.utils.ProductManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Rob van Diepen
	 */
	public class City extends Sprite
	{
		
		private var environment:Environment;
		
		private var roadArray:Array = [];
		private var newRoadArray:Array = [];
		private var center:Point;
		
		
		private var size:int = 400;
		private var _makeMoreRoads:Boolean = true;
		
		
		//keyboardvars
		private var frame:int = 0;
		private var frames:int = 0;
		private var superSpeed:int = 1;
		private var started:Boolean = false;
		
		public function City(x:int, y:int, environment:Environment) 
		{
			this.environment = environment;
			center = new Point(x, y);
			size = Main.SIZE;
			createRoads(x, y);
		}
		public function cleanCity():void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			
			Main.roadArray = [];
			newRoadArray = [];
			center = null;
		}
		private function createRoads(posX:int, posY:int):void
		{
			newRoad(posX, posY, 0);
			newRoad(posX, posY, 90);
			newRoad(posX, posY, 180);
			newRoad(posX, posY, 270);
		}
		private function update(e:Event):void
		{			
			//for (var i:int = 0; i < superSpeed; i++) 
			//{
				//v
				//if (newRoadArray[newRoadArray.length-1] != null && frame >= frames)
				//{
				//}
				//else if ( frame < frames)
				//{
					//frame ++;
				//}
			//}
			
			if (frame >= frames)
			{
			
				var createRoads:Array = [];
				
				while (newRoadArray.length > 0)
				{
					createRoads.push(newRoadArray.pop());
				}
				while (createRoads.length > 0)
				{
					var road3:Object = createRoads.pop();
					newRoad(road3.x, road3.y, road3.angle);
					frame = 0;
				}
			}
			else if ( frame < frames)
			{
				frame ++;
			}
		}
		private function newRoad(x:int=0, y:int=0, angle:int = 0):void
		{
			if (x < 0 || y < 0 || x > 1500 || y > 1500)
			{
				return;
			}
			if (angle >= 360) 
				angle -= 360;
			
			var curDist:int = DistanceTwoPoints(x, center.x, y, center.y);
			trace(curDist);
			var road:Road = new Road(x, y, angle, calculateMaxLength(x, y, angle), curDist/size);
			this.addChild(road);
			Main.roadArray.push(road);
			var newx:int = road.endPoint().x;
			var newy:int = road.endPoint().y;
			var allowedDir:Array = [];
			for (var i:int = -90; i <= 90; i+=90) 
			{
				var allowDir:Boolean;
				if (Math.cos((angle + i) * Math.PI / 180) <= 0.01 && Math.cos((angle + i) * Math.PI / 180) >= -0.01)
				{
					if (x > x + Math.sin((angle + i) * Math.PI / 180))
					{
						if (x < center.x)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(center.x - x))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(center.x - x)) < 0)
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
						if (x > center.x)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(center.x - x))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(center.x - x)) < 0)
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
					if (y > y + Math.cos((angle + i) * Math.PI / 180))
					{
						if (y < center.y)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(center.y - y))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(center.y - y)) < 0)
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
						if (y > center.y)
						{
							if (Math.random() * 100 > Math.sqrt(10000 - ((10000 / size) * Math.abs(center.y - y))))
							{
								allowDir = false;
							}
							else
							{
								allowDir = true;
							}
							if (10000 - ((10000 / size) * Math.abs(center.y - y)) < 0)
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
			
			if (!road.reachedMax && _makeMoreRoads)
			{
				var randomNum:int = Math.random() * 20;
				if (randomNum < 1)
				{
					if (allowedDir.indexOf(0) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle } );
					}
					else if(allowedDir.indexOf(-90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle - 90} );
					}
					if (allowedDir.indexOf(90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle + 90 } );
					}
					else if(allowedDir.indexOf(-90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle - 90} );
					}
				}
				else if (randomNum < 2)
				{
					if (allowedDir.indexOf(0) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle } );
					}
					else if(allowedDir.indexOf(90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle + 90} );
					}
					if (allowedDir.indexOf(-90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle - 90 } );
					}
					else if(allowedDir.indexOf(90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle + 90} );
					}
				}
				else if(randomNum < 18)
				{
					if (allowedDir.indexOf(0) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle } );
					}
					else if(allowedDir.indexOf(90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle + 90} );
					}
					else if(allowedDir.indexOf(-90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle - 90} );
					}
				}
				else if(randomNum < 19)
				{
					if (allowedDir.indexOf(-90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle - 90 } );
					}
					else if(allowedDir.indexOf(0) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle} );
					}
					else if(allowedDir.indexOf(90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle + 90} );
					}
				}
				else if(randomNum < 20)
				{
					if (allowedDir.indexOf(90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle + 90 } );
					}
					else if(allowedDir.indexOf(-90) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle - 90} );
					}
					else if(allowedDir.indexOf(0) != -1)
					{
						newRoadArray.push( { x:newx, y:newy, angle:angle} );
					}
				}
			}
		}
		private function calculateMaxLength(x:int, y:int, angle:int):int
		{
			var shorthestLength:int = Main.MAX_ROAD_LENGTH;
			var newPointX:int = x + Math.sin(angle * Math.PI / 180) * Main.MAX_ROAD_LENGTH;
			var newPointY:int = y + Math.cos(angle * Math.PI / 180) * Main.MAX_ROAD_LENGTH;
			
			
			var A:Point = new Point(x, y);
			var B:Point = new Point(newPointX, newPointY);
			var C:Point;
			var D:Point;
			
			for each(var road:Road in Main.roadArray)
			{
				C = road.startPoint();
				D = road.endPoint();
				
				var intersection:Point = lineIntersectLine(A, B, C, D);
				if (intersection != null)
				{
					var length:int = DistanceTwoPoints(A.x, intersection.x, A.y, intersection.y) as int
					if (length < shorthestLength && length > 0)
					{
						shorthestLength = length;
					}
				}
			}
			var lowestX:int = Math.floor(Math.min(x , x + Math.sin(angle * Math.PI / 180) * shorthestLength));
			var highestX:int = Math.floor(Math.max(x , x + Math.sin(angle * Math.PI / 180) * shorthestLength));
			var lowestY:int = Math.floor(Math.min(y , y + Math.cos(angle * Math.PI / 180) * shorthestLength));
			var highestY:int = Math.floor(Math.max(y , y + Math.cos(angle * Math.PI / 180) * shorthestLength));
			
			for (var i:int = Math.floor(lowestX/environment.pxWidth); i <= Math.floor(highestX/environment.pxWidth); i++) 
			{
				for (var j:int = Math.floor(lowestY / environment.pxHeight); j <= Math.floor(highestY / environment.pxHeight); j++) 
				{
					if (i<0 || i >= environment.numPxWidth || j < 0 || j >= environment.numPxHeight)
					{
						continue;
					}
					var tile:Tile = environment.landscape[i][j];
					if (tile.type == 2)
					{
						if (lowestX < x)
						{
							shorthestLength = Math.min(shorthestLength, Math.abs(x - (tile.x + tile.width)));
						}
						else if (lowestY < y)
						{
							shorthestLength = Math.min(shorthestLength, Math.abs(y - (tile.y + tile.height)));
						}
						else if(lowestX == x && lowestX != highestX)
						{
							shorthestLength = Math.min(shorthestLength, Math.abs(x - tile.x));
						}
						else if ( lowestY == y&& lowestY != highestY)
						{
							shorthestLength = Math.min(shorthestLength, Math.abs(y - tile.y));
						}
					}
				}
			}
			return shorthestLength;
		}
		private function DistanceTwoPoints(x1:Number, x2:Number,  y1:Number, y2:Number): Number 
		{
			var dx:Number = x1-x2;
			var dy:Number = y1-y2;
			return Math.sqrt(dx * dx + dy * dy);
		}
		private function lineIntersectLine(A:Point, B:Point, E:Point, F:Point, as_seg:Boolean = true):Point
		{
			var ip:Point;
			var a1:Number;
			var a2:Number;
			var b1:Number;
			var b2:Number;
			var c1:Number;
			var c2:Number;
		 
			a1= B.y-A.y;
			b1= A.x-B.x;
			c1= B.x*A.y - A.x*B.y;
			a2= F.y-E.y;
			b2= E.x-F.x;
			c2= F.x*E.y - E.x*F.y;
		 
			var denom:Number=a1*b2 - a2*b1;
			if (denom == 0) {
				return null;
			}
			ip=new Point();
			ip.x=(b1*c2 - b2*c1)/denom;
			ip.y=(a2*c1 - a1*c2)/denom;
		 
			//---------------------------------------------------
			//Do checks to see if intersection to endpoints
			//distance is longer than actual Segments.
			//Return null if it is with any.
			//---------------------------------------------------
			if (as_seg)
			{
				if(Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
				{
				   return null;
				}
				if(Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
				{
				   return null;
				}
		 
				if(Math.pow(ip.x - F.x, 2) + Math.pow(ip.y - F.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
				{
				   return null;
				}
				if(Math.pow(ip.x - E.x, 2) + Math.pow(ip.y - E.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
				{
				   return null;
				}
			}
			return ip;
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{			
			if (e.keyCode >= 48 && e.keyCode <= 57)// 0 to 9 for speed
			{
				frames = e.keyCode - 48;
				trace("SPEED = ", 10 - frames);
			}
			else if (e.keyCode == 39)// Arrow key for more speed
			{
				superSpeed++;
				trace("SUPERSPEED = ", superSpeed);
			}
			else if (e.keyCode == 37)// Arrow Key for less speed
			{
				if (superSpeed > 1)
				{
					superSpeed--;
					trace("SUPERSPEED = ", superSpeed);
				}
			}
			else if ( e.keyCode == 82) // R Key for 1 new Road
			{
				if (newRoadArray.length > 0)
				{
					var road:Object = newRoadArray.pop();
					newRoad(road.x, road.y, road.angle);
				}
			}
			else if ( e.keyCode == 83) // S Key for instant city
			{
				while (newRoadArray.length > 0)
				{
					var road2:Object = newRoadArray.pop();
					newRoad(road2.x, road2.y, road.angle);
				}
			}
		}
		public function start():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}

}