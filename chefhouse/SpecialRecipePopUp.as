package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	
	import util.*;
	import retrieveInfo.*;
	import restaurant.*;
	import user.*;
		
	public class SpecialRecipePopUp extends MovieClip
	{
		private var SpecialRecipe_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("SpecialRecipe_PopUp"));
		
		private var display;
		private var dishDisplay;
		private var recipe;
		private var questArray = [];
		private var userQuestArray = [];
		
		private var progressBars = [];
		private var userRecipes;
		
		private var theRestaurant;
		
		public function SpecialRecipePopUp(recipe:int, theRestaurant:RestaurantScene = null):void
		{
			this.recipe = recipe;
			this.theRestaurant = theRestaurant;
			
			display = new SpecialRecipe_PopUp();
			display.recipeName.text = RecipeInfo.matchRecipeName(recipe);
			display.okButt.buttonMode = true;
			display.getIngreButt.buttonMode = true;
			
			dishDisplay = RecipeInfo.matchRecipeDisplay(recipe);
			dishDisplay.scaleX = dishDisplay.scaleY = 173.05/dishDisplay.width;
			dishDisplay.x = 107.60;
			dishDisplay.y = 277.7 - dishDisplay.height;
			display.addChild(dishDisplay);
			
			display.okButt.addEventListener(MouseEvent.CLICK, closeSpecialDish);
			display.getIngreButt.addEventListener(MouseEvent.CLICK, closeSpecialDish);
			
			var userLevel = GlobalVarContainer.getUser().getLevel();
			if (userLevel < RecipeInfo.matchRecipeLevel(recipe))
			{
				
			}
			else
			{
				if (checkLearned())
				{
					showUserQuests();
				}
				else
				{
					if (!checkLearning())
					{
						trace("sendLearnQuest")
						var questManagement = new QuestManagement();
						questManagement.sendLearnQuest(recipe);
						questManagement.addEventListener("learnedQuest", showUserQuests);
					}
					else
					{
						showUserQuests();
					}
				}
			}
			
			display.recipeDescription.text = RecipeInfo.getSpecialRecipeDescription(recipe);
			
			this.addChild(display);
		}
		
		private function closeSpecialDish(evt:Event):void
		{
			theRestaurant.closeMapLightHouse();
		}
		
		private function showUserQuests(evt:Event = null):void
		{
			questArray = QuestInfo.matchQuestRequirement(recipe);
			setUpProgresses();
		}
		
		private function checkLearned():Boolean
		{
			userRecipes = GlobalVarContainer.getUser().getRecipes();
			for (var i:int = 0; i<userRecipes.length; ++i)
			{
				if (userRecipes[i].id == recipe)
				{
					return true;
				}
			}
			return false;
		}
		
		private function checkLearning():Boolean
		{
			var userLearning = GlobalVarContainer.getUser().getCurrentQuestsSetsID();
			for (var i:int = 0; i<userLearning.length; ++i)
			{
				if (userLearning[i] == recipe)
				{
					return true;
				}
			}
			return false;
		}
		
		private function setUpProgresses():void
		{
			var questSets = GlobalVarContainer.getUser().getQuestSets();
			var i:int;
			for (i = 0; i<questSets.length; ++i)
			{
				if (questSets[i].id == this.recipe)
				{
					this.userQuestArray = questSets[i].quests;
					break;
				}
			}
			
			for (i = 0; i<userQuestArray.length; ++i)
			{
				showQuestProgress(i);
			}
		}
		
		private function showQuestProgress(index:int):void
		{
			//trace(questArray[index][1]);
			var progressBar = new QuestProgressBar(questArray[index][0], userQuestArray[index].current_number, questArray[index][1][0], recipe);
			progressBar.x = 339;
			progressBar.y = 120 + 60*index;
			
			progressBars.push(progressBar);
			display.addChild(progressBar);
		}
	}
}