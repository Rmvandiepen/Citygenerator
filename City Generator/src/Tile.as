package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Rob van diepen
	 */
	public class Tile extends Sprite
	{
		private var _type:int;
		private var _width:int;
		private var _height:int;
		public function Tile(w:int, h:int) 
		{
			_width = w;
			_height = h;
		}
		public function drawTile(type:uint = 0):void
		{
			var num:int = type;
			var color:uint;
			if (num == 0)
			{
				var num2:int = Math.random() * 200;
				if ( num2 < 101)
				{
					num = 1
				}
				else if ( num2 < 200)
				{
					num = 2;
				}
				else if ( num2 < 300)
				{
					num = 3;
				}
				else if ( num2 < 400)
				{
					num = 4;
				}
				else if ( num2 < 500)
				{
					num = 5;
				}
			}
			switch(num)
			{
				case 1:
					color = 0x00ff00
					break;
					
				case 2:
					color = 0x0000ff;
					break;
					
				case 3:
					color = 0xaaaaaa;
					break;
					
				case 4:
					color = 0xff0000;
					break;
					
				case 5:
					color = 0xffff00;
					break;
			}
			this.graphics.beginFill(color);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
			_type = num;
		}
		public function changeTile(type:uint):void
		{
			this.graphics.clear();
			drawTile(type)
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}
		
	}

}