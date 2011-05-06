package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import restaurant.*;
	
	public class HireWaiterPopUp extends MovieClip
	{
		private var display;
		private var buttons;
		private var restaurantScene;
		private var HireWaiter_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("HireWaiter_PopUp"));
		
		public function HireWaiterPopUp(theRestaurant:RestaurantScene):void
		{
			restaurantScene = theRestaurant;
			
			display = new HireWaiter_PopUp();
			buttons = [display.hireButt1, display.hireButt2, display.hireButt3];
			
			display.closeButt.addEventListener(MouseEvent.CLICK, closeThis);
			
			for (var i:int = 0; i<buttons.length; ++i)
			{
				buttons[i].addEventListener(MouseEvent.CLICK, chooseWaiter);
			}
			this.addChild(display);
		}
		
		private function chooseWaiter(evt:MouseEvent):void
		{
			var index = buttons.indexOf(evt.currentTarget as MovieClip);
			
			if (index < 2)
			{
				closeThis(null);
				restaurantScene.hireNewNormalWaiter((index+1)*12);
				restaurantScene.countDownHireWaiter((index+1)*12);
			}
			else
			{
				closeThis(null);
				restaurantScene.putSpecialWaiterPopUp();
			}
		}
		
		private function closeThis(evt:MouseEvent):void
		{
			dispatchEvent(new Event("closeThis"));
		}
	}
}