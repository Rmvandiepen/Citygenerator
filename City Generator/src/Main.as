package 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Rob van diepen
	 */
	public class Main extends Sprite 
	{
		public static var roadArray:Array = [];
		public static const MIN_ROAD_LENGTH:int = 5;
		public static const NUM_ROAD_STEPS:int = 3;
		public static const MAX_ROAD_LENGTH:int = 20;
		public static const SIZE:int = 450;
		
		private var fullMap:Sprite = new Sprite();
		private var environment:Environment;
		private var cities:Array = [];
		
		// Event vars
		private var _clicked:Boolean;
		private var startPoint:Point;
		private var deltaPoint:Point;
		private var bool:Boolean = false;
		private var buildingCities:Boolean = false;
		
		private var type:int = 0;
		private var pointOne:Point;
		private var pointTwo:Point;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			trace("BEGIN");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			trace(generateLString(4));
			//createRoad2(generateLString(12));
			fullMap.scaleX = 0.5;
			fullMap.scaleY = 0.5;
			addChild(fullMap);
			
			generateNew();
		}
		private function createRoad2(key:String):void
		{
			var curAngle:int = 0;
			var curX:int = 400
			var curY:int = 300;
			for (var i:int = 0; i < key.length; i++) 
			{
				var subStr:String = key.substring(i, i + 1);
				switch(subStr)
				{
					case "B":
						curAngle += 90;
						break;
					
					case "C":
						curAngle -= 90;
						break;
				}
				var road:Road = new Road(curX, curY, curAngle, 100, 0);
				this.addChild(road);
				curX = road.endPoint().x;
				curY = road.endPoint().y;
			}
		}
		private function generateLString(numIterations:int, L_String:String = "A"):String
		{
			var string:String = "";
			for (var i:int = 0; i < L_String.length; i++) 
			{
				var subStr:String = L_String.substring(i, i + 1);
				switch(subStr)
				{
					case "A":
						string += "BDA";
						break;
					
					case "B":
						string += "CAD";
						break;
					
					case "C":
						string += "AB";
						break;
					
					case "D":
						string += "BCA";
						break;
				}
			}
			if (numIterations > 1)
			{
				numIterations--;
				string = generateLString(numIterations, string);
			}
			var newString:String = "";
			for (var j:int = 0; j < string.length; j++) 
			{
				var subString:String = string.substring(j, j + 1);
				if (subString == "D")
				{
					newString += String.fromCharCode(Math.floor(Math.random() * 3) + 65);
				}
				else
				{
					newString += subString;
				}
			}
			string = newString;
			return string;
		}
		private function clearAll():void
		{
			while (fullMap.numChildren > 0)
			{
				fullMap.removeChildAt(0);
			}
			
			environment = null;
			
			for each(var city:City in cities)
			{
				city.cleanCity();
			}
			cities = [];
			
		}
		private function generateNew():void
		{
			environment = new Environment();
			fullMap.addChild(environment);
			var bestPlaces:Array = getCityPos();
			for (var i:int = 0; i < bestPlaces.length; i++) 
			{
				trace("x:", bestPlaces[i].x, ", y:", bestPlaces[i].y, ", points:", bestPlaces[i].point);
				var city:City = new City(bestPlaces[i].x * 30 + 15, bestPlaces[i].y * 30 + 15, environment);
				fullMap.addChild(city);
				cities.push(city);
				if (i > 0)
				{
					findPath(bestPlaces[i - 1].x, bestPlaces[i - 1].y, bestPlaces[i].x, bestPlaces[i].y);
				}
				else
				{
					findPath(bestPlaces[2].x, bestPlaces[2].y, bestPlaces[i].x, bestPlaces[i].y);
				}
			}
			//var city:City2 = new City2(new Point(300, 300), environment);
			//
			//fullMap.addChild(city);
		}
		private var path:Object;
		private function findPath(startx:int, starty:int, targetx:int, targety:int):Boolean
		{
			path={};
			path.Unchecked_Neighbours=[];
			path.done = false;
			path.name="node_"+starty+"_"+startx;
			path[path.name]={x:startx, y:starty, visited:false, parentx:null, parenty:null};
			path.Unchecked_Neighbours[path.Unchecked_Neighbours.length]=path[path.name];
			while (path.Unchecked_Neighbours.length > 0) 
			{
				var N:Object = path.Unchecked_Neighbours.shift();
				if (N.x == targetx && N.y == targety) 
				{
					make_path(N);
					path.done = true;
					break;
				}
				else 
				{
					N.visited = true;
					addNode (N, N.x, N.y-1);
					addNode (N, N.x+1, N.y);
					addNode (N, N.x-1, N.y);
					addNode (N, N.x, N.y+1);
					addNode (N, N.x-1, N.y-1);
					addNode (N, N.x+1, N.y-1);
					addNode (N, N.x-1, N.y+1);
					addNode (N, N.x+1, N.y+1);
				}
			}
			//delete path;
			if (path.done) 
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		private function addNode(parent:Object, x:int, y:int):void
		{
			path.name = "node_" + y + "_" + x;
			if (x < 50 && y < 50 && x >= 0 && y >= 0)
			{
				var tile:Tile = environment.landscape[x][y];
				if (tile.type == 1)
				{
					if (path[path.name] == null || path[path.name].visited == false) 
					{
						path[path.name]={x:x, y:y, visited:true, parentx:parent.x, parenty:parent.y};
						path.Unchecked_Neighbours[path.Unchecked_Neighbours.length]= path[path.name];
					}
				}
			}
		}
		private function make_path(node:Object):void
		{
			var nextNode:Object
			var startRoad:Point;
			var endRoad:Point;
			while (node.parentx != null)
			{
				startRoad = new Point(node.x * 30 + 15, node.y * 30 + 15);
				nextNode = path["node_" + node.parenty + "_" + node.parentx];
				var difX:int = nextNode.x - node.x;
				var difY:int = nextNode.y - node.y;
				if (nextNode)
				{
					while (nextNode.x - node.x == difX && nextNode.y - node.y == difY)
					{
						node = nextNode;
						if (nextNode.parentx != null)
						{
							nextNode = path["node_" + nextNode.parenty + "_" + nextNode.parentx];
						}
					}
				}
				endRoad = new Point(node.x * 30 + 15, node.y * 30 + 15);
				var road:Road = new Road(0, 0, 90, 30, 10);
				road.fromEndPoint(startRoad.x, startRoad.y, endRoad.x - startRoad.x, endRoad.y - startRoad.y);
				environment.addChild(road);
				Main.roadArray.push(road);
			}
			//move char
		}
		private function getCityPos():Array
		{
			trace("GetCityPos");
			var checkDist:int = 15;
			var checkDistMax:int = Math.sqrt(2 * Math.pow(checkDist, 2));
			var landscape:Array = environment.landscape;
			var highestPoints:Array = [];
			var highestPoint:Point;
			var highestPointPoints:int = 0;
			for (var i:int = 0; i < environment.numPxWidth; i+=1) 
			{
				for (var j:int = 0; j < environment.numPxHeight; j+=1) 
				{
					if ((landscape[i][j] as Tile).type == 1)
					{
						var points:int = 0;
						for (var k:int = -checkDist; k <= checkDist; k++) 
						{
							for (var l:int = -checkDist; l <= checkDist; l++) 
							{
								if (i + k < 0 || j + l < 0 || i + k >= environment.numPxWidth || j + l >= environment.numPxHeight)
								{
									continue;
								}
								if ((landscape[i+k][j+l] as Tile).type == 1)
								{
									points += checkDistMax - Math.sqrt(Math.pow(k, 2) + Math.pow(l, 2));
									//trace("grass", checkDistMax - Math.sqrt(Math.pow(k, 2) + Math.pow(l, 2)));
								}
								else
								{
									points += Math.sqrt(Math.pow(k, 2) + Math.pow(l, 2));
									//trace("wate5r", Math.sqrt(Math.pow(k, 2) + Math.pow(l, 2)));
								}
							}
						}
						if (highestPoints.length < 3)
						{
							highestPoints.push( { x:i, y:j, point:points } );
							highestPoints.sortOn("point", Array.DESCENDING);
						}
						else
						{
							if (points > highestPoints[2].point)
							{
								highestPoints[2] = { x:i, y:j, point:points };
								highestPoints.sortOn("point", Array.DESCENDING);
							}
						}
					}
				}
			}
			return highestPoints;
		}
		private function onMouseClick(e:MouseEvent):void 
		{
			if (!pointOne)
			{
				pointOne = new Point((int)((e.stageX - e.stageX % 10 - fullMap.x) / fullMap.scaleX / 30), (int)((e.stageY - e.stageY % 10 - fullMap.y) / fullMap.scaleY / 30));
			}
			else if(!pointTwo)
			{
				pointTwo = new Point((int)((e.stageX - e.stageX % 10 - fullMap.x) / fullMap.scaleX / 30), (int)((e.stageY - e.stageY % 10 - fullMap.y) / fullMap.scaleY / 30));
				trace("Path from:", pointOne, "To:", pointTwo);
				trace(findPath(pointOne.x, pointOne.y, pointTwo.x, pointTwo.y));
			}
			else
			{
				pointOne = new Point((int)((e.stageX - e.stageX % 10 - fullMap.x) / fullMap.scaleX / 30), (int)((e.stageY - e.stageY % 10 - fullMap.y) / fullMap.scaleY / 30));
				pointTwo = null;
			}
			//var city:City = new City((e.stageX - e.stageX % 10 - fullMap.x) / fullMap.scaleX, (e.stageY - e.stageY % 10 - fullMap.y) / fullMap.scaleY, environment);
			//fullMap.addChild(city);
			//cities.push(city);
		}
		private function onKeyDown(e:KeyboardEvent):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			for each(var city:City in cities)
			{
				city.onKeyDown(e);
			}
			if (e.ctrlKey) // Cntl Key for restart
			{
				trace("RESTART");
				clearAll();
				generateNew();
			}
			else if (e.keyCode == 189)// Zoom in	
			{
				fullMap.scaleX -= 0.1;
				fullMap.scaleY -= 0.1;
			}
			else if (e.keyCode == 187)// Zoom out
			{
				fullMap.scaleX += 0.1;
				fullMap.scaleY += 0.1;
			}
			else if ( e.keyCode == 81) // Q Key for start/stop generating
			{
				if (buildingCities)
				{
					trace("STOPPED");
					for each(var city2:City in cities)
					{
						city2.stop();
					}
					buildingCities = false;
				}
				else
				{
					trace("STARTED");
					for each(var city3:City in cities)
					{
						city3.start();
					}
					buildingCities = true;
				}
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			deltaPoint = new Point(e.stageX, e.stageY);
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			fullMap.x -= (deltaPoint.x - e.stageX)
			fullMap.y -= (deltaPoint.y - e.stageY)
			deltaPoint = new Point(e.stageX, e.stageY);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
	}
}