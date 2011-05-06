package chefhouse
{
	import flash.display.*;
	import flash.events.*
	import retrieveInfo.*;
	import bejeweled.*;
	import restaurant.*;
	import util.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class QuestShortcut extends Sprite
	{
		private var QuestType_Butt:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestType_Butt"));
		private var DoQuest_Butt:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("DoQuest_Butt"));
		private var Quests_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Quests_PopUp"));
		private var QuestSetInfo_Box:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestSetInfo_Box"));
		private var RewardInfo_Box:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("RewardInfo_Box"));
		private var QuestSet_Separator:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestSet_Separator"));
		private var GetMoreQuest_Butt:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("GetMoreQuest_Butt"));
		
		private var display;
		private var numQuest:int = 0;
		//private var dishQuest:int;
		private var questArray:Array = [];
		private var recipeArray:Array = [];
		private var recipeDisplay:MovieClip;
		private var questButtArray:Array = [];
		
		private var doQuestButt = new DoQuest_Butt();
		private var progressArray = new Array();
		private var currentRecipe:int;

		public var myQuest;
		public var checkBuy:Boolean = false;
		public var rewardInfo = new RewardInfo_Box();
		public var currentBox = -1;
		public var currentQuests;
		private var questSetArray:Array = [];
		
		private var questListContainer:Sprite = new Sprite();
		private var questBoxArray:Array = [];
		private var previousQuestBoxHeight:int = 0;
		
		private var totalNumQuestSets:int = 0;
		
		private var getMoreQuestButt;
		
		public function QuestShortcut()
		{
			currentRecipe = GlobalVarContainer.getUser().getCurrentRecipe();
			recipeArray = RecipeInfo.matchRecipeIngre(currentRecipe);
			recipeDisplay = RecipeInfo.matchRecipeDisplay(currentRecipe);

			display = new Quests_PopUp();

			this.addChild(display);
			putGetMoreQuests();

			setUpQuestList();

			display.closeButt.addEventListener(MouseEvent.CLICK, closeQuestShortcut, false, 0, true);
		}
		
		public function majorUpdate():void
		{
			for (var j = 0; j < totalNumQuestSets; ++j)
			{
				var length = questButtArray[0].length;
				for (var i = 0; i< length; ++i)
				{
					if (questBoxArray[0].contains(questButtArray[0][0]))
					{
						questBoxArray[0].removeChild(questButtArray[0][0]);
					}
					questButtArray[0].shift();
				}
				questListContainer.removeChild(questBoxArray[0]);
				questBoxArray.shift();
				questButtArray.shift();
			}
			
			questArray = [];
			previousQuestBoxHeight = 0;

			setUpQuestList();
		}
				
		private function closeQuestShortcut(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).closeQuestShortcut(null);
		}
				
		private function setUpQuestList():void
		{
			questSetArray = GlobalVarContainer.getUser().getQuestSets();
			totalNumQuestSets = questSetArray.length;
			questButtArray = new Array(questSetArray.length);
			
			questListContainer.x = display.questListMask.x;
			questListContainer.y = display.questListMask.y;
			questListContainer.mask = display.questListMask;
			
			display.addChild(questListContainer);
			
			if (questSetArray.length === 0)
			{
				getMoreQuestButt.visible = true;
			}
			else
			{
				getMoreQuestButt.visible = false;
				for (var i = 0; i<questSetArray.length; ++i)
				{
					questArray.push(QuestInfo.matchQuestRequirement(questSetArray[i].id));
					questButtArray[i] = [];
					progressArray[i] = [];
					setUpQuestSet(i);
					test(questSetArray[i].id, i);
				}
			}
			
			display.scrollDownButt.addEventListener(MouseEvent.MOUSE_DOWN, moveListUp);
			display.scrollUpButt.addEventListener(MouseEvent.MOUSE_DOWN, moveListDown);
		}
		
		private function test(questSet:int, index:int):void
		{
			var questSetDisplay = new QuestSetDisplay(questSet, index);
			questSetDisplay.x = 10;
			questSetDisplay.y = 40 + 60*index;
			questListContainer.addChild(questSetDisplay);
		}		
		
		private function putGetMoreQuests():void
		{
			getMoreQuestButt = new GetMoreQuest_Butt();
			getMoreQuestButt.scaleX = getMoreQuestButt.scaleY = 0.8;
			
			getMoreQuestButt.x = (this.width - getMoreQuestButt.width)/2;
			getMoreQuestButt.y = 140;
			
			getMoreQuestButt.addEventListener(MouseEvent.CLICK, showMap);
			this.addChild(getMoreQuestButt);
			
			getMoreQuestButt.visible = false;
		}
		
		private function showMap(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).openMap(null);
			RestaurantScene(this.parent).notRemoveOverlay = true;
			RestaurantScene(this.parent).closeQuestShortcut(null);
		}
		
		private function moveListUp(evt:MouseEvent):void
		{
			var newY;
			if (questListContainer.y > -(questListContainer.height + 60 - display.questListMask.height));
			{
				if (questListContainer.y - 150 > - (questListContainer.height + 60  - display.questListMask.height))
				{
					newY = questListContainer.y - 150;
				}
				else
				{
					newY = -(questListContainer.height + 60 - display.questListMask.height);
				}
				TweenMax.to(questListContainer, 0.3, {y:newY, ease:Circ.easeOut});
			}
		}
		
		private function moveListDown(evt:MouseEvent):void
		{
			var newY;
			if (questListContainer.y < display.questListMask.y)
			{
				if (questListContainer.y < display.questListMask.y - 150)
				{
					newY = questListContainer.y + 150;
				}
				else
				{
					newY = display.questListMask.y;
				}
				TweenMax.to(questListContainer, 0.3, {y:newY, ease:Circ.easeOut});
			}
		}
		
		private function setUpQuestSet(stt:int):void
		{
			numQuest = questSetArray[stt].quests.length;
			var questHeight = 200;
			addQuestsRepresentation(stt);
			for (var i = 0; i< numQuest; ++i)
			{
				var questButt = new QuestType_Butt();
				questButt.x = 96;
				questButt.y = 136.5 + i*(questButt.height - 5);
				questButt.group = stt;
				if (questSetArray[stt].quests[i].status == 1)
				{
					questButt.gotoAndStop("complete");
				}
				else
				{
					questButt.questText.text = QuestInfo.matchQuestInfo(questArray[stt][i][0], questArray[stt][i][1]);
					questButt.addEventListener(MouseEvent.MOUSE_OVER, showQuestInfo, false, 0, true);
				}
				
				questButtArray[stt].push(questButt);
				questBoxArray[stt].addChild(questButt);
			}
			
			previousQuestBoxHeight += questBoxArray[stt].height + 60;
			
			var questSetSeparator = new QuestSet_Separator();
			questSetSeparator.y = questBoxArray[stt].height + 30;
			questBoxArray[stt].addChild(questSetSeparator);			
		}
		
		private function addQuestsRepresentation(stt:int):void
		{
			var questBox = new QuestSetInfo_Box();
			questBox.group = stt;
			var rewardArray = QuestInfo.matchQuestReward(questSetArray[stt].id);
			questBox.questName.text = QuestInfo.matchQuestName(questSetArray[stt].id);
			questBox.questInfoText.text = QuestInfo.matchQuestSetInfo(questSetArray[stt].id);
			questBox.expGain.text = rewardArray[0];
			questBox.itemValue.amountMoney.text = rewardArray[1];
			
			var length = rewardArray[2].length;
			
			for (var i:int = 0; i<length; ++i)
			{
				var boomzDisplay = BoomzInfo.matchBoomzDisplay(rewardArray[2][i][0]);
				boomzDisplay.scaleX = boomzDisplay.scaleY = 0.5;
				boomzDisplay.x = 497;
				boomzDisplay.y = 60.75 + i* 30;
				questBox.addChild(boomzDisplay);
			}
			
			var questPresentation:MovieClip = QuestInfo.matchQuestPresentation(questSetArray[stt].id);
			questPresentation.scaleY = questPresentation.scaleX = 73.15/questPresentation.width;
			questPresentation.x = 3.75;
			questPresentation.y = 46 - questPresentation.height;
			
			questBox.addChild(questPresentation);
		
			questBox.x = 10;
			questBox.y = 10 + previousQuestBoxHeight;
			
			questBoxArray.push(questBox);
			questListContainer.addChild(questBox);
		}
		
		public function removeQuestInfo():void
		{
			for (var j:int = 0; j<questBoxArray.length; ++j)
			{
				var length = questButtArray[j].length;
			
				for (var i = 0; i<length; ++i)
				{
					questButtArray[j][i].y = 136.5 + i*(questButtArray[j][i].height - 5);
				}
			
				if (questBoxArray[j].contains(rewardInfo))
				{
					questBoxArray[j].removeChild(rewardInfo);
					if (questBoxArray[j].contains(doQuestButt))
					{
						questBoxArray[j].removeChild(doQuestButt);
					}
				}
			}
			currentBox = -1;
			checkBuy = false;
		}
		
		private function showQuestInfo(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, showQuestInfo);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, addOnOver);
			var group = evt.currentTarget.group;
			var index = questButtArray[group].indexOf(evt.currentTarget);
			var length = questButtArray[group].length;
			var rHeight = rewardInfo.height;
			
			for(var j = 0; j<questSetArray.length; ++j)
			{
				for (var i = 0; i<questButtArray[j].length; ++i)
				{
					questButtArray[j][i].y = 136.5 + i*(questButtArray[j][i].height - 5);
				}
			}
			
			if (currentBox !== index || !this.contains(rewardInfo))
			{
				for (i = index + 1; i<length; ++i)
				{
					questButtArray[group][i].y += rHeight;
				}
			
				rewardInfo.y = questButtArray[group][index].y + questButtArray[group][index].height;
				rewardInfo.x = questButtArray[group][index].x;
				
				if (questArray[group][index][0] === QuestInfo.SERVE_RECIPE || questArray[group][index][0] === QuestInfo.SERVE_LVLCUISINE || questArray[group][index][0] === QuestInfo.COOK_DISH || questArray[group][index][0] === QuestInfo.COLLECT_INGRE)
				{
					rewardInfo.questProgress.text = "Progress: " + questSetArray[group].quests[index].current_number.toString() + "/" + questArray[group][index][1][1].toString();
					progressArray[group][index] = GlobalVarContainer.getUser().getQuestSets()[group].quests[index].current_number;
				}
				else if (questArray[group][index][0] === QuestInfo.CAPTURE_NINJA || questArray[group][index][0] === QuestInfo.SERVE_VIP || questArray[group][index][0] === QuestInfo.NUM_4INAROW || questArray[group][index][0] === QuestInfo.NUM_5INAROW || questArray[group][index][0] === QuestInfo.NUM_LINAROW)
				{
					rewardInfo.questProgress.text = "Progress: " + questSetArray[group].quests[index].current_number.toString() + "/" + questArray[group][index][1][0].toString();
					progressArray[group][index] = GlobalVarContainer.getUser().getQuestSets()[group].quests[index].current_number;
				}
				else
				{
					rewardInfo.questProgress.text = "";
				}
				questBoxArray[group].addChild(rewardInfo);
				
				currentBox = index;
				
				if (questArray[group][index][0] === QuestInfo.BEAT_CHEF || questArray[group][index][0] === QuestInfo.CAPTURE_INGRE || questArray[group][index][0] === QuestInfo.PURCHASE || questArray[group][index][0] === QuestInfo.COOK_DISH)
				{
					addDoQuest(group, index, questArray[group][index][0]);
				}
				else
				{
					for (j = 0; j<questSetArray.length; ++j)
					{
						if (questBoxArray[j].contains(doQuestButt))
						{
							questBoxArray[j].removeChild(doQuestButt);
						}
					}
				}
			}
			else
			{
				if (questBoxArray[group].contains(rewardInfo))
				{
					questBoxArray[group].removeChild(rewardInfo);
					if (questBoxArray[group].contains(doQuestButt))
					{
						questBoxArray[group].removeChild(doQuestButt);
					}
				}
			}
		}
		
		private function addOnOver(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, addOnOver);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, showQuestInfo);
		}
		
		public function updateProgress(group:int, index:int)
		{
			if (this.contains(rewardInfo))
			{
				progressArray[group][index]++;
				rewardInfo.questProgress.text = "Progress: " + progressArray[group][index].toString() + "/" + questArray[group][index][1][1].toString();
			}
		}
		
		private function addDoQuest(group:int, i:int, quest:int):void
		{
			currentRecipe = GlobalVarContainer.getUser().getCurrentRecipe();
			
			switch(quest)
			{
				case QuestInfo.BEAT_CHEF:
				myQuest = [null, [currentRecipe, i], questArray[group][i][2][0], questArray[group][i][2][1], questArray[group][i][2][2], questArray[group][i][2][3], questArray[group][i][2][4]];
				checkBuy = false;
				break;
				case QuestInfo.CAPTURE_INGRE:
				myQuest = [null, [currentRecipe, i], questArray[group][i][2][0], questArray[group][i][2][1], questArray[group][i][2][2], questArray[group][i][2][3], questArray[group][i][2][4]];
				checkBuy = false;
				break;
				case QuestInfo.COOK_DISH:
				myQuest = [null, [[], [], 2, 12, 10], questArray[group][i][2][0], questArray[group][i][2][1], questArray[group][i][2][2], questArray[group][i][2][3], questArray[group][i][2][4]];
				checkBuy = false;
				break;
				case QuestInfo.PURCHASE:
				myQuest = [group, i, recipeArray[i], questArray[group][i][1][0]];
				checkBuy = true;
				break;
				
			}
			
			doQuestButt.y = rewardInfo.y + 11.35;
			doQuestButt.x = rewardInfo.x + 344.85;
			
			questBoxArray[group].addChild(doQuestButt);
			
			doQuestButt.addEventListener(MouseEvent.MOUSE_DOWN, gotoQuest, false, 0, true);
		}
		
		private function gotoQuest(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, gotoQuest);
			dispatchEvent(new Event("go quest"));
		}
	}
}