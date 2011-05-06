package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import retrieveInfo.*;
	import restaurant.RestaurantScene;
	import util.*;
	
	public class CookPrepare extends Sprite
	{
		//private static var recipeListArray = [/*1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11*/]; //
		//private static var recipeRatingArray = [/*1, 0, 2, 0, 2, 0, 0, 1, 3, 2, 0*/]; //
		//private static var boomzListArray = [/*-1, -2, -3, -4, -5, -102*/]; //
		//private static var boomzQuantityArray = [/*12, 2, 32, 4, 1, 1*/]; //
		private var boomzContainerArray = new Array();
		private var recipeContainerArray = new Array();
		private var ratingContainerArray = new Array();
		private var ingredientListArray = new Array();
		private var boomzSlotDisplayArray = new Array();
		private var boomzDisplayArray = new Array();
		
		private const recStartX = 8;
		private const recStartY = 19;

		private var display;
		private var numScroll;
		private var currentScroll = 2;
		private const numBoomzSelect = 3;
		private var selectSquare;
		private var recipeImage = null;
		private var RecIngreListBG:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("RecIngreListBG"));
		private var ChosenBoomzContainer:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("ChosenBoomzContainer"));
		private var BoomzChosenSquare:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("BoomzChosenSquare"));
		private var BoomzQuatitySymbol:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("BoomzQuatitySymbol"));
		private var CookPrepareDisplay:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("CookPrepareDisplay"));
		private var RecListMask:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("RecListMask"));
		private var SelectSquare:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("SelectSquare"));
		
		private var BoomzBlank:Class = Class(index.cookingAsset.loaderInfo.applicationDomain.getDefinition("BoomzBlank"));
		
		private var recIngreListBG = new RecIngreListBG();
		private var boomzChosenSquare;
		private var boomzSelectSquare;
		private var currentBoomzSlot:int;
		private var boomzListDot:Sprite = new Sprite();
		public var boomzListChosen:Array = [0, 0, 0];
		public var boomzChosenQuantity:Array = [0, 0, 0];
		public var recipeChosen:int;
		
		private const offsetX = -360;
		private const offsetY = -215;
		
		
/*		public static function setRecipeListArray(recipe:Array) {
			if (recipe != null) {
				recipeListArray = recipe;
			}			
		}
		public static function setRecipeRatingArray(recipe:Array) {
			if (recipe != null) {
				recipeRatingArray = recipe;
			}			
		}*/
/*		public static function setBoomzQuantityArray(boom:Array) {
			if (boom != null) {
				boomzQuantityArray = boom;
			}			
		}
		public static function setBoomzListArray(boom:Array) {
			if (boom != null) {
				boomzListArray = boom;
			}			
		}*/
		
		public function CookPrepare():void
		{
			display = new CookPrepareDisplay();
			this.addChild(display);
			display.prepareCloseButt.addEventListener(MouseEvent.CLICK, closeAll, false, 0, true);
			
			var recMask = new RecListMask();
			recMask.y = 15;
			display.recListContainer.addChild(recMask);
			display.recListContainer.mask = recMask;
			
			setUpMenu();
			setUpBoomzSelection();
			
			display.startButt.addEventListener(MouseEvent.CLICK, startCooking, false, 0, true);
			display.boomzListContainer.buyBoomzButt.addEventListener(MouseEvent.CLICK, popUpBoomzShop, false, 0, true);
		}
		
		private function startCooking(evt:MouseEvent):void
		{
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			var j = 0;
			for (var i = 0; i<3; ++i)
			{
				if (boomzSlotDisplayArray[i].boomzType !== 0)
				{
					boomzListChosen[j] = boomzSlotDisplayArray[i].boomzType;
					boomzChosenQuantity[j] = booms[i].quantity;
					++j;
				}
			}
			this.dispatchEvent(new Event("start cook"));
		}
		
		private function popUpBoomzShop(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).addBoomzShop();
		}
		
		private function setUpMenu():void
		{
			var lng:int = GlobalVarContainer.getUser().getRecipes().length;
			if (lng !== 0)
			{
				setUpRecipeList();
				numScroll = int(lng/4) + 1;
				
				display.recScrollUp.addEventListener(MouseEvent.CLICK, scrollRecUp, false, 0, true);
				display.recScrollDown.addEventListener(MouseEvent.CLICK, scrollRecDown, false, 0, true);
			}
		}
		
		private function scrollRecUp(evt:MouseEvent):void
		{
			if (currentScroll > 2)
			{
				var length = recipeContainerArray.length;
				for (var i = 0; i<length; ++i)
				{
					recipeContainerArray[i].y += 55;
					ratingContainerArray[i].y += 55;
				}
				
				selectSquare.y += 55;
				--currentScroll;
			}
		}
		
		private function scrollRecDown(evt:MouseEvent):void
		{
			if (currentScroll < numScroll)
			{
				var length = recipeContainerArray.length;
				for (var i = 0; i<length; ++i)
				{
					recipeContainerArray[i].y -= 55;
					ratingContainerArray[i].y -= 55;
				}
				selectSquare.y -= 55;
				++currentScroll;
			}
		}
		
		private function setUpRecipeList():void
		{
			var lng:int = GlobalVarContainer.getUser().getRecipes().length;
			var recipes:Array = GlobalVarContainer.getUser().getRecipes();
			for (var i = 0; i < lng; ++i)
			{
				recipeContainerArray[i] = RecipeInfo.matchRecipeDisplay(recipes[i].id);
				recipeContainerArray[i].scaleX = 0.71;
				recipeContainerArray[i].scaleY = 0.71;
				recipeContainerArray[i].x = recStartX + (70 - recipeContainerArray[i].width)/2 + 75*(i%4);
				recipeContainerArray[i].y = recStartY + (40 - recipeContainerArray[i].height) + 55*(int(i/4));
				recipeContainerArray[i].addEventListener(MouseEvent.CLICK, displayInfo, false, 0, true);
				display.recListContainer.addChild(recipeContainerArray[i]);
				
				ratingContainerArray[i] = RecipeInfo.matchRecipeRating(recipes[i].rating);
				ratingContainerArray[i].x = recipeContainerArray[i].x + (recipeContainerArray[i].width - ratingContainerArray[i].width)/2;
				ratingContainerArray[i].y = recStartY + 42.5 + 55*(int(i/4));
				display.recListContainer.addChild(ratingContainerArray[i]);
				
			}
			
			selectSquare = new SelectSquare();
			selectSquare.x = recStartX;
			selectSquare.y = recStartY;
			display.recListContainer.addChild(selectSquare);
			
			displayRecipeInfo(0);
		}
		
		private function displayInfo(evt:MouseEvent):void
		{
			selectSquare.x = evt.currentTarget.x - (70 - evt.currentTarget.width)/2;
			selectSquare.y = evt.currentTarget.y - (40 - evt.currentTarget.height) - 3;
			
			var index = recipeContainerArray.indexOf(evt.currentTarget);
			
			displayRecipeInfo(index);
		}
		
		private function displayRecipeInfo(i:int):void
		{
			var recipes:Array = GlobalVarContainer.getUser().getRecipes();
			display.recipeName.text = RecipeInfo.matchRecipeName(recipes[i].id);
			if (recipeImage)
			{
				//trace(recipeImage);
				if (display.contains(recipeImage))
				{
					display.removeChild(recipeImage);
				}
			}
			
			recipeImage = RecipeInfo.matchRecipeDisplay(recipes[i].id);
			recipeChosen = recipes[i].id;
			recipeImage.scaleX = 1.54;
			recipeImage.scaleY = 1.54;
			
			recipeImage.x = offsetX + 30 + (139 - recipeImage.width)/2;
			recipeImage.y = offsetY + 95 + (91 - recipeImage.height);
			
			display.addChild(recipeImage);
			
			var infoArray = RecipeInfo.matchRecipeRequirement(recipes[i].id);
			putInfoInPlace(infoArray);
			
			var ingreArray = RecipeInfo.matchRecipeIngre(recipes[i].id);
			putIngreInPlace(ingreArray);
		}
		
		private function putInfoInPlace(array:Array):void
		{
			if (array !== null)
			{
				display.recipeInfoDisplay.visible = true;
				display.recipeInfoDisplay.goldCost.selectable = false;
				display.recipeInfoDisplay.energyCost.selectable = false;
				display.recipeInfoDisplay.expGain.selectable = false;
				display.recipeInfoDisplay.moneyGain.selectable = false;
				display.recipeInfoDisplay.goldCost.text = array[0].toString();
				display.recipeInfoDisplay.energyCost.text = array[1].toString();
				display.recipeInfoDisplay.expGain.text = array[2].toString();
				display.recipeInfoDisplay.moneyGain.text = array[3].toString();
			}
		}

		private function putIngreInPlace(array:Array)
		{
			var length = array.length;
			var i:int;
			var desiredLength = length * 27;
			recIngreListBG.width = desiredLength;
			//recIngreListBG.scaleX = desiredLength/width;
			
			recIngreListBG.x = 25 + offsetX;
			recIngreListBG.y = 195 + offsetY;
			
			display.addChild(recIngreListBG);
			
			if (ingredientListArray)
			{
				var ingreLength = ingredientListArray.length;
				for (i = 0; i<ingreLength; ++i)
				{
					if (display.contains(ingredientListArray[0]))
					{
						display.removeChild(ingredientListArray[0]);
						ingredientListArray.shift();
					}
				}
			}
			
			for (i = 0; i<length; ++i)
			{
				ingredientListArray[i] = IngredientInfo.matchIngreDisplay(array[i]);
				ingredientListArray[i].scaleX = 0.55;
				ingredientListArray[i].scaleY = 0.55;
				
				ingredientListArray[i].x = 25 + 26*i + offsetX;
				ingredientListArray[i].y = 198 + offsetY;
				
				display.addChild(ingredientListArray[i]);
			}
		}
		
		private function setUpBoomzSelection():void
		{
			var i:int;
			for (i = 0; i<numBoomzSelect; ++i)
			{
				boomzSlotDisplayArray[i] = new ChosenBoomzContainer();
				boomzSlotDisplayArray[i].x = 370 + offsetX;
				boomzSlotDisplayArray[i].y = 67.6 + i*75 + offsetY;
				
				boomzSlotDisplayArray[i].boomzNameText.text = "name";
				boomzSlotDisplayArray[i].boomzNameText.selectable = false;
				boomzSlotDisplayArray[i].boomzDescriptionText.text = "Description";
				boomzSlotDisplayArray[i].boomzDescriptionText.selectable = false;
				boomzSlotDisplayArray[i].addEventListener(MouseEvent.MOUSE_DOWN, changeBoomzSelect, false, 0, true);
				boomzSlotDisplayArray[i].boomzType = 0;
				
				boomzDisplayArray[i] = new BoomzBlank();
				boomzDisplayArray[i].x = 3;
				boomzDisplayArray[i].y = 3;
				boomzSlotDisplayArray[i].addChild(boomzDisplayArray[i]);
				
				boomzSlotDisplayArray[i].boomzIndex = -1;
				
				display.addChild(boomzSlotDisplayArray[i]);
			}
			
			boomzChosenSquare = new BoomzChosenSquare();
			boomzChosenSquare.x = 370 + offsetX;
			boomzChosenSquare.y = 65.6 + offsetY;
			display.addChild(boomzChosenSquare);
			
			currentBoomzSlot = 0;
			
			setUpBoomzListContainer();
		}
		
		private function changeBoomzSelect(evt:MouseEvent):void {
			var index:int = boomzSlotDisplayArray.indexOf(evt.currentTarget);
			boomzChosenSquare.y = 65.6 + index * 75 + offsetY;
			currentBoomzSlot = index;
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
		
		private function updateBoomQuantityAt(index:int):void {
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			BoomzQuatitySymbol(boomzContainerArray[index].getChildAt(boomzContainerArray[index].numChildren - 1)).quantityText.text = booms[index].quantity.toString();
		}
		
		private function addBoomAt(index:int):void {
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			boomzContainerArray[index] = BoomzInfo.matchBoomzDisplay(booms[index].id);
			boomzContainerArray[index].y = 10 + 50*int(index/2);
			boomzContainerArray[index].x = 9 + 55*(index%2);
			boomzContainerArray[index].scaleX = 0.92;
			boomzContainerArray[index].scaleY = 0.92;
			boomzContainerArray[index].gotoAndStop("normal");

			var boomzSymbol = new BoomzQuatitySymbol();
			boomzSymbol.quantityText.text = booms[index].quantity.toString();
			boomzSymbol.x = 35;
			boomzContainerArray[index].selected = false;
			//boomzContainerArray[index].typeBoomz = boomzListArray[index];
			boomzContainerArray[index].addChild(boomzSymbol);
			boomzContainerArray[index].addEventListener(MouseEvent.MOUSE_DOWN, selectBoomz, false, 0, true);				
			display.boomzListContainer.addChild(boomzContainerArray[index]);
		}
		
		private function setUpBoomzListContainer():void
		{
			var booms:Array = GlobalVarContainer.getUser().getBooms();
			var i:int;
			var length = booms.length;
			for (i = 0; i<length; ++i)
			{
				addBoomAt(i);
			}
		}
		
		private function selectBoomz(evt:MouseEvent):void
		{
			if (!evt.currentTarget.selected)
			{
				var index = boomzContainerArray.indexOf(evt.currentTarget);
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
			boomzChosenSquare.y = 65.6 + currentBoomzSlot * 75 + offsetY;
		}
		
		private function closeAll(evt:MouseEvent):void
		{
			this.visible = false;
			this.dispatchEvent(new Event("closed"));
		}
	}
}