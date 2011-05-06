package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	
	import retrieveInfo.*;
	import util.*;
	import loader.*;
	
	public class RecipeDisplayInfo extends Sprite
	{
		public var display;
		public var recipeDisplay;
		public var currentIndex;
		
		private var RecipeInfoDisplay:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("RecipeInfoDisplay"));
		
		public var notEnough:Boolean = false;
		public var learned:Boolean = false;
		
		public function RecipeDisplayInfo(recipe:int):void
		{
			display = new RecipeInfoDisplay();
			
			recipeDisplay = RecipeInfo.matchRecipeDisplay(recipe);
			recipeDisplay.scaleX = 65/78;
			recipeDisplay.scaleY = 65/78;
			recipeDisplay.x = 27;
			recipeDisplay.y = 65 - recipeDisplay.height;
			display.addChild(recipeDisplay);
			
			display.recipeName.text = RecipeInfo.matchRecipeName(recipe);
			display.goldCost.text = RecipeInfo.matchRecipeRequirement(recipe)[0].toString();
			display.energyCost.text = RecipeInfo.matchRecipeRequirement(recipe)[1].toString();
			display.moneyGain.text = RecipeInfo.matchRecipeRequirement(recipe)[3].toString() + " per dish";
			
			this.addChild(display);
		}
	}
}