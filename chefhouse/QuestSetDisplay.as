package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import retrieveInfo.*;
	import util.*;
	import flash.external.ExternalInterface;
	
	public class QuestSetDisplay extends Sprite
	{
		private var QuestSet_Background:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestSet_Background"));
		private var QuestDone_Symbol:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestDone_Symbol"));
		private var QuestInfo_Bubble:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestInfo_Bubble"));
		private var BeatMe_Bubble:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("BeatMe_Bubble"));
		
		private var questProgressDisplayArray:Array;
		private var questRepArray:Array = [];
		
		private var display;
		private var userQuests:Array;
		private var userQuestsRequirement:Array;
		private var questSet;
		private var questSetIndex;
		
		private var offsetIndex;
		private var questInfoBubble = new QuestInfo_Bubble();
		private var beatMeBubble = new BeatMe_Bubble();
		
		private var ingreArray;
		private var ingreIndex:int = 0;
		
		private var questPresentation;
		
		private var dishToSelect:int = -1;
		
		public function QuestSetDisplay(questSet:int, questSetIndex:int):void
		{
			this.questSet = questSet;
			this.questSetIndex = questSetIndex;
			if (questSet < 1000)
			{
				ingreArray = RecipeInfo.matchRecipeIngre(questSet);
			}
			
			questInfoBubble.mouseEnabled = false;
			beatMeBubble.mouseEnabled = false;
			
			display = new QuestSet_Background();
			questProgressDisplayArray = [display.questProgress1, display.questProgress2, display.questProgress3, display.questProgress4];
			setUpQuestPresentation();
			setUpQuestList();
			if (checkSpecialRecipe())
			{
				display.gotoAndStop(2);
			}
			
			this.addChild(display);
		}
		
		private function setUpQuestPresentation():void
		{
			questPresentation = QuestInfo.matchQuestPresentation(questSet);
			//questPresentation.scaleY = questPresentation.scaleX = 73.15/questPresentation.width;
			if (questSet < 1000)
			{
				questPresentation.x = 16.8;
				questPresentation.y = 46.5 - questPresentation.height;
			}
			else
			{
				questPresentation.x = 26.95;
				questPresentation.y = 2.95;
			}
			
			display.addChild(questPresentation);
		}
		
		private function setUpQuestList():void
		{
			userQuestsRequirement = QuestInfo.matchQuestRequirement(questSet);
			userQuests = GlobalVarContainer.getUser().getQuestSets()[questSetIndex].quests;
			
			offsetIndex = questProgressDisplayArray.length - userQuests.length;
			
			var questRep;
			
			for (var i:int = 0; i<questProgressDisplayArray.length; ++i)
			{
				var index = i - (questProgressDisplayArray.length - userQuests.length);
				if (index < 0)
				{
					questProgressDisplayArray[i].visible = false;
				}
				else
				{					
					if (userQuestsRequirement[index][0] === QuestInfo.SERVE_RECIPE || userQuestsRequirement[index][0] === QuestInfo.SERVE_LVLCUISINE || userQuestsRequirement[index][0] === QuestInfo.COOK_DISH || userQuestsRequirement[index][0] === QuestInfo.COLLECT_INGRE)
					{
						if (userQuests[index].current_number < userQuestsRequirement[index][1][1])
						{
							questProgressDisplayArray[i].text = userQuests[index].current_number.toString() + "/" + userQuestsRequirement[index][1][1].toString();
						}
						else
						{
							questProgressDisplayArray[i].text = userQuestsRequirement[index][1][1].toString() + "/" + userQuestsRequirement[index][1][1].toString();
						}
						questRep = QuestInfo.matchIndividualQuestPresentation(userQuestsRequirement[index][0], userQuestsRequirement[index][1][0]);
						
						if (userQuestsRequirement[index][0] !=- QuestInfo.COLLECT_INGRE)
						{
							questRep.buttonMode = true;
							questRep.addEventListener(MouseEvent.CLICK, openMenu);
							questRep.dish = userQuestsRequirement[index][1][0];
						}
					}
					else if (userQuestsRequirement[index][0] === QuestInfo.CAPTURE_NINJA || userQuestsRequirement[index][0] === QuestInfo.SERVE_VIP || userQuestsRequirement[index][0] === QuestInfo.NUM_4INAROW || userQuestsRequirement[index][0] === QuestInfo.NUM_5INAROW 
						|| userQuestsRequirement[index][0] === QuestInfo.NUM_LINAROW || userQuestsRequirement[index][0] === QuestInfo.VISIT_FRIEND || userQuestsRequirement[index][0] === QuestInfo.CAPTUREFRIEND_NINJA || userQuestsRequirement[index][0] === QuestInfo.STEALMONEY_FRIEND)
					{
						if (userQuests[index].current_number < userQuestsRequirement[index][1][0])
						{
							questProgressDisplayArray[i].text = userQuests[index].current_number.toString() + "/" + userQuestsRequirement[index][1][0].toString();
						}
						else
						{
							questProgressDisplayArray[i].text = userQuestsRequirement[index][1][0].toString() + "/" + userQuestsRequirement[index][1][0].toString();
						}
						
						questRep = QuestInfo.matchIndividualQuestPresentation(userQuestsRequirement[index][0]);						
					}
					else if (userQuestsRequirement[index][0] === QuestInfo.BEAT_CHEF)
					{
						questProgressDisplayArray[i].text = "";
						questRep = QuestInfo.matchIndividualQuestPresentation(userQuestsRequirement[index][0], ChefInfo.matchChefFromRecipe(questSet));
						questRep.addEventListener(MouseEvent.CLICK, playBeatChef);
						questRep.addEventListener(MouseEvent.MOUSE_OVER, function(evt:Event){questRep.scaleX = questRep.scaleY = 1.1;});
						questRep.addEventListener(MouseEvent.MOUSE_OUT, function(evt:Event){questRep.scaleX = questRep.scaleY = 1;});
						questRep.buttonMode = true;
					}
					else if (userQuestsRequirement[index][0] === QuestInfo.GETHELP_FRIEND)
					{
						if (userQuests[index].current_number < userQuestsRequirement[index][1][0])
						{
							questProgressDisplayArray[i].text = userQuests[index].current_number.toString() + "/" + userQuestsRequirement[index][1][0].toString();
						}
						else
						{
							questProgressDisplayArray[i].text = userQuestsRequirement[index][1][0].toString() + "/" + userQuestsRequirement[index][1][0].toString();
						}
						
						questRep = QuestInfo.matchIndividualQuestPresentation(userQuestsRequirement[index][0], ingreArray[ingreIndex]);
						ingreIndex++;
						
						questRep.addEventListener(MouseEvent.CLICK, askFriendToHelp);
						questRep.buttonMode = true;
					}
					questRep.x = 180.25 + 105*i;
					questRep.y = 10.25;
					questRep.quest = userQuestsRequirement[index][0];
					questRep.index = index;
					if (userQuestsRequirement[index][0] != QuestInfo.BEAT_CHEF)
					{
						questRep.addEventListener(MouseEvent.MOUSE_OVER, showInfoBubble);
					}
					
					questRepArray.push(questRep);
					display.addChild(questRep);
					
					if (userQuests[index].status == 1)
					{
						questRep.alpha = 0.25;
						questRep.buttonMode = false;
						if (userQuestsRequirement[index][0] != QuestInfo.BEAT_CHEF)
						{
							questRep.removeEventListener(MouseEvent.MOUSE_OVER, showInfoBubble);
						}
						
						var questDoneSymbol = new QuestDone_Symbol();
						questDoneSymbol.x = questRep.x + 5;
						questDoneSymbol.y = questRep.y + 5;
						display.addChild(questDoneSymbol);
					}
					else
					{
						if (userQuestsRequirement[index][0] == QuestInfo.BEAT_CHEF)
						{
							beatMeBubble.x = questRep.x + questRep.width;
							beatMeBubble.y = questRep.y - 7;

							display.addChild(beatMeBubble);
						}
					}
				}				
			}
		}
		
		private function playBeatChef(evt:Event):void
		{
			//evt.currentTarget.removeEvent
			var index = evt.currentTarget.index;
			QuestShortcutPopUp(this.parent.parent.parent).myQuest = [null, [questSet, evt.currentTarget.index, false], userQuestsRequirement[index][2][0], userQuestsRequirement[index][2][1], userQuestsRequirement[index][2][2], userQuestsRequirement[index][2][3], userQuestsRequirement[index][2][4]];
			QuestShortcutPopUp(this.parent.parent.parent).gotoQuest();
		}
		
		private function openMenu(evt:MouseEvent):void
		{
			QuestShortcutPopUp(this.parent.parent.parent).openMenu(evt.currentTarget.dish);
		}

		private function askFriendToHelp(evt:Event):void
		{
			try {
				ExternalInterface.call('getHelp');
			}
			catch (errObject:Error){
				trace(errObject.message);
			}
		}
		
		private function showInfoBubble(evt:MouseEvent = null):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, showInfoBubble);
			
			switch(evt.currentTarget.quest)
			{
				case QuestInfo.SERVE_RECIPE:
				questInfoBubble.questDescription.text = "Serve this to customers";
				break;
				case QuestInfo.COOK_DISH:
				questInfoBubble.questDescription.text = "Cook this dish";
				break;
				case QuestInfo.COLLECT_INGRE:
				questInfoBubble.questDescription.text = "Cook this ingredient";
				break;
				case QuestInfo.CAPTURE_NINJA:
				questInfoBubble.questDescription.text = "Capture ninjas";
				break;
				case QuestInfo.SERVE_VIP:
				questInfoBubble.questDescription.text = "Serve VIPs";
				break;
				case QuestInfo.NUM_4INAROW:
				questInfoBubble.questDescription.text = "Capture 4-in-a-row";
				break;
				case QuestInfo.NUM_5INAROW:
				questInfoBubble.questDescription.text = "Capture 5-in-a-row";
				break;
				case QuestInfo.NUM_LINAROW:
				questInfoBubble.questDescription.text = "Capture L shaped";
				break;
				case QuestInfo.VISIT_FRIEND:
				questInfoBubble.questDescription.text = "Visit your friends";
				break;
				case QuestInfo.CAPTUREFRIEND_NINJA:
				questInfoBubble.questDescription.text = "Help friends capture Ninjas";
				break;
				case QuestInfo.STEALMONEY_FRIEND:
				questInfoBubble.questDescription.text = "Steal money from friend";
				break;
				case QuestInfo.GETHELP_FRIEND:
				questInfoBubble.questDescription.text = "Ask friends to help";
				break;
			}
			
			if (evt.currentTarget.quest != QuestInfo.BEAT_CHEF)
			{
				questInfoBubble.x = evt.currentTarget.x;
				questInfoBubble.y = evt.currentTarget.y - 40;
				
				display.addChild(questInfoBubble);
			}

			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, hideQuestInfo);
		}
		
		private function hideQuestInfo(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, hideQuestInfo);
			
			if (display.contains(questInfoBubble))
			{
				display.removeChild(questInfoBubble);
			}

			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, showInfoBubble);
		}
		
		public function updateProgress(index:int):void
		{
			if (userQuestsRequirement[index][0] === QuestInfo.SERVE_RECIPE || userQuestsRequirement[index][0] === QuestInfo.SERVE_LVLCUISINE || userQuestsRequirement[index][0] === QuestInfo.COOK_DISH || userQuestsRequirement[index][0] === QuestInfo.COLLECT_INGRE)
			{
				if (userQuests[index].current_number < userQuestsRequirement[index][1][1])
				{
					questProgressDisplayArray[offsetIndex + index].text = userQuests[index].current_number.toString() + "/" + userQuestsRequirement[index][1][1].toString();
				}
				else
				{
					questProgressDisplayArray[offsetIndex + index].text = userQuestsRequirement[index][1][1].toString() + "/" + userQuestsRequirement[index][1][1].toString();
					updateComplete(index);
				}
			}
			else if (userQuestsRequirement[index][0] === QuestInfo.CAPTURE_NINJA || userQuestsRequirement[index][0] === QuestInfo.SERVE_VIP || userQuestsRequirement[index][0] === QuestInfo.NUM_4INAROW || userQuestsRequirement[index][0] === QuestInfo.NUM_5INAROW || userQuestsRequirement[index][0] === QuestInfo.NUM_LINAROW)
			{
				if (userQuests[index].current_number < userQuestsRequirement[index][1][0])
				{
					questProgressDisplayArray[offsetIndex + index].text = userQuests[index].current_number.toString() + "/" + userQuestsRequirement[index][1][0].toString();
				}
				else
				{
					questProgressDisplayArray[offsetIndex + index].text = userQuestsRequirement[index][1][0].toString() + "/" + userQuestsRequirement[index][1][0].toString();
					updateComplete(index);
				}			
			}			
		}
		
		private function checkSpecialRecipe():Boolean
		{
			var specialRecipes = RecipeInfo.getSpecialRecipes();
			for (var i:int = 0; i<specialRecipes.length; ++i)
			{
				if (questSet == specialRecipes[i])
				{
					return true;
				}
			}
			return false;
		}
		
		public function updateComplete(index:int):void
		{
			questRepArray[index].alpha = 0.25;
			questRepArray[index].removeEventListener(MouseEvent.MOUSE_OVER, showInfoBubble);
			questRepArray[index].buttonMode = false;
			var questDoneSymbol = new QuestDone_Symbol();
			questDoneSymbol.x = questRepArray[index].x + 5;
			questDoneSymbol.y = questRepArray[index].y + 5;
			display.addChild(questDoneSymbol);
		}
		
		public function makeForShowOnly():void
		{
			questPresentation.visible = false;
			for (var i:int = 0; i<questRepArray.length; ++i)
			{
				if (questRepArray[i].quest == QuestInfo.BEAT_CHEF)
				{
					questRepArray[i].removeEventListener(MouseEvent.CLICK, playBeatChef);
				}
				else if (questRepArray[i].quest == QuestInfo.GETHELP_FRIEND)
				{
					questRepArray[i].removeEventListener(MouseEvent.CLICK, askFriendToHelp);
				}
			}
			display.gotoAndStop("info");
			
			if (beatMeBubble && display.contains(beatMeBubble))
			{
				display.removeChild(beatMeBubble);
			}
			
		}
	}
}