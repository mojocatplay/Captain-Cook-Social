package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	
	import retrieveInfo.*;
	import util.*;
	import loader.*;
	import user.*;
	import restaurant.RestaurantScene;
	
	public class ChefHouse extends Sprite
	{
		private var recipeArray = [];
		private var display;
		private var nameContainerArray = new Array();
		private var questDetailArray = new Array();
		private var recipeDisplay:MovieClip;
		
		private const recipeDisplayX = 300;
		private const recipeDisplayY = 25;
		private const recipeDisplayW = 140;
		private const recipeDisplayH = 110;
		
		public static const LATIN_CHEF:int = 3;
		public static const BRITISH_CHEF:int = 1;
		public static const AMERICAN_CHEF:int = 2;
		
		private var prevTarget = null;
		
		private var chef;
		private var currentIndex:int = -1;
		private var currentLearning:int = -1;
		private var learningIndex:int = -1;
		private var learnedIndexArray:Array = [];
		private var learnedRecipes:Array;
		private var chefDialog;
		
		private var LearnConfirm_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("LearnConfirm_PopUp"));
		private var UnLearnConfirm_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("UnLearnConfirm_PopUp"));
		private var MustUnlearn_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("MustUnlearn_PopUp"));
		private var Marciel_Dialog:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Marciel_Dialog"));
		private var Robinson_Dialog:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Robinson_Dialog"));
		private var Klaus_Dialog:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Klaus_Dialog"));
		private var RecipeNameContainer:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("RecipeNameContainer"));
		private var QuestDetail:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("QuestDetail"));
	
		private var learnPopUp = new LearnConfirm_PopUp();
		private var unlearnPopUp = new UnLearnConfirm_PopUp();
		private var mustUnlearnPopUp = new MustUnlearn_PopUp();
		
		private var thisHeight:int;
		private var thisWidth:int;
		
		private var numScroll = 0;
		private var currentScroll = 3;
		private var recipeListContainer:Sprite;
		
		private var userLevel;
		private var userQuestSets;
		private var chefQuestGained:int = 0;
		private var userQuestSetsDone;
				
		private var theRestaurant;
		
		public function ChefHouse(chef:int, theRestaurant:RestaurantScene = null)
		{
			userLevel = GlobalVarContainer.getUser().getLevel();
			userQuestSets = GlobalVarContainer.getUser().getQuestSets();
			userQuestSetsDone = GlobalVarContainer.getUser().getRecipes();
						
			this.chef = chef;
			this.theRestaurant = theRestaurant;
			
			if (false)
			//if (checkAvaiChefQuests())
			{
				var learningQuestSets = GlobalVarContainer.getUser().getCurrentQuestsSetsID();
				var isNewQuest = true;
				for (var i:int = 0; i<learningQuestSets.length; ++i)
				{
					if (chefQuestGained == learningQuestSets[i])
					{
						isNewQuest = false;
					}
				}

				if (isNewQuest)
				{
					display = new ChefQuestDialog(chef, chefQuestGained);	
					
					this.addChild(display);
					
					display.addEventListener("next", closeChefQuestDialog);
				}
				else
				{
					
				}
			}
			else
			{
				var ChefHouseMenu:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("ChefHouseMenu"));
				display = new ChefHouseMenu();
				thisHeight = display.height;
				thisWidth = display.width;
		  
				this.addChild(display);
			
				display.changeBackground(chef);
				var toDisplayed:Boolean = false;
				switch(chef)
				{
					case LATIN_CHEF:
					if (GlobalVarContainer.getUser().getChef1() === 0) {
						toDisplayed = true;
					}
					break;
					case BRITISH_CHEF:
					if (GlobalVarContainer.getUser().getChef2() === 0) {
						toDisplayed = true;
					}
					break;
					case AMERICAN_CHEF:
					if (GlobalVarContainer.getUser().getChef3() === 0) {
						toDisplayed = true;
					}
					break;
				}
				continueAddThings(null);
				
				recipeListContainer.scaleX = recipeListContainer.scaleY = 1.2;
			}
			
			addChefFace();
			display.returnMapButt.addEventListener(MouseEvent.CLICK, closeAndOpenMap);
			
		}
		
		private function addChefFace():void
		{
			var chefFace = ChefInfo.matchChefQuestFace(chef);
			chefFace.scaleX = chefFace.scaleY = 47/chefFace.width;
			chefFace.x = 16.10;
			chefFace.y = 14.5;
			display.addChild(chefFace);
		}
		
		private function closeChefQuestDialog(evt:Event):void
		{
			display.removeEventListener("next", closeChefQuestDialog);
			var questManagement = new QuestManagement();
			questManagement.sendLearnQuest(chefQuestGained);
			questManagement.addEventListener("learnedQuest", showUserQuests);
		}
		
		private function checkAvaiChefQuests():Boolean
		{
			var setsDone:Array = [];
			var i:int;
			var learningQuestSets = GlobalVarContainer.getUser().getCurrentQuestsSetsID();
			
			for (i = 0; i<learningQuestSets.length; ++i)
			{
				if (learningQuestSets[i] > 1000)
				{
					switch(chef)
					{
						case ChefInfo.CHEF_ROBIN:
						if (learningQuestSets[i] < 1100)
						{
							return false;
						}
						break;
						case ChefInfo.CHEF_KLAUS:
						if (learningQuestSets[i] < 1200 && learningQuestSets[i] > 1100)
						{
							return false;
						}
						break;
						case ChefInfo.CHEF_MARCIEL:
						if (learningQuestSets[i] < 1300 && learningQuestSets[i] > 1200)
						{
							return false;
						}
						break;
					}
				}
			}
			
			for (i = 0; i<userQuestSetsDone.length; ++i)
			{
				if (userQuestSetsDone[i].id > 1000)
				{
					switch(chef)
					{
						case ChefInfo.CHEF_ROBIN:
						if (userQuestSetsDone[i].id < 1100)
						{
							setsDone.push(userQuestSetsDone[i].id);
						}
						break;
						case ChefInfo.CHEF_KLAUS:
						if (userQuestSetsDone[i].id < 1200 && userQuestSetsDone[i].id > 1100)
						{
							setsDone.push(userQuestSetsDone[i].id);
						}
						break;
						case ChefInfo.CHEF_MARCIEL:
						if (userQuestSetsDone[i].id < 1300 && userQuestSetsDone[i].id > 1200)
						{
							setsDone.push(userQuestSetsDone[i].id);
						}
						break;
					}
				}
			}
			
			if (setsDone.length > 0)
			{
				setsDone.sort();
				var lastestQuest = setsDone[setsDone.length - 1];
				
				if (userLevel >= QuestInfo.matchChefQuestLevelRequirement(lastestQuest + 1))
				{
					//trace("Yes", lastestQuest+1);
					
					chefQuestGained = lastestQuest + 1;
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				switch(chef)
				{
					case ChefInfo.CHEF_ROBIN:
					if (userLevel >= QuestInfo.matchChefQuestLevelRequirement(1001))
					{
						chefQuestGained = 1001;
						return true;
					}
					break;
					case ChefInfo.CHEF_KLAUS:
					if (userLevel >= QuestInfo.matchChefQuestLevelRequirement(1101))
					{
						chefQuestGained = 1101;
						return true;
					}
					break;
					case ChefInfo.CHEF_MARCIEL:
					if (userLevel >= QuestInfo.matchChefQuestLevelRequirement(1201))
					{
						chefQuestGained = 1201;
						return true;
					}
					break;
				}
			}
			return false;
		}
		
		private function showUserQuests(evt:Event):void
		{
			closeAndOpenQuest();
		}
		
		private function continueAddThings(evt:Event):void
		{
			//display.grayBG.visible = true;
			
			switch(chef)
			{
				case LATIN_CHEF:
				GlobalVarContainer.getUser().setChef1(1);
				GlobalVarContainer.getUser().getChanges().chef1 = 1;
				break;
				case BRITISH_CHEF:
				GlobalVarContainer.getUser().setChef2(1);
				GlobalVarContainer.getUser().getChanges().chef2 = 1;
				break;
				case AMERICAN_CHEF:
				GlobalVarContainer.getUser().setChef3(1);
				GlobalVarContainer.getUser().getChanges().chef3 = 1;
				break;
			}
			if (chefDialog)
			{
				chefDialog.removeEventListener("finishDialog", continueAddThings);
				display.removeChild(chefDialog);
			}

			recipeArray = ChefInfo.matchChefRecipe(chef);
			
			checkLearned();
			checkLearning();
			
			setUpRecipeList();
			
			display.scrollUpButt.addEventListener(MouseEvent.CLICK, scrollListUp, false, 0, true);
			display.scrollDownButt.addEventListener(MouseEvent.CLICK, scrollListDown, false, 0, true);
		}
		
		private function scrollListUp(evt:MouseEvent):void
		{
			if (currentScroll > 3)
			{
				recipeListContainer.y += 140.4;
				currentScroll--;
			}
		}
		
		private function scrollListDown(evt:MouseEvent):void
		{
			if (currentScroll<numScroll)
			{
				recipeListContainer.y -= 140.4;
				currentScroll++;
			}
		}
		
		private function setUpRecipeList():void
		{
			var length = recipeArray.length;
			recipeListContainer = new Sprite();
			var j = 0;
			recipeListContainer.x = 0;
			recipeListContainer.y = 63.95;
			recipeListContainer.mask = display.recipeListMask;
			display.addChild(recipeListContainer);
			
			for (var i = 0; i<length; ++i)
			{
				nameContainerArray[i] = new RecipeDisplayInfo(recipeArray[i]);
				nameContainerArray[i].currentIndex = i;
				
				nameContainerArray[i].learned = false;
				if (learnedIndexArray.length > 0)
				{
					if (i === learnedIndexArray[j] && j<learnedIndexArray.length)
					{
						nameContainerArray[learnedIndexArray[j]].learned = true;
						j++;
					}
				}
				
				if (checkLevelRequirement(recipeArray[i]))
				{
					nameContainerArray[i].display.recipeName.text = RecipeInfo.matchRecipeName(recipeArray[i]);
					nameContainerArray[i].notEnough = false;
				}
				else
				{
					nameContainerArray[i].display.recipeName.text = "Unlock at level " + RecipeInfo.matchRecipeRequirement(recipeArray[i])[4];
					nameContainerArray[i].notEnough = true;
				}
				nameContainerArray[i].x = 18.55;
				nameContainerArray[i].y = 3 + 117*i;
								
				recipeListContainer.addChild(nameContainerArray[i]);
				addLearnButtEvents(i);
			}
			
			numScroll = length;			
		}
		
		private function checkLearned():void
		{
			learnedRecipes = GlobalVarContainer.getUser().getRecipes();
			var length = learnedRecipes.length;
			var recipeArrayLength = recipeArray.length;
			
			
			for (var i:int = 0; i<length; ++i)
			{
				for (var j:int = 0; j<recipeArrayLength; ++j)
				{					
					if (learnedRecipes[i].id == recipeArray[j])
					{
						learnedIndexArray.push(j);
					}
				}
			}
			
			learnedIndexArray.sort();
		}
		
		private function checkLearning():void
		{
			currentLearning = GlobalVarContainer.getUser().getCurrentRecipe();
			for (var i = 0; i<recipeArray.length; ++i)
			{
				if (currentLearning == recipeArray[i])
				{
					learningIndex = i;
				}
			}
		}
		
		private function unlearnRecipe(evt:MouseEvent):void
		{
			currentIndex = RecipeDisplayInfo(evt.currentTarget.parent.parent).currentIndex;
			
			var recipe = RecipeInfo.matchRecipeDisplay(recipeArray[currentIndex]);
			recipe.scaleX = 1.2;
			recipe.scaleY = 1.2;
			recipe.x = (unlearnPopUp.width - recipe.width)/2;
			recipe.y = 80 - recipe.height;
			unlearnPopUp.addChild(recipe);
						
			RestaurantScene(this.parent).putPopUpWithOverlay(unlearnPopUp);
			
			unlearnPopUp.yesButt.addEventListener(MouseEvent.CLICK, sendUnlearnRecipe, false, 0, true);
			unlearnPopUp.noButt.addEventListener(MouseEvent.CLICK, goBack, false, 0, true);
		}

		private function learnRecipe(evt:MouseEvent):void
		{
			var recipe;
			currentIndex = RecipeDisplayInfo(evt.currentTarget.parent.parent).currentIndex;
			if (GlobalVarContainer.getUser().getCurrentRecipe() > 0)
			{
				recipe = RecipeInfo.matchRecipeDisplay(GlobalVarContainer.getUser().getCurrentRecipe());
				recipe.x = 266.5;
				recipe.y = 77 - recipe.height;
				
				mustUnlearnPopUp.addChild(recipe);
				mustUnlearnPopUp.okButt.addEventListener(MouseEvent.CLICK, removeMustUnlearn, false, 0, true);
				RestaurantScene(this.parent).putPopUpWithOverlay(mustUnlearnPopUp);
			}
			else
			{
/*				recipe = RecipeInfo.matchRecipeDisplay(recipeArray[currentIndex]);
				recipe.scaleX = 1.2;
				recipe.scaleY = 1.2;
				recipe.x = (learnPopUp.width - recipe.width)/2;
				recipe.y = 74 - recipe.height;
				learnPopUp.addChild(recipe);*/
						
				//RestaurantScene(this.parent).putPopUpWithOverlay(learnPopUp);
				updateLearnRecipe();
				sendLearnRecipe();
				RestaurantScene(this.parent).putNewQuestPopUp(recipeArray[currentIndex]);
			
/*				learnPopUp.yesButt.addEventListener(MouseEvent.CLICK, sendLearnRecipe, false, 0, true);
				learnPopUp.noButt.addEventListener(MouseEvent.CLICK, goBack, false, 0, true);*/
			}
		}
		
		private function removeMustUnlearn(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, removeMustUnlearn);
			RestaurantScene(this.parent).removePopUpAndMoveOverlay(mustUnlearnPopUp);
		}
		
		private function goBack(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, goBack);
			RestaurantScene(this.parent).removePopUpAndMoveOverlay(evt.currentTarget.parent as MovieClip);
		}
		
		private function sendLearnRecipe(evt:MouseEvent = null, id = -1):void
		{
			if (evt)
			{
				evt.currentTarget.removeEventListener(MouseEvent.CLICK, sendLearnRecipe);
			}
			
			var params = [recipeArray[currentIndex]];
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'learnRecipe';
			var onResult:Function = learnRecipeSuccess;
			var onFault:Function = learnRecipeFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault, params);
		}
		
		private function sendUnlearnRecipe(evt:MouseEvent):void
		{
			trace("recipe", recipeArray[currentIndex]);
			var params = [recipeArray[currentIndex]];
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'unlearnRecipe';
			var onResult:Function = unlearnRecipeSuccess;
			var onFault:Function = unlearnRecipeFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault, params);
		}
		
		private function unlearnRecipeSuccess(object:*)
		{
			GlobalVarContainer.getUser().setCurrentRecipe(-1);
			
			for (var i:int = 0; i<userQuestSets.length; ++i)
			{
				if (userQuestSets[i].id < 1000)
				{
					userQuestSets.splice(i, 1);
				}
			}
			
			RestaurantScene(this.parent).removePopUpAndMoveOverlay(unlearnPopUp);
			RestaurantScene(this.parent).updateQuestPopUp();
			RestaurantScene(this.parent).updateUserQuestsInfo();
			updateChefHouse(false, currentIndex);
		}
		
		private function unlearnRecipeFail()
		{
			trace("unlearnRecipeFail");
		}
		
		private function learnRecipeSuccess(object:*) {
			//updateLearnRecipe();
			
			//event dispatch & save to user
/*			RestaurantScene(this.parent).removePopUpAndMoveOverlay(learnPopUp);
			RestaurantScene(this.parent).updateQuestPopUp();
			RestaurantScene(this.parent).updateUserQuestsInfo();*/
			updateChefHouse(true, currentIndex);
			
			closeAll();
		}
		
		private function updateLearnRecipe(){
			GlobalVarContainer.getUser().setCurrentRecipe(recipeArray[currentIndex]);
			
			var questArray:Array = QuestInfo.matchQuestRequirement(recipeArray[currentIndex]);
			var type:int;
			var questsArray:Array = [];
			var questSet:Object;
			
			for (var i:int = 0; i< questArray.length; ++i)
			{
				if (questArray[i][0] === QuestInfo.SERVE_RECIPE)
				{
					type = 2;
				}
				else {
					type = 1;
				}
				var quest = {
					recipe_id: recipeArray[currentIndex],
					sequence: i + 1,
					status: 0,
					current_number: 0,
					type: type
				};
				questsArray.push(quest);
			}
			
			questSet = {
				id: recipeArray[currentIndex],
				firstVisit: 0,
				quests:questsArray
			}
			
			userQuestSets.push(questSet);
		}
		
		private function updateChefHouse(learn:Boolean, index:int):void
		{
			if (learn)
			{
				nameContainerArray[index].display.learnButt.gotoAndStop("unlearn");
				nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, learnRecipe);
				nameContainerArray[index].display.learnButt.addEventListener(MouseEvent.CLICK, unlearnRecipe, false, 0, true);
			
				learningIndex = currentIndex;
			}
			else
			{
				nameContainerArray[index].display.learnButt.gotoAndStop("learn");
				nameContainerArray[index].display.learnButt.addEventListener(MouseEvent.CLICK, learnRecipe, false, 0, true);
				nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, unlearnRecipe);

				learningIndex = -1;
			}
		}
		
		private function learnRecipeFail(object:*) {
			//learnRecipe
		}
		
		private function checkLevelRequirement(dish:int):Boolean
		{
			if (LevelInfo.matchLevelFromExp(GlobalVarContainer.getUser().getExp()) < RecipeInfo.matchRecipeRequirement(dish)[4])
			{
				return false;
			}
			return true;
		}
		
		private function changeNameContainerNotEnough(index:int):void
		{
			if(nameContainerArray[index].notEnough)
			{
				recipeDisplay.filters = [GlobalVarContainer.greyscale];
				clearAndRemoveDetails();
				display.recipeInfoDisplay.learnButt.gotoAndStop("hidden");
			}
		}
		
		private function addLearnButtEvents(index:int):void
		{
			if (!nameContainerArray[index].notEnough)
			{
				if (!nameContainerArray[index].learned)
				{
					if(index != learningIndex)
					{					
						nameContainerArray[index].display.learnButt.gotoAndStop("learn")
						nameContainerArray[index].display.learnButt.addEventListener(MouseEvent.CLICK, learnRecipe, false, 0, true);
						nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, unlearnRecipe);
						nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, prepareRecipe);
					}
					else
					{
						nameContainerArray[index].display.learnButt.gotoAndStop("unlearn")
						nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, learnRecipe);
						nameContainerArray[index].display.learnButt.addEventListener(MouseEvent.CLICK, unlearnRecipe, false, 0, true);
						nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, prepareRecipe);
					}
				}
				else
				{
					nameContainerArray[index].display.learnButt.gotoAndStop("serve")
					nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, learnRecipe);
					nameContainerArray[index].display.learnButt.removeEventListener(MouseEvent.CLICK, unlearnRecipe);
					nameContainerArray[index].display.learnButt.addEventListener(MouseEvent.CLICK, prepareRecipe);
				}
			}
			else
			{
				nameContainerArray[index].display.learnButt.gotoAndStop("hidden");
				nameContainerArray[index].display.gotoAndStop(2);
				nameContainerArray[index].recipeDisplay.filters = [GlobalVarContainer.greyscale];
			}
		}
		
		private function prepareRecipe(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).openMenu(evt);
			closeAll(evt);
		}
		
		private function putIngreInPlace(array:Array, quest:Array, learned:Boolean = false):void
		{
			if (array !== null)
			{
				var length = array.length;
				
				clearAndRemoveDetails();
								
				for (var i = 0; i<length; ++i)
				{
					questDetailArray.push(new QuestDetail());
					questDetailArray[i].changeDetailImage(IngredientInfo.matchIngreDisplay(array[i]));
					if (learned)
					{
						questDetailArray[i].updateComplete();
					}
					else
					{
						if(recipeArray[currentIndex] == currentLearning && GlobalVarContainer.getUser().getQuests()[i].status == 1)
						{
							questDetailArray[i].updateComplete();
						}
						else
						{
							questDetailArray[i].changeDetailText(QuestInfo.matchQuestInfo(quest[i][0], quest[i][1]));
						}
					}
					questDetailArray[i].x = 320;
					questDetailArray[i].y = 200 + 30*i;
					
					this.addChild(questDetailArray[i]);
				}
			}
		}
		
		private function clearAndRemoveDetails():void
		{
			var length = questDetailArray.length;
			for (var i = 0; i < length; ++i)
			{
				this.removeChild(questDetailArray[0]);
				questDetailArray.shift();
			}
		}
		
		private function putInfoInPlace(array:Array):void
		{
			if (array !== null)
			{
				display.recipeInfoDisplay.visible = true;
				if (nameContainerArray[currentIndex].notEnough)
				{
					display.recipeInfoDisplay.learnButt.gotoAndStop("hidden");
				}
				else if (nameContainerArray[currentIndex].learned)
				{
					display.recipeInfoDisplay.learnButt.gotoAndStop("serve");
				}
				else
				{
					if (currentIndex !== learningIndex)
					{
						display.recipeInfoDisplay.learnButt.gotoAndStop("learn");
					}
					else
					{
						display.recipeInfoDisplay.learnButt.gotoAndStop("unlearn");
					}
				}
				display.recipeInfoDisplay.goldCost.text = array[0].toString();
				display.recipeInfoDisplay.energyCost.text = array[1].toString();
				display.recipeInfoDisplay.expGain.text = array[2].toString();
				display.recipeInfoDisplay.moneyGain.text = array[3].toString();
			}
		}
		
		private function putDisplayAtPlace(mc:MovieClip):void
		{
			mc.y = (recipeDisplayH - 10 - mc.height) + recipeDisplayY;
			mc.x = (recipeDisplayW - mc.width)/2 + recipeDisplayX;
		}
		
		private function closeAll(evt:MouseEvent = null):void
		{
			this.visible = false;
			this.dispatchEvent(new Event("closeAll"));
		}
		
		private function closeAndOpenQuest():void
		{
			this.visible = false;
			this.dispatchEvent(new Event("closeAndOpenQuest"));
		}
		
		private function closeAndOpenMap(evt:Event):void
		{
			this.visible = false;
			//RestaurantScene(this.parent).putMap();
			this.dispatchEvent(new Event("closed"));
		}
				
		override public function get height():Number
		{
			return thisHeight;
		}
		
		public function hideReturnMapButt():void
		{
			display.returnMapButt.visible = false;
		}
		
		override public function get width():Number
		{
			return thisWidth;
		}
	}
}