package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import util.Animation;
	import retrieveInfo.*;
	
	public class BJResult extends MovieClip
	{
		private static var BJNormalGameResult_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("BJNormalGameResult_PopUp"));
		public var display;
		private var chartCols:Array;
		private var chartValues:Array;
		
		private var result:Array;
		private var specialMove:Array;
		private var ingredients:Array;
		private var vip:int;
		private var dishToCook:int;
		
		private var minmaxIndex:Array;
		
		private const MAX_CHART_COL_HEIGHT = 72.0;
		
		public function BJResult(result:Array, specialMove:Array, dishToCook:int, vip:int = 0):void
		{
			//trace("sp", specialMove);
			this.result = result;
			this.specialMove = specialMove;
			this.ingredients = RecipeInfo.matchRecipeIngre(dishToCook);
			this.dishToCook = dishToCook;
			this.vip = vip;
			
			display = new BJNormalGameResult_PopUp();
			this.addChild(display);
			chartCols = [display.chart.col1, display.chart.col2,
							 display.chart.col3, display.chart.col4,
							 display.chart.col5, display.chart.col6,
							 display.chart.col7];

			chartValues = [0, 0, 0, 0, 0, 0, 0];
			translateValue();

			minmaxIndex = findMaxAndMin();
			display.chart.maxDishNo.text = result[minmaxIndex[1]].toString();
			display.chart.minDishNo.text = result[minmaxIndex[0]].toString();
			display.chart.minDishNo.alpha = 0;
			
			display.expGain.text = (result[minmaxIndex[0]]*RecipeInfo.matchRecipeRequirement(dishToCook)[2]).toString();
			//display.reward.expGain.text = (result[minmaxIndex[0]]*RecipeInfo.matchRecipeRequirement(dishToCook)[2]).toString();
			
			setUpIngre();
			setUpDish();
			
			this.addEventListener("animateBars", startBarsAnimation);
		}
		
		private function startBarsAnimation(evt:Event):void
		{
			setUpCharts(int((7 - result.length)/2), int((7 - result.length)/2) + result.length - 1);
		}
		
		private function translateValue():void
		{
			var offSet = int((7 - result.length)/2);
			for (var i:int = 0; i<result.length; ++i)
			{
				chartValues[i+offSet] = result[i];
			}
		}
		
		private function findMaxAndMin():Array
		{
			var min = 999;
			var max = -1;
			var minIndex = -1;
			var maxIndex = -1;
			
			for (var i:int = 0; i<result.length; ++i)
			{
				if (result[i] < min)
				{
					min = result[i];
					minIndex = i;
				}
				
				if (result[i] > max)
				{
					max = result[i];
					maxIndex = i;
				}
			}
			
			return [minIndex, maxIndex];
		}
		
		private function setUpCharts(begin:int, end:int)
		{
			for(var i:int = begin; i <= end; ++i) {		
				chartCols[i].tooltip.counter.text = chartValues[i];

				chartCols.mouseChildren = false;
				chartCols[i].addEventListener(MouseEvent.MOUSE_OVER, chartCol_over);
				chartCols[i].addEventListener(MouseEvent.MOUSE_OUT, chartCol_out);

				var maskY = chartCols[i].colMask.y - MAX_CHART_COL_HEIGHT*chartValues[i]/result[minmaxIndex[1]];	
				TweenLite.to(chartCols[i].colMask, 1, {y: maskY});	

				if(i == end) {
					TweenLite.to(chartCols[i].colMask, 1, {y: maskY, onComplete:chartAniOnComplete});	
					Animation.runningCounter(display.bonus.fiveInARow.counter, specialMove[1]);
					Animation.runningCounter(display.bonus.lShape.counter, specialMove[2]);
					Animation.runningCounter(display.bonus.fourInARow.counter, specialMove[0]);
					Animation.runningCounter(display.bonus.vip.counter, this.vip);		
				}

				if(i == minmaxIndex[0] + int((7 - result.length)/2)) {
					chartCols[i].removeEventListener(MouseEvent.MOUSE_OVER, chartCol_over);
					chartCols[i].removeEventListener(MouseEvent.MOUSE_OUT, chartCol_out);
				}
			}
		}
		
		private function setUpIngre():void
		{
			for (var i:int = 0; i<ingredients.length; ++i)
			{
				var ingredient = IngredientInfo.matchIngreDisplay(ingredients[i]);
				ingredient.scaleX = ingredient.scaleY = 0.5;
				ingredient.y = 80;
				ingredient.x = 18 + 31*(i + int((7 - result.length)/2));
				display.chart.addChild(ingredient);
			}
		}
		
		private function setUpDish():void
		{
			var dishToCookDisplay = RecipeInfo.matchRecipeDisplay(dishToCook);
			dishToCookDisplay.scaleX = dishToCookDisplay.scaleY = 112.4/dishToCookDisplay.width;
			dishToCookDisplay.x = 50.25;
			dishToCookDisplay.y = 170.7 - dishToCookDisplay.height;
			display.addChild(dishToCookDisplay);
			
			display.recipeName.text = RecipeInfo.matchRecipeName(dishToCook);
		}
		
		private function chartCol_over(e:MouseEvent):void{
			if(e.target && e.target.tooltip){
				e.target.tooltip.visible = true;
				e.target.tooltip.y = e.target.colMask.y - 30;
			}
		}

		private function chartCol_out(e:MouseEvent):void{
			if(e.target && e.target.tooltip){
				e.target.tooltip.visible = false;	
			}
		}
		
		private function chartAniOnComplete():void{
			chartCols[minmaxIndex[0] + int((7 - result.length)/2)].gotoAndPlay(2);
			display.chart.minDishNo.visible = true;
			display.chart.minDishNo.x = chartCols[minmaxIndex[0] + int((7 - result.length)/2)].x + 2;
			display.chart.minDishNo.y = chartCols[minmaxIndex[0] + int((7 - result.length)/2)].colMask.y - 5;
			display.chart.minDishNo.alpha = 1;
			TweenLite.to(display.chart.minDishNo, 0.5, {y:"-10", onComplete:updateTotalDishNo});

		}

		private function updateTotalDishNo():void{
			display.totalDishNo.totalDishNoMC.textField.text = "x " + result[minmaxIndex[0]];
			display.totalDishNo.gotoAndPlay(2);
			//TweenLite.to(display.recipeLevel.progressBar, 1, {width:"30"});
			TweenLite.delayedCall(1, showReward);
		}

		private function showReward():void{
			TweenLite.to(display.reward, 0.5, {y:"-45"});
			//TweenLite.from(display.reward.boomz1Quantity, 0.5, {x:"-20", alpha:0.5});
			//TweenLite.from(display.reward.boomz2Quantity, 0.5, {x:"-20", alpha:0.5});
		}

		private function onClick(e:MouseEvent):void{
			Animation.shakeDisappear(display);
		}
	}
}