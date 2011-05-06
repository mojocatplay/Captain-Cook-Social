//
//  UpgradeSkillConfirmPopUp
//
//  Created by Minh Pham Tuan on 2010-11-08.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import util.*;
	import retrieveInfo.*;
	
	public class UpgradeSkillConfirmPopUp extends MovieClip
	{
		private var ConfirmBuySkill_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("ConfirmBuySkill_PopUp"));
		private var display;
		
		private var skillDisplay;
		
		private var skill;
		private var level;
		
		public function UpgradeSkillConfirmPopUp(skill:int, level:int):void
		{
			var upgrade:Boolean = level>0?true:false;
			
			this.skill = skill;
			this.level = level;
			
			display = new ConfirmBuySkill_PopUp();
			if (upgrade)
			{
				display.title.text = "Upgrade skill";
				display.askText.text = "Do you want to upgrade this skill?";
			}
			else
			{
				display.title.text = "Unlock skill";
				display.askText.text = "Do you want to unlock this skill?";
			}
			
			skillDisplay = BoomzInfo.matchBoomzDisplay(skill);
			skillDisplay.width = skillDisplay.height = 60;
			skillDisplay.x = 183.8;
			skillDisplay.y = 62.2;
			
			display.numSkillPoints.text = "x " + BoomzInfo.matchSkillUpgradeRequirement(skill)[level].toString();
			
			display.addChild(skillDisplay);
			display.yesButt.addEventListener(MouseEvent.CLICK, upgradeSkill);
			display.noButt.addEventListener(MouseEvent.CLICK, closeThis);
			this.addChild(display);
		}
		
		private function upgradeSkill(evt:Event):void
		{
			GlobalVarContainer.getUser().upgradeSkill(skill, level);
			closeThis(null);
		}
		
		private function closeThis(evt:Event):void
		{
			this.dispatchEvent(new Event("closeThis"));
		}
	}
}