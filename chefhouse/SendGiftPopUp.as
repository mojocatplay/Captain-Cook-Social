package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	import com.greensock.*;
	
	import retrieveInfo.*;
	import util.*;
	import loader.*;
	import restaurant.RestaurantScene;
	
	public class SendGiftPopUp extends MovieClip
	{
		private var SendGift_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("SendGift_PopUp"));
		private var quantityArray = [8, 5, 2, 1, 1, 1];
		private var display;
		private var selectIndex = 0;
		
		public function SendGiftPopUp():void
		{
			display = new SendGift_PopUp();
			
			display.addEventListener("done", loadGifts);
			display.sendGiftButt.addEventListener(MouseEvent.CLICK, sendGift);
			display.skipButt.addEventListener(MouseEvent.CLICK, skipGift);
			this.addChild(display);
		}
		
		private function loadGifts(evt:Event):void
		{
			trace(display.selectArray);
			var length = display.selectArray.length;
			var i;
			
			for (i = 0; i<length; ++i)
			{
				display.selectArray[i].addEventListener(MouseEvent.CLICK, showSelect);
				display.selectArray[i].quantityText.text = "x" + quantityArray[i];
			}
			
			display.selectArray[0].alpha = 1;
		}
		
		private function showSelect(evt:MouseEvent):void
		{
			var index = display.selectArray.indexOf(evt.currentTarget as MovieClip);
			var i;
			
			for (i = 0; i<display.selectArray.length; ++i)
			{
				if (i == index)
				{
					display.selectArray[i].alpha = 1;
				}
				else
				{
					display.selectArray[i].alpha = 0.4;
				}
			}
			
			this.selectIndex = index;
		}
		
		private function sendGift(evt:MouseEvent):void
		{
			dispatchEvent(new Event("closeThis"));
		}	
		
		private function skipGift(evt:MouseEvent):void
		{
			dispatchEvent(new Event("closeThis"));
		}	
	}
}