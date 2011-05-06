package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	import com.greensock.*;
	
	import retrieveInfo.*;
	import util.*;
	import loader.*;
	import restaurant.RestaurantScene;
	
	public class RestaurantMenuNew extends MovieClip
	{
		private var RestaurantMenuNew_PopUp:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("RestaurantMenuNew_PopUp"));
		private var RecipePossessInfoDisplay:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("RecipePossessInfoDisplay"));
		private var BoomzBlank:Class = Class(index.cookingAsset.loaderInfo.applicationDomain.getDefinition("BoomzBlank"));
		private var BoomzChosenSquare:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("BoomzChosenSquare"));
		private var ChosenBoomzContainer:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("ChosenBoomzContainer"));
		private var BoomzQuantitySymbol:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("BoomzQuantitySymbol"));
		private var RestaurantMenuMask:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("RestaurantMenuMask"));
		private var IngredientsInfo_Bubble:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("IngredientsInfo_Bubble"));
		
		private var display;
		private var recipeDisplay;
		private var menuDisplay = new Sprite();
		private var recipeListContainer = new Sprite();
		private var boomzListContainer = new Sprite();
		private var recipes:Array = [];
		private var recipesInfoDisplayArray:Array = [];
		private var tmpDishArray:Array = [];
		private var tmpQuantityArray:Array = [];
		private var boomzSlotDisplayArray:Array = [];
		private var boomzDisplayArray = [];
		private var boomzContainerArray = [];
		
		private var thisHeight:int;
		private var thisWidth:int;
		
		private var prevSelect = null;
		private var ingreListDisplay = [];
		
		private var totalServing = 0;
		private const numBoomzSelect = 3;
		
		private var boomzChosenSquare;
		private var boomzSelectSquare;
		private var currentBoomzSlot:int;
		
		public var boomzListChosen:Array = [0, 0, 0];
		public var boomzChosenQuantity:Array = [0, 0, 0];
		public var recipeChosen:int;
		
		private const numMenuDisplayRow:int = 2;
		private var numMenuMaxRow:int;
		private var currentRow:int = 2;
		
		private var currentHalf = 1;
		private var forcedUser = false;
		private var getNewRecipeButt = null;
		
		private var ingresBubble;
		
		
		public function RestaurantMenuNew():void
		{
			display = new RestaurantMenuNew_PopUp();
			thisHeight = display.menuBackground.height;
			thisWidth = display.menuBackground.width;
			
			minorUpdate();
			//setUpFirstPartMenu();
			//setUpSecondPartMenu();
						
			display.closeButt.addEventListener(MouseEvent.CLICK, closeThis, false, 0, true);
			this.addChild(display);
		}
		
		private function forceUserUseBoomz():void
		{
			var numBoomz = boomzContainerArray.length;
			if (numBoomz > 3)
			{
				numBoomz = 3;
			}
			for (var i:int = 0; i<numBoomz; ++i)
			{
				boomzContainerArray[i].selected = true;
				boomzContainerArray[i].alpha = 0.2;
				//transferData(i);
			}
			
			forcedUser = true;
		}
		
		private function setUpRecipeList():void
		{
			var userRecipes = GlobalVarContainer.getUser().getRecipes();
			var length = userRecipes.length;
			
/*			var maskblah = new RestaurantMenuMask();
			maskblah.x = 18;
			maskblah.y = 63.5;*/
			
			
			for (var i:int = 0; i<length; ++i)
			{
				if (userRecipes[i].id < 1000)
				{
					recipes.push(userRecipes[i]);
				}
			}
			
			length = recipes.length;
			
			numMenuMaxRow = Math.ceil((length+1)/4);
			
			recipeListContainer.x = display.maskblah.x;
			recipeListContainer.y = display.maskblah.y;
			
			for (i = 0; i<length; ++i)
			{
				tmpDishArray.push(recipes[i].id);
				tmpQuantityArray.push(recipes[i].quantity);
				totalServing += recipes[i].quantity;
			}
			
			for (i = 0; i<=length; ++i)
			{
				var recipeInfoDisplay;
				if (i === length)
				{
					var GetNewRecipe_Butt:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("GetNewRecipe_Butt"));
					recipeInfoDisplay = new GetNewRecipe_Butt();
					getNewRecipeButt = recipeInfoDisplay;
				}
				else
				{
					recipeInfoDisplay = new RecipePossessInfo(tmpDishArray[i]);
					recipeInfoDisplay.dish = tmpDishArray[i];
				}
				recipeInfoDisplay.x = 165*(i%4);
				recipeInfoDisplay.y = 0 + 145*int(i/4);
				
				if (i<length)
				{
					if (tmpQuantityArray[i] > 0)
					{
						recipeInfoDisplay.showServingInfo(tmpQuantityArray[i]);
					}
				
					recipeInfoDisplay.addEventListener(MouseEvent.CLICK, showDetails, false, 0, true);
					recipeInfoDisplay.addEventListener(MouseEvent.MOUSE_OVER, showIngres, false, 0, true);
					
				
					recipesInfoDisplayArray.push(recipeInfoDisplay);
				}
				else
				{
					recipeInfoDisplay.addEventListener(MouseEvent.CLICK, showMap, false, 0, true);
				}
				
				recipeInfoDisplay.buttonMode = true;
				recipeListContainer.addChild(recipeInfoDisplay);
			}
			
			//recipeChosen = recipes[0].id;
			
			//display.menuContents.totalServingText.text = "Total serving: " + totalServing.toString();
			
			display.scrollUpButt.addEventListener(MouseEvent.CLICK, scrollListUp);
			display.scrollDownButt.addEventListener(MouseEvent.CLICK, scrollListDown);
			
			recipeListContainer.mask = display.maskblah;
						
			display.addChild(recipeListContainer);
						
		}
		
		private function setUpIngresBubble(recipePossessInfo:RecipePossessInfo):void
		{
			var ingres = RecipeInfo.matchRecipeIngre(recipePossessInfo.dish);
			
			ingresBubble = new IngredientsInfo_Bubble();
			
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
			var startY = recipePossessInfo.y;
			
			for (var i:int = 0; i<ingres.length; ++i)
			{
				var ingreDisplay = IngredientInfo.matchIngreDisplay(ingres[i]);
				ingreDisplay.scaleX = ingreDisplay.scaleY = 28/ingreDisplay.width;
				ingreDisplay.x = startX + i*28;
				ingreDisplay.y = 15;
				ingresBubble.addChild(ingreDisplay);
			}
			
			ingresBubble.y = recipePossessInfo.height + recipePossessInfo.y + recipeListContainer.y;
			ingresBubble.x = recipePossessInfo.width/2 + recipePossessInfo.x + recipeListContainer.x;
			
			this.addChild(ingresBubble);
			
			ingresBubble.visible = false;
		}
		
		private function showIngres(evt:Event):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, showIngres);
			setUpIngresBubble(evt.currentTarget as RecipePossessInfo);
			ingresBubble.visible = true;
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, hideIngres);
		}
		
		private function hideIngres(evt:Event):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, hideIngres);
			this.removeChild(ingresBubble);
			ingresBubble.visible = false;
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, showIngres);
		}
		
		private function showDetails(evt:Event):void
		{
			dispatchEvent(new Event("showDetails"));
			RestaurantScene(this.parent).showMenuPrepare(evt.currentTarget.dish);
			closeThis(null);
		}
		
		public function hideGetNewRecipe():void
		{
			getNewRecipeButt.visible = false;
		}
		
		private function showMap(evt:MouseEvent):void
		{
			//evt.currentTarget.removeEventListener(MouseEvent.CLICK, showMap);
			RestaurantScene(this.parent).openMap(null);
			RestaurantScene(this.parent).notRemoveOverlay = true;
			closeThis(null);
		}
		
		private function minorUpdate():void
		{
			var length = recipesInfoDisplayArray.length;
			for (var i:int = 0; i<length; ++i)
			{
				recipeListContainer.removeChild(recipesInfoDisplayArray[0]);
				recipesInfoDisplayArray.shift();
			}
			
			if (getNewRecipeButt && recipeListContainer.contains(getNewRecipeButt))
			{
				recipeListContainer.removeChild(getNewRecipeButt);
			}
			
			tmpDishArray = [];
			recipesInfoDisplayArray = [];
			tmpQuantityArray = [];
			recipes = [];
			totalServing = 0;
			currentRow = 2;
			
			setUpRecipeList();
		}
		
		public function majorUpdate():void
		{
			var length = recipesInfoDisplayArray.length;
			for (var i:int = 0; i<length; ++i)
			{
				recipesInfoDisplayArray[0].removeEventListener(MouseEvent.CLICK, showDetails);
				recipeListContainer.removeChild(recipesInfoDisplayArray[0]);
				recipesInfoDisplayArray.shift();
			}
			
			if (getNewRecipeButt && recipeListContainer.contains(getNewRecipeButt))
			{
				recipeListContainer.removeChild(getNewRecipeButt);
			}			
			
			tmpDishArray = [];
			recipesInfoDisplayArray = [];
			tmpQuantityArray = [];
			recipes = [];
			totalServing = 0;
			currentRow = 2;
			
			setUpRecipeList();
			
			var boomzSelected = getBoomzSelected();
			
			//resetBoomzListContainer();
			//setUpBoomzListContainer();
			
			for (var i:int = 0; i<boomzSelected.length; ++i)
			{
				boomzContainerArray[boomzSelected[i]].alpha = 0.2;
				boomzContainerArray[boomzSelected[i]].selected = true;
			}
			
			if (!forcedUser)
			{
				if (GlobalVarContainer.getUser().getFirstBoom() == 1)
				{
					forceUserUseBoomz();
				}
			}
		}
		
		private function getBoomzSelected():Array
		{
			var returnArray = [];
			for (var i:int = 0; i<boomzContainerArray.length; ++i)
			{
				if (boomzContainerArray[i].selected)
				{
					returnArray.push(i);
				}
			}
			
			return returnArray;
		}
		
		private function scrollListUp(evt:MouseEvent):void
		{
			if(currentRow > numMenuDisplayRow)
			{
				evt.currentTarget.removeEventListener(MouseEvent.CLICK, scrollListUp);
				TweenMax.to(recipeListContainer, 0.3, {y:recipeListContainer.y + 145, onComplete:addScrollUpEvent});
				currentRow--;
			}
		}
		
		private function scrollListDown(evt:MouseEvent):void
		{
			if (currentRow < numMenuMaxRow)
			{
				evt.currentTarget.removeEventListener(MouseEvent.CLICK, scrollListDown);
				TweenMax.to(recipeListContainer, 0.3, {y:recipeListContainer.y - 145, onComplete:addScrollDownEvent});
				currentRow++;
			}
		}
		
		private function addScrollDownEvent():void
		{
			display.scrollDownButt.addEventListener(MouseEvent.CLICK, scrollListDown);
		}
		
		private function addScrollUpEvent():void
		{
			display.scrollUpButt.addEventListener(MouseEvent.CLICK, scrollListUp);
		}

		
		public function justShowSecondPart(dish:int):void
		{
			recipeChosen = dish;
			for (var i:int = 0; i<recipesInfoDisplayArray.length; ++i)
			{
				var recipeInfoDisplay = recipesInfoDisplayArray[i];
				
				if (dish == recipeInfoDisplay.dish)
				{
					trace(dish, "dish");
					recipeInfoDisplay.showSelect();

					
					//display.menuContents.removeChild(recipeDisplay);
					//updateRecipeDetails(dish);
				}
			}
			
			if (currentHalf != 2)
			{
				//display.menuBackground.menuTitle.text = "choose boomz";
				//display.menuBackground.menuTitle.x = 260;
				
				//display.menuContents.cookItBtn.visible = false;
				//display.menuContents.x = display.menuContents.x - 400;
				//display.menuContents.returnBtn.visible = true;
				//display.menuContents.returnBtn.addEventListener(MouseEvent.CLICK, showFirstHalf, false, 0, true);
				//display.menuContents.resetButt.addEventListener(MouseEvent.CLICK, resetBoomzSlots, false, 0, true);
				//display.menuContents.cookButt.addEventListener(MouseEvent.CLICK, startCookNow, false, 0, true);
				currentHalf = 2;
			}
		}

		public function updateDishInMenu(index:int, quantity:int):void
		{
			recipesInfoDisplayArray[index].updateDishQuantity(quantity);
		}
		
		public function updateTotalQuantity(quantity):void
		{
			//display.menuContents.totalServingText.text = "Total serving: " + quantity.toString();
		}
		
		private function setUpSecondPartMenu():void
		{
			boomzListContainer.x = 666;
			boomzListContainer.y = 49;
			//display.menuContents.addChild(boomzListContainer);
			
			//setUpBoomzSelection();
			
			if (GlobalVarContainer.getUser().getTutProgress() >= 40)
			{
				//display.menuContents.buyBoomzButt.addEventListener(MouseEvent.CLICK, popUpBoomzShop, false, 0, true);
			}
			
			//display.menuContents.returnBtn.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			//display.menuContents.buyBoomzButt.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			//display.menuContents.cookButt.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			//display.menuContents.resetButt.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			
			//display.menuContents.returnBtn.mouseChildren = false;
			//display.menuContents.buyBoomzButt.mouseChildren = false;
			//display.menuContents.cookButt.mouseChildren = false;
			//display.menuContents.resetButt.mouseChildren = false;
		}
		
		public function updateBoomzListContainer(index:int):void {
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			if (index === -1) {
				var i:int = booms.length - 1;
				//addBoomAt(i);
			}
			else {
				//updateBoomQuantityAt(index);				
			}			
		}
		
		public function addBoomz(boomzType:int, quantity:int) {
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			var lng:int = booms.length;
			var isNew:Boolean = true;
			//loop through instead
			var index:int = -1;
			for (var i:int = 0; i < lng; ++i) {
				if (booms[i].id === boomzType) {
					index = i;
					break;
				}
			}
			
			//var index:int = boomzListArray.indexOf(boomzType);
			if (index === -1) {
				var boom:Object = {
					id: boomzType,
					quantity: quantity
				}
				booms.push(boom);
			}
			else {
				booms[index].quantity += quantity;
			}
			updateBoomzListContainer(index);
		}
		
		private function startCookNow(evt:MouseEvent):void
		{
			//evt.currentTarget.removeEventListener(MouseEvent.CLICK, startCookNow);
			
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			var j = 0;
			for (var i = 0; i<3; ++i)
			{
				if (boomzSlotDisplayArray[i].boomzType !== 0)
				{
					boomzListChosen[j] = boomzSlotDisplayArray[i].boomzType;
					for (var m:int = 0; m<booms.length; ++m)
					{
						if (booms[m].id == boomzListChosen[j])
						{
							boomzChosenQuantity[j] = booms[m].quantity;
						}
					}
					++j;
				}
			}
			this.dispatchEvent(new Event("start cook"));
		}
		
		public function removeDishFromMenu(index:int):void
		{
			recipesInfoDisplayArray[index].hideServingInfo();
		}
		
		override public function get height():Number
		{
			return thisHeight;
		}
		
		override public function get width():Number
		{
			return thisWidth;
		}
		
		private function closeThis(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event("closed"));
			resetThis();
		}
		
		public function removeCloseThis():void
		{
			display.closeButt.removeEventListener(MouseEvent.CLICK, closeThis);
		}
		
		private function resetThis():void
		{
			//showFirstHalf(null);
		}
		
		public function removeSelect():void
		{
			//display.menuContents.cookItBtn.removeEventListener(MouseEvent.CLICK, showSecondPart);
		}
		
		public function destroy():void
		{
			
		}
	}
}