package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import retrieveInfo.*;
	import restaurant.RestaurantScene;
	import util.*;
	import loader.*;
	
	public class BuySkillPointsPopUp extends MovieClip
	{
		private var display;

		private var boomzType;
		private var quantity:int = 1;
		
		private var BuySkillPoint_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("BuySkillPoint_PopUp"));
				
		public function BuySkillPointsPopUp():void
		{
			display = new BuySkillPoint_PopUp();
			this.addChild(display);

			display.amountMoney.text = "5";
			display.totalAmountMoney.text = (5*int(display.numSkillPoint.text)).toString();

			display.numSkillPoint.addEventListener(KeyboardEvent.KEY_UP, updateTotal, false, 0, true);
			display.increaseButt.addEventListener(MouseEvent.CLICK, increaseTotal, false, 0, true);
			display.decreaseButt.addEventListener(MouseEvent.CLICK, decreaseTotal, false, 0, true);
			
			display.buyButt.addEventListener(MouseEvent.CLICK, hireWaiter, false, 0, true);
			display.notNowButt.addEventListener(MouseEvent.CLICK, goBack, false, 0, true);
			
			display.numSkillPoint.restrict = "0-9";
		}
		
		private function updateTotal(evt:KeyboardEvent = null):void
		{
			quantity = int(display.numSkillPoint.text);
			display.totalAmountMoney.text = (5 * quantity).toString();
		}
		
		private function increaseTotal(evt:MouseEvent):void
		{
			display.numSkillPoint.text++;
			updateTotal();
		}
		
		private function decreaseTotal(evt:MouseEvent):void
		{
			if (int(display.numSkillPoint.text) > 0)
			{
				display.numSkillPoint.text--;
				updateTotal();
			}
		}
		
		private function hireWaiter(evt:MouseEvent):void
		{
			
			goBack(null);
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
			dispatchEvent(new Event("closeThis"));
/*			RestaurantScene(this.parent).closeBuySkillPointsPopUp(this as MovieClip);
*/		}
	}
}