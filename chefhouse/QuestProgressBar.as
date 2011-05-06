package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	
	import retrieveInfo.*;
	
	public class QuestProgressBar extends Sprite
	{
		private var QuestProgress_Bar:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestProgress_Bar"));
		private var NinjaFriend_Icon:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("NinjaFriend_Icon"));
		private var StealMoney_Icon:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("StealMoney_Icon"));
		private var VisitFriend_Icon:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("VisitFriend_Icon"));
		
		private var display
		private var requirement;
		private var type;
		public var stt;
		private var recipe;
		private var i = 0;
		
		public function QuestProgressBar(type:int, currentProgress:int, requirement:int, recipe:int):void
		{
			display = new QuestProgress_Bar();
			display.askFriendButt.buttonMode = true;

			this.requirement = requirement;
			this.type = type;
			this.recipe = recipe;
			
			showQuestType(type);
			updateProgress(currentProgress);
			this.addChild(display);
		}
		
		private function showQuestType(type:int):void
		{
			var questIcon;
			var ingresArray = RecipeInfo.matchRecipeIngre(recipe);
			if (type == QuestInfo.CAPTUREFRIEND_NINJA)
			{
				questIcon = new NinjaFriend_Icon();
				
				questIcon.x = 7;
				questIcon.y = 7;
			}
			else if (type == QuestInfo.VISIT_FRIEND)
			{
				questIcon = new VisitFriend_Icon();
				
				questIcon.x = 8;
				questIcon.y = 10;
			}
			else if (type == QuestInfo.STEALMONEY_FRIEND)
			{
				questIcon = new StealMoney_Icon();
				
				questIcon.x = 7;
				questIcon.y = 7;
			}
			else if (type == QuestInfo.GETHELP_FRIEND)
			{
				questIcon = IngredientInfo.matchIngreDisplay(ingresArray[i]);
				questIcon.scaleX = questIcon.scaleY = 0.8;
				i++;
				
				//questIcon.x = 7;
				//questIcon.y = 7;
			}
			
			display.addChild(questIcon);
		}
		
		public function updateProgress(currentProgress:int):void
		{
			if (currentProgress < this.requirement)
			{
				display.progressText.text = currentProgress.toString() + "/" + this.requirement.toString();
				display.progress.scaleX = currentProgress/this.requirement;
				display.okSign.visible = false;
				if (this.type == QuestInfo.GETHELP_FRIEND)
				{
					display.askFriendButt.visible = true;
					display.askFriendButt.addEventListener(MouseEvent.CLICK, askFriendToHelp);
				}
				else
				{
					display.askFriendButt.visible = false;
				}
			}
			else
			{
				display.progressText.text = this.requirement.toString() + "/" + this.requirement.toString();
				display.progress.scaleX = 1;
				display.okSign.visible = true;
				display.askFriendButt.visible = false;
			}
		}
		
		private function askFriendToHelp(evt:MouseEvent):void
		{
			try {
				ExternalInterface.call('getHelp');
			}
			catch (errObject:Error){
				trace(errObject.message);
			}
		}
	}
}