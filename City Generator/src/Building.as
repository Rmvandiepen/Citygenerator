package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Building extends Sprite
	{
		
		private var var1:int = 0;
		private var var2:int = 0;
		
		public function Building(maxWidth:int, maxHeight:int) 
		{
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawRect(0, 0, maxWidth, maxHeight);
			this.graphics.endFill();
			var maxSize:int = maxWidth * maxHeight;
			var curSize:int = 0;
				
			
			var centerWidth:int = Math.random() * maxWidth * 0.30 + (maxWidth * 0.5);
			var centerHeight:int = Math.random() * maxHeight * 0.30 + (maxHeight * 0.5);
			var centerX:int = Math.random() * (maxWidth - centerWidth);
			var centerY:int = Math.random() * (maxHeight - centerHeight);
			
			this.graphics.beginFill(0xff0000);
			this.graphics.drawRect(centerX, centerY, centerWidth, centerHeight);
			this.graphics.endFill();
			
			curSize += partWidth * partHeight;
			for (var i:int = 0; i < 3; i++)
			{
				var partWidth:int;
				var partHeight:int;
				var partX:int = 0;
				var partY:int = 0;
				if (Math.random() * 2 < 1)
				{
					partWidth = Math.random() * (centerWidth * 0.5) + (centerWidth * 0.5);
					partHeight = centerHeight/2;
					if (Math.random() * 2 < 1)
					{
						partX = Math.random() * (partWidth/2) + centerX - partWidth;
						if (partX < 0)
						{
							partX = 0
						}
					}
					else
					{
						partX = Math.random() * (partWidth/2) + centerX + centerWidth - partWidth;
						if (partX + partWidth > maxWidth)
						{
							partX = maxWidth - partWidth;
						}
					}
					partY = centerY + centerHeight/2 + Math.random() * partHeight - partHeight/2;
				}
				else
				{
					partWidth = centerWidth/2;
					partHeight = Math.random() * (centerHeight * 0.5) + (centerHeight * 0.5);
					if (Math.random() * 2 < 1)
					{
						partY = Math.random() * (partHeight / 2) + centerY - partHeight;
						if (partY < 0)
						{
							partY = 0
						}
					}
					else
					{
						partY = Math.random() * (partHeight / 2) + centerY + centerHeight - partHeight;
						if (partY + partHeight > maxHeight)
						{
							partY = maxHeight - partHeight;
						}
					}
					partX = centerX + centerWidth / 2 + Math.random() * partWidth - partWidth/2;
				}
				
				this.graphics.beginFill(0xff0000);
				this.graphics.drawRect(partX, partY, partWidth, partHeight);
				this.graphics.endFill();
				curSize += partWidth * partHeight
			}
		}
	}
}