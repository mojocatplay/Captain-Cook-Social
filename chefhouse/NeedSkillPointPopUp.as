//
//  NeedSkillPointPopUp
//
//  Created by Minh Pham Tuan on 2010-11-13.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package chefhouse{
	import flash.display.*;
	import flash.events.*;
	
	public class NeedSkillPointPopUp extends MovieClip
	{
		private var display;
		
		private var NeedSkillPoint_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("NeedSkillPoint_PopUp"));
		
		public function NeedSkillPointPopUp()
		{
			display = new NeedSkillPoint_PopUp();
			display.buyMoreButt.addEventListener(MouseEvent.CLICK, buySkillPoints);
			display.skipButt.addEventListener(MouseEvent.CLICK, closeNeedSkillPoint);
			
			this.addChild(display);
		}
		
		private function buySkillPoints(evt:Event):void
		{
			dispatchEvent(new Event("buySkillPoints"));
		}
		
		private function closeNeedSkillPoint(evt:Event):void
		{
			dispatchEvent(new Event("closeNeedSkillPoint"));
		}
		
		override public function get width():Number
		{
			return display.background.width;
		}
		
		override public function get height():Number
		{
			return display.background.height;
		}
	}
}
