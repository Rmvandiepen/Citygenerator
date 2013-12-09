package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Rob van Diepen
	 */
	public class Environment extends Sprite
	{
		
		private var _landscape:Array = [];
		private var newLandscape:Array = [];
		private	var	_numPxWidth:int = 50;
		private	var	_numPxHeight:int = 50;
		private	var	_pxWidth:int = 30;
		private	var	_pxHeight:int = 30;
		public function Environment() 
		{
			createEnvironment();
		}
		public function cleanEnvironment():void
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			
			_landscape = [];
			createEnvironment();
		}
		private function createEnvironment():void
		{
			for (var x:int = 0; x < _numPxWidth; x++) 
			{
				landscape.push([]);
				newLandscape.push([]);
				for (var y:int = 0; y < _numPxHeight; y++) 
				{
					var sprite:Tile = new Tile(pxWidth,pxHeight);
					sprite.drawTile();
					sprite.x = x * pxWidth;
					sprite.y = y * pxHeight;
					this.addChild(sprite);
					landscape[x].push(sprite);
					newLandscape[x].push(0);
				}
			}
			for (var i:int = 0; i < 4; i++) 
			{
				checkMostNeighbors(12 - i*2);
			}
		}
		
		private function checkMostNeighbors(size:int):void
		{
			for (var j:int = 0; j < _numPxWidth; j++) 
			{
				for (var k:int = 0; k < _numPxHeight; k++) 
				{
					var countType:Array = [0, 0, 0, 0, 0];
					for (var i:int = 0 - ((size -1)/2); i <  ((size -1)/2); i++) 
					{
						for (var i2:int = 0 - ((size -1)/2); i2 <  ((size -1)/2); i2++) 
						{
							if(j+i  > 0 && j+i < _numPxWidth-1 && k+i2 > 0 && k+i2 < _numPxHeight-1)
								countType[(landscape[j+i][k+i2] as Tile).type]++;
						}
					}
					
					var highest:int = 0;
					var count:int = 0;
					for (var n:int = 1; n <= 5 ; n++) 
					{
						if (countType[n] > highest)
						{
							highest = countType[n];
							count = n;
						}
					}
					newLandscape[k][j] = count;
				}
			}
			for (var l:int = 0; l < _numPxWidth; l++) 
			{
				for (var m:int = 0; m < _numPxHeight; m++) 
				{
					(landscape[l][m] as Tile).changeTile(newLandscape[m][l]);
				}
			}
		}
		
		public function get pxWidth():int 
		{
			return _pxWidth;
		}
		
		public function get pxHeight():int 
		{
			return _pxHeight;
		}
		
		public function get landscape():Array 
		{
			return _landscape;
		}
		
		public function get numPxHeight():int 
		{
			return _numPxHeight;
		}
		
		public function get numPxWidth():int 
		{
			return _numPxWidth;
		}
	}

}