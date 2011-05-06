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
	
	public class RestaurantMenu extends MovieClip
	{
		private var RestaurantMenu_PopUp:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("RestaurantMenu_PopUp"));
		private var RecipePossessInfoDisplay:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("RecipePossessInfoDisplay"));
		private var BoomzBlank:Class = Class(index.cookingAsset.loaderInfo.applicationDomain.getDefinition("BoomzBlank"));
		private var BoomzChosenSquare:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("BoomzChosenSquare"));
		private var ChosenBoomzContainer:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("ChosenBoomzContainer"));
		private var BoomzQuantitySymbol:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("BoomzQuantitySymbol"));
		
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
		
		public function RestaurantMenu():void
		{
			display = new RestaurantMenu_PopUp();
			thisHeight = display.menuBackground.height;
			thisWidth = display.menuBackground.width;
			
			minorUpdate();
			setUpFirstPartMenu();
			setUpSecondPartMenu();
						
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
				transferData(i);
			}
			
			forcedUser = true;
		}
		
		private function setUpRecipeList():void
		{
			var userRecipes = GlobalVarContainer.getUser().getRecipes();
			var length = userRecipes.length;
			
			for (var i:int = 0; i<length; ++i)
			{
				if (userRecipes[i].id < 1000)
				{
					recipes.push(userRecipes[i]);
				}
			}
			
			length = recipes.length;
			
			numMenuMaxRow = Math.ceil((length+1)/3);
			
			recipeListContainer.x = 0;
			recipeListContainer.y = 33;
			
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
				recipeInfoDisplay.x = 130*(i%3);
				recipeInfoDisplay.y = 11.5 + 132*int(i/3);
				
				if (i<length)
				{
					if (tmpQuantityArray[i] > 0)
					{
						recipeInfoDisplay.showServingInfo(tmpQuantityArray[i]);
					}
				
					if (i === 0)
					{
						recipeInfoDisplay.showSelect();
						prevSelect = recipeInfoDisplay;
					}
				
					recipeInfoDisplay.addEventListener(MouseEvent.CLICK, showDetails, false, 0, true);
				
					recipesInfoDisplayArray.push(recipeInfoDisplay);
				}
				else
				{
					recipeInfoDisplay.addEventListener(MouseEvent.CLICK, showMap, false, 0, true);
				}
				
				recipeInfoDisplay.buttonMode = true;
				recipeListContainer.addChild(recipeInfoDisplay);
			}
			
			recipeChosen = recipes[0].id;
			
			display.menuContents.totalServingText.text = "Total serving: " + totalServing.toString();
			
			display.menuContents.scrollUpButt.addEventListener(MouseEvent.CLICK, scrollListUp);
			display.menuContents.scrollDownButt.addEventListener(MouseEvent.CLICK, scrollListDown);
			
			recipeListContainer.mask = display.recipeListMask;
			display.menuContents.addChild(recipeListContainer);
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
			
			resetBoomzListContainer();
			setUpBoomzListContainer();
			
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
				TweenMax.to(recipeListContainer, 0.3, {y:recipeListContainer.y + 132, onComplete:addScrollUpEvent});
				currentRow--;
			}
		}
		
		private function scrollListDown(evt:MouseEvent):void
		{
			if (currentRow < numMenuMaxRow)
			{
				evt.currentTarget.removeEventListener(MouseEvent.CLICK, scrollListDown);
				TweenMax.to(recipeListContainer, 0.3, {y:recipeListContainer.y - 132, onComplete:addScrollDownEvent});
				currentRow++;
			}
		}
		
		private function addScrollDownEvent():void
		{
			display.menuContents.scrollDownButt.addEventListener(MouseEvent.CLICK, scrollListDown);
		}
		
		private function addScrollUpEvent():void
		{
			display.menuContents.scrollUpButt.addEventListener(MouseEvent.CLICK, scrollListUp);
		}
		
		private function showDetails(evt:MouseEvent):void
		{
			var dish = evt.currentTarget.dish;

			recipeChosen = dish;			
			
			RecipePossessInfo(evt.currentTarget).showSelect();
			if (prevSelect && prevSelect != evt.currentTarget)
			{
				prevSelect.hideSelect();
			}
						
			display.menuContents.removeChild(recipeDisplay);
			
			updateRecipeDetails(dish);
						
			prevSelect = evt.currentTarget as RecipePossessInfo;
			
			display.menuContents.cookItBtn.addEventListener(MouseEvent.CLICK, showSecondPart, false, 0, true);
			dispatchEvent(new Event("showDetails"));
		}
		
		private function setUpFirstPartMenu():void
		{
			updateRecipeDetails(tmpDishArray[0]);
			display.menuContents.returnBtn.visible = false;
			display.menuContents.cookItBtn.addEventListener(MouseEvent.CLICK, showSecondPart, false, 0, true);
			display.menuContents.cookItBtn.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			display.menuContents.cookItBtn.mouseChildren = false;
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
					if (prevSelect && prevSelect != recipeDisplay)
					{
						prevSelect.hideSelect();
					}
					
					display.menuContents.removeChild(recipeDisplay);
					updateRecipeDetails(dish);
					prevSelect = recipeInfoDisplay;
				}
			}
			
			if (currentHalf != 2)
			{
				display.menuBackground.menuTitle.text = "choose boomz";
				display.menuBackground.menuTitle.x = 260;
				
				display.menuContents.cookItBtn.visible = false;
				display.menuContents.x = display.menuContents.x - 400;
				display.menuContents.returnBtn.visible = true;
				display.menuContents.returnBtn.addEventListener(MouseEvent.CLICK, showFirstHalf, false, 0, true);
				display.menuContents.resetButt.addEventListener(MouseEvent.CLICK, resetBoomzSlots, false, 0, true);
				display.menuContents.cookButt.addEventListener(MouseEvent.CLICK, startCookNow, false, 0, true);
				currentHalf = 2;
			}
		}
		
		private function showSecondPart(evt:MouseEvent):void
		{
			if (currentHalf != 2)
			{
				display.menuBackground.menuTitle.text = "choose boomz";
				display.menuBackground.menuTitle.x = 260;
				
				display.menuContents.cookItBtn.visible = false;
				TweenMax.to(display.menuContents, 0.3, {x: display.menuContents.x - 400, onComplete:function(){dispatchEvent(new Event("showedSecondHalf"));}});
				display.menuContents.returnBtn.visible = true;
				display.menuContents.returnBtn.addEventListener(MouseEvent.CLICK, showFirstHalf, false, 0, true);
				display.menuContents.resetButt.addEventListener(MouseEvent.CLICK, resetBoomzSlots, false, 0, true);
				display.menuContents.cookButt.addEventListener(MouseEvent.CLICK, startCookNow, false, 0, true);
				currentHalf = 2;
				
				dispatchEvent(new Event("showSecondHalf"));
			}
		}
		
		private function showFirstHalf(evt:MouseEvent):void
		{
			if (currentHalf != 1)
			{
				display.menuBackground.menuTitle.text = "menu";
				display.menuBackground.menuTitle.x = 181.85;
				
				display.menuContents.returnBtn.visible = false;
				TweenMax.to(display.menuContents, 0.3, {x: display.menuContents.x + 400});
				display.menuContents.cookItBtn.visible = true;
				currentHalf = 1;
			}
		}
		
		private function animateButton(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, animateButton);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, addAnimate);
			MovieClip(evt.currentTarget).gotoAndPlay(2);
		}
		
		private function addAnimate(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, addAnimate);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, animateButton);
		}
		
		private function updateRecipeDetails(dish:int):void
		{
			recipeDisplay = RecipeInfo.matchRecipeDisplay(dish);
			recipeDisplay.scaleY = recipeDisplay.scaleX = 122.35/recipeDisplay.width;
			recipeDisplay.x = 460;
			recipeDisplay.y = 142 - recipeDisplay.height;
			display.menuContents.addChild(recipeDisplay);
			
			display.menuContents.recipeName.text = RecipeInfo.matchRecipeName(dish);
			
			display.menuContents.moneyCost.text = RecipeInfo.matchRecipeRequirement(dish)[0].toString();
			display.menuContents.energyCost.text = RecipeInfo.matchRecipeRequirement(dish)[1].toString();
			display.menuContents.expGain.text = RecipeInfo.matchRecipeRequirement(dish)[2].toString() + " per dish";
			
			putIngreInPlace(RecipeInfo.matchRecipeIngre(dish));
		}
		
		private function putIngreInPlace(array:Array)
		{
			var length = array.length;
			var i:int;
			var desiredLength = length * 29;
			display.menuContents.recipeListBG.width = desiredLength;
			
			flushIngreList();
			for (i = 0; i<length; ++i)
			{
				var ingre = IngredientInfo.matchIngreDisplay(array[i]);
				ingre.scaleX = 0.57;
				ingre.scaleY = 0.57;
				
				ingre.x = display.menuContents.recipeListBG.x - display.menuContents.recipeListBG.width/2 + 3 +  27*i;
				ingre.y = display.menuContents.recipeListBG.y - display.menuContents.recipeListBG.height/2;
				
				ingreListDisplay.push(ingre);
				display.menuContents.addChild(ingre);
			}
		}
		
		private function flushIngreList():void
		{
			var length = ingreListDisplay.length;
			for (var i:int = 0; i< length; ++i)
			{
				if (display.menuContents.contains(ingreListDisplay[0]))
				{
					display.menuContents.removeChild(ingreListDisplay[0]);
				}
				ingreListDisplay.shift();
			}
		}
		
		public function updateDishInMenu(index:int, quantity:int):void
		{
			recipesInfoDisplayArray[index].updateDishQuantity(quantity);
		}
		
		public function updateTotalQuantity(quantity):void
		{
			display.menuContents.totalServingText.text = "Total serving: " + quantity.toString();
		}
		
		private function setUpSecondPartMenu():void
		{
			boomzListContainer.x = 666;
			boomzListContainer.y = 49;
			display.menuContents.addChild(boomzListContainer);
			
			setUpBoomzSelection();
			
			if (GlobalVarContainer.getUser().getTutProgress() >= 40)
			{
				display.menuContents.buyBoomzButt.addEventListener(MouseEvent.CLICK, popUpBoomzShop, false, 0, true);
			}
			
			display.menuContents.returnBtn.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			display.menuContents.buyBoomzButt.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			display.menuContents.cookButt.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			display.menuContents.resetButt.addEventListener(MouseEvent.MOUSE_OVER, animateButton, false, 0, true);
			
			display.menuContents.returnBtn.mouseChildren = false;
			display.menuContents.buyBoomzButt.mouseChildren = false;
			display.menuContents.cookButt.mouseChildren = false;
			display.menuContents.resetButt.mouseChildren = false;
		}
		
		private function setUpBoomzSelection():void
		{
			var i:int;
			for (i = 0; i<numBoomzSelect; ++i)
			{
				boomzSlotDisplayArray[i] = new ChosenBoomzContainer();
				boomzSlotDisplayArray[i].x = 860;
				boomzSlotDisplayArray[i].y = 60.5 + i*75;
				
				boomzSlotDisplayArray[i].boomzNameText.text = "name";
				boomzSlotDisplayArray[i].boomzDescriptionText.text = "Description";
				boomzSlotDisplayArray[i].addEventListener(MouseEvent.MOUSE_DOWN, changeBoomzSelect, false, 0, true);
				boomzSlotDisplayArray[i].mouseChildren = false;
				boomzSlotDisplayArray[i].boomzType = 0;
				
				boomzDisplayArray[i] = new BoomzBlank();
				boomzDisplayArray[i].x = 3;
				boomzDisplayArray[i].y = 3;
				boomzSlotDisplayArray[i].addChild(boomzDisplayArray[i]);
				
				boomzSlotDisplayArray[i].boomzIndex = -1;
				
				display.menuContents.addChild(boomzSlotDisplayArray[i]);
			}
			
			boomzChosenSquare = new BoomzChosenSquare();
			boomzChosenSquare.x = 860;
			boomzChosenSquare.y = 60.5;
			display.menuContents.addChild(boomzChosenSquare);
			
			currentBoomzSlot = 0;
			
			setUpBoomzListContainer();
		}
		
		private function setUpBoomzListContainer():void
		{
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			var i:int;
			var length = booms.length;
			if (GlobalVarContainer.getUser().getTutProgress() >= 40)
			{
				for (i = 0; i<length; ++i)
				{
					addBoomAt(i);
				}
			}
		}
		
		private function resetBoomzListContainer():void
		{
			var length = boomzContainerArray.length;
			for (var i:int = 0; i<length; ++i)
			{
				boomzListContainer.removeChild(boomzContainerArray[0]);
				boomzContainerArray[0] = null;
				boomzContainerArray.shift();
			}
		}
		
		private function addBoomAt(index:int):void 
		{
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			boomzContainerArray[index] = BoomzInfo.matchBoomzDisplay(booms[index].id);
			boomzContainerArray[index].y = 10 + 60*int(index/3);
			boomzContainerArray[index].x = 9 + 55*(index%3);
			boomzContainerArray[index].scaleX = 0.92;
			boomzContainerArray[index].scaleY = 0.92;
			boomzContainerArray[index].gotoAndStop("normal");

			var boomzSymbol = new BoomzQuantitySymbol();
			boomzSymbol.quantityText.text = booms[index].quantity.toString();
			boomzSymbol.y = boomzContainerArray[index].height + 13;
			boomzSymbol.x = 11;
			boomzContainerArray[index].selected = false;
			boomzContainerArray[index].addChild(boomzSymbol);
			boomzContainerArray[index].addEventListener(MouseEvent.MOUSE_DOWN, selectBoomz, false, 0, true);
							
			boomzListContainer.addChild(boomzContainerArray[index]);
		}
		
		private function resetBoomzSlots(evt:MouseEvent):void
		{
			for (var i:int = 0; i<numBoomzSelect; ++i)
			{
				boomzSlotDisplayArray[i].removeChild(boomzDisplayArray[i]);
				boomzDisplayArray[i] = new BoomzBlank();
				boomzDisplayArray[i].x = 3;
				boomzDisplayArray[i].y = 3;
				boomzSlotDisplayArray[i].addChild(boomzDisplayArray[i]);
				boomzSlotDisplayArray[i].boomzNameText.text = "Name";
				boomzSlotDisplayArray[i].boomzDescriptionText.text = "Description";
				boomzSlotDisplayArray[i].boomzIndex = -1;
				
				boomzSlotDisplayArray[i].removeEventListener(MouseEvent.MOUSE_OVER, animateButton);
				
			}
			
			boomzChosenSquare.x = 860;
			boomzChosenSquare.y = 60.5;

			currentBoomzSlot = 0;
			
			for (i = 0; i< boomzContainerArray.length; ++i)
			{
				//trace(boomzContainerArray.length);
				boomzContainerArray[i].alpha = 1;
				boomzContainerArray[i].selected = false;
			}
		}
		
		public function updateBoomzListContainer(index:int):void {
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			if (index === -1) {
				var i:int = booms.length - 1;
				addBoomAt(i);
			}
			else {
				updateBoomQuantityAt(index);				
			}			
		}
		
		private function changeBoomzSelect(evt:MouseEvent):void {
			var index:int = boomzSlotDisplayArray.indexOf(evt.currentTarget);
			boomzChosenSquare.y = 60.5 + index * 75;
			currentBoomzSlot = index;
		}
		
		private function selectBoomz(evt:MouseEvent):void
		{
			if (!evt.currentTarget.selected)
			{
				var index = boomzContainerArray.indexOf(evt.currentTarget);
				//trace(index, evt.currentTarget.alpha);
				evt.currentTarget.selected = true;
				evt.currentTarget.alpha = 0.2;
				transferData(index);
			}
		}
		
		private function transferData(index:int):void
		{
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			var selected = boomzSlotDisplayArray[currentBoomzSlot];
			if (boomzSlotDisplayArray[currentBoomzSlot].boomzIndex !== -1)
			{
				var bIndex = boomzSlotDisplayArray[currentBoomzSlot].boomzIndex;
				boomzContainerArray[bIndex].selected = false;
				boomzContainerArray[bIndex].alpha = 1;
			}
			selected.addEventListener(MouseEvent.MOUSE_OVER, animateButton);
			
			boomzSlotDisplayArray[currentBoomzSlot].boomzIndex = index;
			boomzSlotDisplayArray[currentBoomzSlot].boomzType = booms[index].id;
			selected.boomzNameText.text = BoomzInfo.matchBoomzName(booms[index].id);
			selected.boomzDescriptionText.text = BoomzInfo.matchBoomzDescription(booms[index].id);
			if (boomzDisplayArray[currentBoomzSlot])
			{
				selected.removeChild(boomzDisplayArray[currentBoomzSlot]);
			}
			boomzDisplayArray[currentBoomzSlot] = BoomzInfo.matchBoomzDisplay(booms[index].id);
			boomzDisplayArray[currentBoomzSlot].scaleX = 0.92;
			boomzDisplayArray[currentBoomzSlot].scaleY = 0.92;
			boomzDisplayArray[currentBoomzSlot].x = 3;
			boomzDisplayArray[currentBoomzSlot].y = 3;
			selected.addChild(boomzDisplayArray[currentBoomzSlot]);
			
			currentBoomzSlot += 1;
			currentBoomzSlot = (currentBoomzSlot)%3;
			boomzChosenSquare.y = 60.5 + currentBoomzSlot * 75;
		}
		
		private function updateBoomQuantityAt(index:int):void 
		{
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			BoomzQuantitySymbol(boomzContainerArray[index].getChildAt(boomzContainerArray[index].numChildren - 1)).quantityText.text = booms[index].quantity.toString();
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
		
		private function popUpBoomzShop(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).addBoomzShop();
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
			showFirstHalf(null);
		}
		
		public function removeSelect():void
		{
			display.menuContents.cookItBtn.removeEventListener(MouseEvent.CLICK, showSecondPart);
			prevSelect.hideSelect();
		}
		
		public function destroy():void
		{
			
		}
	}
}