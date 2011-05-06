package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import retrieveInfo.*;
	import restaurant.*;
	
	public class MenuPreparePopUp extends MovieClip
	{
		private var MenuPrepare_PopUp:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("MenuPrepare_PopUp"));
		
		private var display;
		
		public var dish;
		
		private var dishDisplay;
		
		public function MenuPreparePopUp(dish:int):void
		{
			this.dish = dish;
			
			display = new MenuPrepare_PopUp();
			
			setUpDetails();
			display.cookItButt.addEventListener(MouseEvent.CLICK, function(evt:Event){dispatchEvent(new Event("startCookNow")); evt.currentTarget.removeEventListener(MouseEvent.CLICK, arguments.callee);}, false, 0, true);
			display.backButt.addEventListener(MouseEvent.CLICK, closeThis, false, 0, true);
			
			this.addChild(display);
		}
		
		private function setUpDetails():void
		{
			display.recipeName.text = RecipeInfo.matchRecipeName(dish);
			
			dishDisplay = RecipeInfo.matchRecipeDisplay(dish);
			dishDisplay.scaleX = dishDisplay.scaleY = 169.25/dishDisplay.width;
			dishDisplay.x = 192.65;
			dishDisplay.y = 193 - dishDisplay.height;
			
			display.addChild(dishDisplay);
			
			putIngreInPlace(RecipeInfo.matchRecipeIngre(dish));
			
			display.moneyCost.text = RecipeInfo.matchRecipeRequirement(dish)[0].toString();
			display.energyCost.text = RecipeInfo.matchRecipeRequirement(dish)[1].toString();
			
			display.expPayout.text = RecipeInfo.matchRecipeRequirement(dish)[2].toString();
			display.moneyPayout.text = int(RecipeInfo.matchRecipeRequirement(dish)[3]).toString();
		}
		
		private function putIngreInPlace(array:Array)
		{
			var length = array.length;
			var i:int;
			var desiredLength = length * 35;
			display.recipeListBG.width = desiredLength;
			
			for (i = 0; i<length; ++i)
			{
				var ingre = IngredientInfo.matchIngreDisplay(array[i]);
				ingre.scaleX = 0.65;
				ingre.scaleY = 0.65;
				
				ingre.x = display.recipeListBG.x - display.recipeListBG.width/2 + 5 +  30*i;
				ingre.y = display.recipeListBG.y - display.recipeListBG.height/2;
				
				//ingreListDisplay.push(ingre);
				display.addChild(ingre);
			}
		}
		
		private function closeThis(evt:Event):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, closeThis);
			this.dispatchEvent(new Event("closeThis"));
		}
	}
}