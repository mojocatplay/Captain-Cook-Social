package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import retrieveInfo.*;
	import util.*;
	
	public class ChefQuestDialog extends MovieClip
	{
		private var display;
		private var quest;
		private var chef;
		
		private var NewQuestRobin_ChefQuest:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("NewQuestRobin_ChefQuest"));
		private var NewQuestKlaus_ChefQuest:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("NewQuestKlaus_ChefQuest"));
		private var NewQuestMarciel_ChefQuest:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("NewQuestMarciel_ChefQuest"));
		
		public function ChefQuestDialog(chef:int, quest:int = 1001):void
		{
			this.quest = quest;
			this.chef = chef;
			
			switch (chef)
			{
				case ChefInfo.CHEF_ROBIN:
				display = new NewQuestRobin_ChefQuest();
				break;
				case ChefInfo.CHEF_KLAUS:
				display = new NewQuestKlaus_ChefQuest();
				break;
				case ChefInfo.CHEF_MARCIEL:
				display = new NewQuestMarciel_ChefQuest();
				break;
			}
			display.chefDialogText.text = "";
			display.questTitle.text = "";
			
			loadQuestTitle(quest);
			loadChefDialog(quest);
			display.addEventListener("next", showNext);
			this.addChild(display);
		}
		
		private function loadQuestTitle(quest:int):void
		{
			display.questTitle.text = QuestInfo.matchQuestName(quest);
		}
		
		private function loadChefDialog(quest:int):void
		{
			var textString:String = QuestInfo.matchQuestSetInfo(quest);
			if (textString.length < 100)
			{
				display.chefDialogText.y += 30;
			}
			
			TypewritingEffect.makeTypewritingEffect(display.chefDialogText, textString, this);
		}
		
		private function showNext(evt:Event):void
		{
			display.removeEventListener("next", showNext);
			//dispatchEvent(new Event("next"));
		}
	}
}