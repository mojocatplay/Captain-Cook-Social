package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	
	import retrieveInfo.*;
	import util.*;
	import loader.*;

	public class RecipePossessInfo extends Sprite
	{
		private var RecipePossessInfoDisplay:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("RecipePossessInfoDisplay"));
		private var IngredientsInfo_Bubble:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("IngredientsInfo_Bubble"));
		
		private var display;
		private var recipeDisplay;
		
		public var isServing:Boolean = false;
		public var dish:int = 0;
		
		private var ingresBubble = new IngredientsInfo_Bubble();
		
		private var recipe;
		
		public function RecipePossessInfo(recipe:int):void
		{
			display = new RecipePossessInfoDisplay();
			
			this.dish = recipe;
			
			recipeDisplay = RecipeInfo.matchRecipeDisplay(recipe);
			recipeDisplay.scaleY = recipeDisplay.scaleX = 76.55/recipeDisplay.width;
			recipeDisplay.x = 35.8;
			recipeDisplay.y = 79.7 - recipeDisplay.height;
			
			display.addChild(recipeDisplay);
			
			display.recipeName.text = RecipeInfo.matchRecipeName(recipe);
			
			display.moneyEarn.text = int(RecipeInfo.matchRecipeRequirement(recipe)[3]).toString();
			
			//setUpIngresBubble();
			
			hideSelect();
			this.addChild(display);
		}
		
		private function setUpIngresBubble():void
		{
			var ingres = RecipeInfo.matchRecipeIngre(dish);
			
			switch(ingres.length)
			{
				case 3:
				ingresBubble.gotoAndStop("3Ingres");
				break;
				case 4:
				ingresBubble.gotoAndStop("4Ingres");
				break;
				case 5:
				ingresBubble.gotoAndStop("5Ingres");
				break;
				case 6:
				ingresBubble.gotoAndStop("6Ingres");
				break;
			}
			
			var startX = -ingresBubble.width/2 + 7;
			
			for (var i:int = 0; i<ingres.length; ++i)
			{
				var ingreDisplay = IngredientInfo.matchIngreDisplay(ingres[i]);
				ingreDisplay.scaleX = ingreDisplay.scaleY = 28/ingreDisplay.width;
				ingreDisplay.x = startX + i*30;
				ingreDisplay.y = 15;
				ingresBubble.addChild(ingreDisplay);
			}
			
			ingresBubble.y = display.height;
			ingresBubble.x = display.width/2;
			
			this.addChild(ingresBubble);
			
			ingresBubble.visible = false;
		}
		
		public function hideServingInfo():void
		{
			display.gotoAndStop(1);
			//display.numAvail.text = "";
		}
		
		public function showServingInfo(numAvail:int):void
		{
			display.gotoAndStop(2);
			display.numAvail.text = numAvail.toString();
		}
		
		public function hideSelect():void
		{
			//display.selectSquare.visible = false;
			//display.background.gotoAndStop(1);
		}
		
		public function showSelect():void
		{
			//display.selectSquare.visible = true;
			//display.background.gotoAndStop(2);
		}
		
		private function showIngres(evt:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, showIngres);
			ingresBubble.visible = true;
			this.addEventListener(MouseEvent.MOUSE_OUT, hideIngres);
		}
		
		private function hideIngres(evt:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OUT, hideIngres);
			ingresBubble.visible = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, showIngres);
		}
		
		public function updateDishQuantity(quantity:int):void
		{
			if(quantity > 0)
			{
				showServingInfo(quantity);
			}
			else
			{
				hideServingInfo();
			}
		}
	}
}