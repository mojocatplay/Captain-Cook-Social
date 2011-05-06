//
//  ChefStatsPopUp
//
//  Created by Minh Pham Tuan on 2010-11-05.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package chefhouse{
	import flash.display.*;
	import flash.events.*;
	
	import restaurant.*;
	import retrieveInfo.*;
	import util.*;

	public class ChefStatsPopUp extends MovieClip
	{	
		private var ChefStats_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("ChefStats_PopUp"));
		
		private var display;
		private var activateTab;
		
		private const MEDAL = 0;
		private const SKILL = 1;
		
		private var medalContainer = new Sprite();
		private var skillContainer = new Sprite();
		
		public function ChefStatsPopUp()
		{
			display = new ChefStats_PopUp();
			
			this.addChild(display);
			
			setUpContents();
			setUpTabs();
			
			display.closeButt.addEventListener(MouseEvent.CLICK, closeThis);
		}
		
		public function updateContent():void
		{
			display.chefLevel.text = "Level " + GlobalVarContainer.getUser().getLevel().toString();
			medalContainer.loadUserBadges();
			skillContainer.updateSkillContent()
		}
		
		private function setUpContents():void
		{
			setUpSkills();
			setUpMedals();
		}
		
		private function setUpMedals():void
		{
			medalContainer = new MedalArchive();
			medalContainer.x = 205;
			medalContainer.y = 75;
			
			medalContainer.scaleX = medalContainer.scaleY = 0.7;
			
			display.addChild(medalContainer);
		}
		
		private function setUpSkills():void
		{
			skillContainer = new SkillsArchive();
			skillContainer.x = 230;
			skillContainer.y = 95;
			
			skillContainer.addEventListener("showConfirm", showConfirm);
			skillContainer.addEventListener("showMaxLevel", showMaxLevel);
			skillContainer.addEventListener("showNeedSkillPoints", showNeedSkillPoints);
			skillContainer.addEventListener("showBuySkill", showBuySkill);
			display.addChild(skillContainer);
		}
		
		private function showBuySkill(evt:Event):void
		{
			this.dispatchEvent(new Event("showBuySkill"));
		}
		
		public function get skillUpgradeNumbers():Array
		{
			return skillContainer.upgradeSkillNumber;
		}
		
		private function showConfirm(evt:Event):void
		{
			this.dispatchEvent(new Event("showConfirm"));
		}	
		
		private function showMaxLevel(evt:Event):void
		{
			this.dispatchEvent(new Event("showMaxLevel"));
		}
		
		private function showNeedSkillPoints(evt:Event):void
		{
			this.dispatchEvent(new Event("showNeedSkillPoints"));
		}
		
		private function setUpTabs():void
		{
			display.medalTab.gotoAndStop("deactivate");
			display.skillTab.gotoAndStop("activate");
			
			activateTab = SKILL;
			
			toggleContent();
			
			display.medalTab.addEventListener(MouseEvent.CLICK, toggleMedalTab);
			display.skillTab.addEventListener(MouseEvent.CLICK, toggleSkillTab);
		}
		
		private function toggleSkillTab(evt:Event):void
		{
			if (activateTab == MEDAL)
			{
				display.medalTab.gotoAndStop("deactivate");
				display.skillTab.gotoAndStop("activate");
				
				activateTab = SKILL;
				
				toggleContent();
			}
		}
		
		private function toggleMedalTab(evt:Event):void
		{
			if (activateTab == SKILL)
			{
				display.medalTab.gotoAndStop("activate");
				display.skillTab.gotoAndStop("deactivate");
				
				activateTab = MEDAL;
				
				toggleContent();
			}
		}	
		
		private function toggleContent():void
		{
			if (activateTab == MEDAL)
			{
				medalContainer.visible = true;
				skillContainer.visible = false;
			}
			else if (activateTab == SKILL)
			{
				medalContainer.visible = false;
				skillContainer.visible = true;
			}
		}	
		
		private function closeThis(evt:Event):void
		{
			this.dispatchEvent(new Event("closeThis"));
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