//
//  StealInstructionPopUp
//
//  Created by Minh Pham Tuan on 2010-11-21.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	
	public class StealInstructionPopUp extends MovieClip
	{
		private var StealInstruction_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("StealInstruction_PopUp"));
		private var display;
		
		function StealInstructionPopUp()
		{
			display = new StealInstruction_PopUp();
			display.closeButt.addEventListener(MouseEvent.CLICK, function(evt:Event){dispatchEvent(new Event("closeThis"));});
			this.addChild(display);
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
