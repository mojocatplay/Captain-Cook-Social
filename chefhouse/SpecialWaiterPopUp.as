package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import retrieveInfo.*;
	import restaurant.RestaurantScene;
	import util.*;
	import loader.*;
	
	public class SpecialWaiterPopUp extends MovieClip
	{
		private var display;
		private var priceTotalDisplay;
		private var priceDisplay;
		private var boomzType;
		private var quantity:int = 1;
		
		private var ItemValue:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("ItemValue"));
		private var SpecialWaiter_PopUp:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("SpecialWaiter_PopUp"));
				
		public function SpecialWaiterPopUp():void
		{
			display = new SpecialWaiter_PopUp();
			this.addChild(display);
			
			trace(display.numWaiterText);
			priceDisplay = new ItemValue();
			priceDisplay.scaleX = priceDisplay.scaleY = 1.5;
			priceDisplay.x = 301;
			priceDisplay.y = 65;
			priceDisplay.amountMoney.text = "1000";
			display.addChild(priceDisplay);

			priceTotalDisplay = new ItemValue();
			priceTotalDisplay.scaleX = priceTotalDisplay.scaleY = 1.5;
			priceTotalDisplay.x = 301;
			priceTotalDisplay.y = 111;
			priceTotalDisplay.amountMoney.text = (1000*int(display.numWaiterText.text)).toString();
			display.addChild(priceTotalDisplay);
			trace(priceDisplay, priceTotalDisplay);
			display.numWaiterText.addEventListener(KeyboardEvent.KEY_UP, updateTotal, false, 0, true);
			display.increaseButt.addEventListener(MouseEvent.CLICK, increaseTotal, false, 0, true);
			display.decreaseButt.addEventListener(MouseEvent.CLICK, decreaseTotal, false, 0, true);
			
			display.hireButt.addEventListener(MouseEvent.CLICK, hireWaiter, false, 0, true);
			display.backButt.addEventListener(MouseEvent.CLICK, goBack, false, 0, true);
			
			display.numWaiterText.restrict = "0-9";
		}
		
		private function updateTotal(evt:KeyboardEvent = null):void
		{
			quantity = int(display.numWaiterText.text);
			priceTotalDisplay.amountMoney.text = (1000 * quantity).toString();
		}
		
		private function increaseTotal(evt:MouseEvent):void
		{
			display.numWaiterText.text++;
			updateTotal();
		}
		
		private function decreaseTotal(evt:MouseEvent):void
		{
			if (int(display.numWaiterText.text) > 0)
			{
				display.numWaiterText.text--;
				updateTotal();
			}
		}
		
		private function hireWaiter(evt:MouseEvent):void
		{
			//check for money here
			var userMoney = GlobalVarContainer.getUser().getMoney();
			var waiterValue = 1000
			
			var totalDue = waiterValue * quantity;
			if (userMoney < totalDue) {
				var needMoneyPopUp = new NeedMoneyPopUp();
				RestaurantScene(this.parent).putPopUpWithOverlay(needMoneyPopUp);
			}
			else {
				if (RestaurantScene(this.parent).hireSpecialWaiter(quantity))
				{
					RestaurantScene(this.parent).countDownHireWaiter(24);
				}
				goBack(null);
			}
		}
				
		private function buyBoomSuccess(object:*) {
			//update the boomz list and quantity
			RestaurantScene(this.parent).addBoomz(boomzType, quantity);
			var total = BoomzInfo.matchBoomzValue(boomzType) * quantity;
			GlobalVarContainer.indexInstant.addMoney(0 - total);
			RestaurantScene(this.parent).buyBoomSuccess();			
			trace('buyBoomSuccess');
		}
		private function buyBoomFail(object:*) {
			//show problem box
			trace('buyBoomFail');
		}
		
		private function goBack(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).closeSpecialWaiterPopUp(this as MovieClip);
		}
	}
}