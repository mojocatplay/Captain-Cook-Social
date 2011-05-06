//
//  MaxSkillLevelPopUp
//
//  Created by Minh Pham Tuan on 2010-11-14.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	
	public class MaxSkillLevelPopUp extends MovieClip
	{
		private var display;
		private var MaxSkillLevel_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("MaxSkillLevel_PopUp"));
		
		
		public function MaxSkillLevelPopUp()
		{
			display = new MaxSkillLevel_PopUp();
			display.closeButt.addEventListener(MouseEvent.CLICK, closeThis);
			
			this.addChild(display);
		}
		
		private function closeThis(evt:Event):void
		{
			dispatchEvent(new Event("closeThis"));
		}
		
		override public function get height():Number
		{
			return display.background.height;
		}
		
		override public function get width():Number
		{
			return display.background.width;
		}
	}
}