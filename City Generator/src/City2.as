package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Hugo
	 */
	public class City2 extends Sprite
	{
		private var _environment:Environment;
		
		private var _roads:Array;
		
		//keyboardvars
		private var _frame:int = 0;
		private var _frames:int = 0;
		private var _superSpeed:int = 1;
		private var _started:Boolean = false;
		private var _cityStartPoint:Point;
		
		public function City2(cityStart:Point, environment:Environment) 
		{
			this._roads = new Array();
			this._environment = environment;
			this._cityStartPoint = cityStart;
		}
		
		public function cleanCity():void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			for (var i:int = 0; i < _roads.length; i++) _roads.pop();
			
			this._roads = new Array();
		}
		
		private function init()
		{
			
		}
		
		private function update(e:Event):void
		{
			
		}
		
	}

}