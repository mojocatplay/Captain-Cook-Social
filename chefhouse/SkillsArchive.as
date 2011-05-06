//
//  SkillsArchive
//
//  Created by Minh Pham Tuan on 2010-11-06.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	
	import retrieveInfo.*;
	import util.*;

	public class SkillsArchive extends MovieClip
	{
		private var Skill_Info:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Skill_Info"));
		private var Skill_Stat:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Skill_Stat"));
		private var SkillInfo_Bubble:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("SkillInfo_Bubble"));
		
		private var display;
		
		private var userSkills = GlobalVarContainer.getUser().getSkills();

		private var skillSet = [BoomzInfo.SHUFFLE_SKILL, BoomzInfo.ROW_SKILL, BoomzInfo.CROSS_SKILL, BoomzInfo.TYPE_SKILL, BoomzInfo.SQUARE_SKILL];
		private var skillArray = [];
		
		private var skillInfoBubble = new SkillInfo_Bubble();
		
		public var upgradeSkillNumber = [];
		
		public function SkillsArchive()
		{
			display = new Skill_Info();
			display.buyMoreButt.addEventListener(MouseEvent.CLICK, buyMoreSkill);
			this.addChild(display);
			
			setUpSkillStats();
		}
		
		private function buyMoreSkill(evt:Event):void
		{
			dispatchEvent(new Event("showBuySkill"));
		}
		
		private function setUpSkillStats():void
		{
			display.skillInfoText.text = "Click on a skill to upgrade it. Skill points left: " + GlobalVarContainer.getUser().getSkillPoints().toString() + "x ";
			
			for (var i:int = 0; i<skillSet.length; ++i)
			{
				var skillStat = new Skill_Stat();
				
				var skillRep = BoomzInfo.matchBoomzDisplay(skillSet[i]);
				skillStat.addChild(skillRep);
				
				skillStat.skillRep = skillRep;
				skillStat.skillName.text = BoomzInfo.matchSkillName(skillSet[i]);
				
				if (userSkills[i] == 0)
				{
					skillRep.gotoAndStop("deactivate");
				}
				
				skillStat.skillLevel.gotoAndStop(Number(userSkills[i]) + 1);
				
				skillStat.x = 6 + (i%2)*190;
				skillStat.y = 30 + int(i/2)*50;
				
				skillStat.buttonMode = true;
				skillStat.mouseChildren = false;
				
				skillStat.addEventListener(MouseEvent.MOUSE_OVER, showStats);
				skillStat.addEventListener(MouseEvent.CLICK, upgradeSkill);
				
				skillStat.skill = skillSet[i];
				skillStat.level = userSkills[i];
				
				display.addChild(skillStat);
				skillArray.push(skillStat);
			}
		}
		
		private function showStats(evt:Event):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, showStats);
			var index = skillArray.indexOf(evt.currentTarget);
			var unlockText:String;
			
			if (userSkills[index] == 0)
			{
				unlockText = " to unlock";
			}
			else
			{
				unlockText = " to upgrade";
			}
			
			if (userSkills[index] < 3)
			{
				skillInfoBubble.unlockText.text = "x" + BoomzInfo.matchSkillUpgradeRequirement(skillSet[index])[userSkills[index]] + unlockText;
			}
			else
			{
				skillInfoBubble.unlockText.text = "At max level";
			}
			
			skillInfoBubble.skillDescription.text = BoomzInfo.matchBoomzDescription(skillSet[index]);
			skillInfoBubble.nextLevelText.text = BoomzInfo.matchNextSkillLevelDescription(skillSet[index], userSkills[index]);
			
			skillInfoBubble.x = 18 + evt.currentTarget.x;
			skillInfoBubble.y = 35 + evt.currentTarget.y;
			
			skillInfoBubble.visible = true;
			
			display.addChild(skillInfoBubble);
			
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, hideStats);
		}
		
		public function updateSkillContent():void
		{
			userSkills = GlobalVarContainer.getUser().getSkills();
			display.skillInfoText.text = "Click on a skill to upgrade it. Skill points left: " + GlobalVarContainer.getUser().getSkillPoints().toString() + "x ";
			
			for (var i:int; i<skillArray.length; ++i)
			{
				if(userSkills[i] == 0)
				{
					skillArray[i].skillRep.gotoAndStop("deactivate");
				}
				else
				{
					skillArray[i].skillRep.gotoAndStop(1);
				}
				
				skillArray[i].skillLevel.gotoAndStop(Number(userSkills[i]) + 1);
			}
		}
		
		private function hideStats(evt:Event):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, hideStats);
			skillInfoBubble.visible = false;
			if (skillInfoBubble && display.contains(skillInfoBubble))
			{
				display.removeChild(skillInfoBubble);
			}
			
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, showStats);
		}
		
		private function upgradeSkill(evt:Event):void
		{
			trace("skill", GlobalVarContainer.getUser().getSkillPoints(), BoomzInfo.matchSkillUpgradeRequirement(evt.currentTarget.skill)[evt.currentTarget.level]);
			trace("level", evt.currentTarget.level);
			if (evt.currentTarget.level < 3)
			{
				if (GlobalVarContainer.getUser().getSkillPoints() >= BoomzInfo.matchSkillUpgradeRequirement(evt.currentTarget.skill)[evt.currentTarget.level])
				{
					trace("saf");
					upgradeSkillNumber = [evt.currentTarget.skill, evt.currentTarget.level];
					dispatchEvent(new Event("showConfirm"))
				}
				else
				{
					dispatchEvent(new Event("showNeedSkillPoints"));
				}
			}
			else
			{
				trace("shit");
				dispatchEvent(new Event("showMaxLevel"));
			}
		}
	}
}