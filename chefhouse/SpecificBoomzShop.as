package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import retrieveInfo.*;
	import restaurant.RestaurantScene;
	import util.*;
	import loader.*;
	
	public class SpecificBoomzShop extends Sprite
	{
		private var display;
		private var priceTotalDisplay;
		private var priceDisplay;
		private var boomzType;
		private var quantity:int = 1;
		
		private var SpecificBoomz_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("SpecificBoomz_PopUp"));
		private var ItemValue:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("ItemValue"));
		
		public function SpecificBoomzShop(boomzType:int):void
		{
			this.boomzType = boomzType;
			display = new SpecificBoomz_PopUp();
			this.addChild(display);
			
			display.typeBoomzText.text = BoomzInfo.matchBoomzName(boomzType);
			
			var boomzDisplay = BoomzInfo.matchBoomzDisplay(boomzType);
			boomzDisplay.scaleX = 1.85;
			boomzDisplay.scaleY = 1.85;
			boomzDisplay.x = 43.5;
			boomzDisplay.y = 51;
			display.addChild(boomzDisplay);
			
			priceDisplay = new ItemValue();
			priceDisplay.scaleX = priceDisplay.scaleY = 1.3;
			priceDisplay.x = 321;
			priceDisplay.y = 65;
			priceDisplay.amountMoney.text = BoomzInfo.matchBoomzValue(boomzType).toString();
			display.addChild(priceDisplay);
			
			priceTotalDisplay = new ItemValue();
			priceTotalDisplay.scaleX = priceTotalDisplay.scaleY = 1.3;
			priceTotalDisplay.x = 321;
			priceTotalDisplay.y = 111;
			priceTotalDisplay.amountMoney.text = (BoomzInfo.matchBoomzValue(boomzType)*int(display.quantityBoomz.text)).toString();
			display.addChild(priceTotalDisplay);
			
			display.quantityBoomz.addEventListener(KeyboardEvent.KEY_UP, updateTotal, false, 0, true);
			display.increaseButt.addEventListener(MouseEvent.CLICK, increaseTotal, false, 0, true);
			display.decreaseButt.addEventListener(MouseEvent.CLICK, decreaseTotal, false, 0, true);
			
			display.buyButt.addEventListener(MouseEvent.CLICK, buyBoomz, false, 0, true);
			display.backButt.addEventListener(MouseEvent.CLICK, goBack, false, 0, true);
			
			display.quantityBoomz.restrict = "0-9";
		}
		
		private function updateTotal(evt:KeyboardEvent = null):void
		{
			quantity = int(display.quantityBoomz.text);
			priceTotalDisplay.amountMoney.text = (BoomzInfo.matchBoomzValue(boomzType) * quantity).toString();
		}
		
		private function increaseTotal(evt:MouseEvent):void
		{
			display.quantityBoomz.text++;
			updateTotal();
		}
		
		private function decreaseTotal(evt:MouseEvent):void
		{
			if (int(display.quantityBoomz.text) > 0)
			{
				display.quantityBoomz.text--;
				updateTotal();
			}
		}
		
		private function buyBoomz(evt:MouseEvent):void
		{
			//check for money here
			var userMoney = GlobalVarContainer.getUser().getMoney();
			var boomValue = BoomzInfo.matchBoomzValue(boomzType);
			
			var totalDue = boomValue * quantity;
			if (userMoney < totalDue) {
				var needMoneyPopUp = new NeedMoneyPopUp();
				RestaurantScene(this.parent).putPopUpWithOverlay(needMoneyPopUp);
			}
			else {
				var tmpBoomzType = Math.abs(boomzType);
				var params = [tmpBoomzType, quantity];
				var remoteClass:String = 'UsersController';
				var remoteMethod:String = 'buyBoom';
				var onResult:Function = buyBoomSuccess;
				var onFault:Function = buyBoomFail;
				HttpLoader.load(remoteClass, remoteMethod, onResult, onFault, params);
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
			RestaurantScene(this.parent).goBackBoomzShop();
		}
	}	
}