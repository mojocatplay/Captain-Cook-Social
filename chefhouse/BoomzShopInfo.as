package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	
	import retrieveInfo.*;
	import util.*;
	import loader.*;
	import restaurant.RestaurantScene;
	
	public class BoomzShopInfo extends MovieClip
	{
		private var BoomzContainer_Info:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("BoomzContainer_Info"));
		private var display;
		private var boomzDisplay;
		
		public var boomzIndex = 0;
		
		public var lock:Boolean = false;
		
		public function BoomzShopInfo(boomzType:int, lock:Boolean = false):void
		{
			display = new BoomzContainer_Info();
			display.boomzLock.visible = lock;
			this.lock = lock;
			display.boomzNameText.text = BoomzInfo.matchBoomzName(boomzType);
			display.itemValue.amountMoney.text = BoomzInfo.matchBoomzValue(boomzType).toString();
			
			boomzDisplay = BoomzInfo.matchBoomzDisplay(boomzType);
			boomzDisplay.scaleX = 1;
			boomzDisplay.scaleY = 1;
			boomzDisplay.x = 51.85;
			boomzDisplay.y = 36.2;
			
			display.addChild(boomzDisplay);
			this.addChild(display);
			this.buttonMode = true;
			this.mouseChildren = false;
		}
	}
}