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
		public static const MIN_ROAD_LENGTH:int = 50;
		public static const NUM_ROAD_STEPS:int = 2;
		public static const MAX_ROAD_LENGTH:int = 100;
		public static const SIZE:int = 300;
		
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
		private function createRoad2(key:String)
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
		}
		private function onMouseClick(e:MouseEvent):void 
		{
			var city:City = new City((e.stageX - e.stageX % 10 - fullMap.x) / fullMap.scaleX, (e.stageY - e.stageY % 10 - fullMap.y) / fullMap.scaleY, environment);
			fullMap.addChild(city);
			cities.push(city);
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