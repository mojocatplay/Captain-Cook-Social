package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import retrieveInfo.*;
	import restaurant.RestaurantScene;
	
	import util.*;
	
	public class BoomzShop extends Sprite
	{
		private var ItemValue:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("ItemValue"));
		private var Boomz_Info:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Boomz_Info"));
		private var display;
		private var boomzContainer;
		private const boomzList:Array = [-1, -2, -3, -4, -5, -101];
		private var boomzArray:Array = new Array();
		private var currentPos = 2;
		private var numScroll;
		private const numBoomzInOneRow = 3;
		private var thisFakeHeight:Number;
		private var boomzInfo;
		
		public function BoomzShop():void
		{
			var BuyBoomz_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("BuyBoomz_PopUp"));
			display = new BuyBoomz_PopUp();
			thisFakeHeight = display.height;
			this.addChild(display);
			loadAllBoomz();
			
			display.closeButt.addEventListener(MouseEvent.CLICK, closeShop, false, 0, true);
			
			boomzInfo = new Boomz_Info();
			//display.scrollUpButt.addEventListener(MouseEvent.CLICK, scrollListUp, false, 0, true);
			//display.scrollDownButt.addEventListener(MouseEvent.CLICK, scrollListDown, false, 0, true);
		}
		
		private function loadAllBoomz():void
		{
			boomzContainer = new Sprite();
			boomzContainer.x = 37;
			boomzContainer.y = 59;
			display.addChild(boomzContainer);
			boomzContainer.mask = display.boomzMask;
			
			var length = boomzList.length;
			for (var i = 0; i<length; ++i)
			{
				var lockBoomz:Boolean = GlobalVarContainer.getUser().getLevel() < BoomzInfo.matchBoomzLevelRequire(boomzList[i]);
				
				var boomzContainerInfo = new BoomzShopInfo(boomzList[i], lockBoomz);
				boomzContainerInfo.x = (i%numBoomzInOneRow)*177;
				boomzContainerInfo.y = int(i/numBoomzInOneRow)*146;
				boomzContainerInfo.boomzIndex = i;
				boomzContainer.addChild(boomzContainerInfo);
				boomzContainerInfo.addEventListener(MouseEvent.MOUSE_OVER, showBoomzInfo, false,  0, true);
				if (!lockBoomz)
				{
					boomzContainerInfo.addEventListener(MouseEvent.CLICK, buyBoomz, false, 0, true); 
				}
			}
			
			numScroll = int(length/numBoomzInOneRow) + 1;
		}
		
		private function showBoomzInfo(evt:MouseEvent):void
		{
			var boomzContainer = Sprite(evt.currentTarget);
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, showBoomzInfo);
			boomzInfo.x = boomzContainer.x + 75 + 37;
			boomzInfo.y = boomzContainer.y + 123 + 59;
			if (evt.currentTarget.lock)
			{
				boomzInfo.descriptionText.text = "Unlock at level " + BoomzInfo.matchBoomzLevelRequire(boomzList[evt.currentTarget.boomzIndex]);
			}
			else
			{
				boomzInfo.descriptionText.text = BoomzInfo.matchBoomzDescription(boomzList[evt.currentTarget.boomzIndex]);
			}
			display.addChild(boomzInfo);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, hideBoomzInfo);
		}
		
		private function hideBoomzInfo(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, hideBoomzInfo);
			if (boomzInfo && display.contains(boomzInfo))
			{
				display.removeChild(boomzInfo);
			}
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, showBoomzInfo);
		}
		
		private function scrollListUp(evt:MouseEvent):void
		{
			if (currentPos > 2)
			{
				boomzContainer.y += 126;
				currentPos--;
			}
		}
		
		private function scrollListDown(evt:MouseEvent):void
		{
			if (currentPos < numScroll)
			{
				boomzContainer.y -= 126;
				currentPos++;
			}
		}
		
		private function buyBoomz(evt:MouseEvent):void
		{
			var index = evt.currentTarget.boomzIndex;
			var restaurant = RestaurantScene(this.parent);
			RestaurantScene(restaurant).removeBoomzShop();
			RestaurantScene(restaurant).addSpecificBoomzShop(boomzList[index]);
		}
		
		private function closeShop(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).removeBoomzShop();
		}
		
		override public function get height():Number
		{
			return thisFakeHeight;
		}
	}
}