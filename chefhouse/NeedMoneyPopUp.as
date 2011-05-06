package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	
	import retrieveInfo.*;
	import util.*;
	import loader.*;
	import restaurant.RestaurantScene;
	
	public class NeedMoneyPopUp extends MovieClip
	{
		private var NeedMoney_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("NeedMoney_PopUp"));
		
		private var display;
		public function NeedMoneyPopUp():void
		{
			display = new NeedMoney_PopUp();
			display.hicButt.addEventListener(MouseEvent.CLICK, closeMe);
			display.addCoinButt.addEventListener(MouseEvent.CLICK, closeMe);
			
			this.addChild(display);
		}
		
		private function closeMe(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, closeMe);
			if (this.parent)
			{
				RestaurantScene(this.parent).removePopUpWithOverlay(this);
			}
		}
	}
}