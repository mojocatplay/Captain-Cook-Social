package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import retrieveInfo.*;
	import util.*;
	
	public class NewQuestNotification extends Sprite
	{
		private var NewChefQuest_Background:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("NewChefQuest_Background"));
		private var display;
		public var quest = -1;
		
		public function NewQuestNotification(quest:int):void
		{
			display = new NewChefQuest_Background();
			changeChefFace(quest);
			changeChefQuest(quest);
			this.addChild(display);
		}
		
		private function changeChefFace(quest:int):void
		{
			var chef = ChefInfo.matchChefQuestFace(QuestInfo.matchQuestChef(quest));
			chef.x = 227.90;
			chef.y = 3.9;
			display.addChild(chef);
		}
		
		private function changeChefQuest(quest:int):void
		{
			display.questNameBubble.changeText(QuestInfo.matchQuestName(quest));
//			display.questNameBubble.questNameText = QuestInfo.matchQuestName(quest);
		}
	}
}