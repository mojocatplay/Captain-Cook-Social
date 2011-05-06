package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	
	import restaurant.*;
	import util.*;
	import com.greensock.*;
	import retrieveInfo.*;
	
	public class IslandMap extends MovieClip	
	{
		private var IslandChap1_Map:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("IslandChap1_Map"));
		private var display;
		private var level;
		private var mapMask;
		public function IslandMap():void
		{
			display = new IslandChap1_Map();
			display.addEventListener("mapLoaded", initiateMap);
			
			level = GlobalVarContainer.getUser().getLevel();

			display.robinHouse.addEventListener(MouseEvent.CLICK, openRobinson);
			display.klausHouse.addEventListener(MouseEvent.CLICK, openKlaus);
			display.marcielHouse.addEventListener(MouseEvent.CLICK, openMarciel);
			
			display.lightHouse.addEventListener(MouseEvent.CLICK, openLightHouse);
			
			display.yourHouse.addEventListener(MouseEvent.CLICK, closeMap);
						
			this.addChild(display);
		}
		
		private function initiateMap(evt:Event):void
		{
			dispatchEvent(new Event("mapLoaded"));
			if (level < 10)
			{
				display.face_robin.visible = true;
				display.lockRobin.visible = false;
			}
			else if (level < 18)
			{
				display.face_klaus.visible = true;
				display.face_robin.visible = true;
				
				display.lockKlaus.visible = false;
				display.lockRobin.visible = false;
			}
			else
			{
				display.face_marciel.visible = true;
				display.face_klaus.visible = true;
				display.face_robin.visible = true;
				
				display.lockMarciel.visible = false;
				display.lockKlaus.visible = false;
				display.lockRobin.visible = false;
			}
			
			if (GlobalVarContainer.getUser().getTutProgress() >= 80)
			{
				display.face_cc.visible = true;
				display.lockCook.visible = false;
			}
		}
		
		private function openRobinson(evt:Event):void
		{
			RestaurantScene(this.parent).removeOverlay();			
			RestaurantScene(this.parent).loadChefHouse(0);
			//RestaurantScene(this.parent).closeIslandMap();
		}
		
		private function openKlaus(evt:Event):void
		{
			if (level >= 10)
			{	
				RestaurantScene(this.parent).removeOverlay();
				RestaurantScene(this.parent).loadChefHouse(1);
				//RestaurantScene(this.parent).closeIslandMap();
			}
		}	
		
		private function openMarciel(evt:Event):void
		{
			if (level >= 18)
			{
				RestaurantScene(this.parent).removeOverlay();
				RestaurantScene(this.parent).loadChefHouse(2);
				//RestaurantScene(this.parent).closeIslandMap();
			}
		}	
		
		private function openLightHouse(evt:MouseEvent):void
		{
			if (GlobalVarContainer.getUser().getTutProgress() >= 80)
			{
				showSpecialRecipes();
			}
		}
		
		public function closeLightHouse(evt:Event = null):void
		{
			RestaurantScene(this.parent).removeSpecialRecipePopUp();
		}
		
		private function showSpecialRecipes():void
		{
			if (GlobalVarContainer.getUser().getLightHouse() == 0)
			{
				var LightHousePt1_Story:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("LightHousePt1_Storyline"));
				var LightHousePt2_Story:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("LightHousePt2_Storyline"));
				var LightHousePt3_Story:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("LightHousePt3_Storyline"));
				
				var storyPt1 = new LightHousePt1_Story();
				storyPt1.gotoAndStop(1);
				var storyPt2 = new LightHousePt2_Story();
				storyPt2.gotoAndStop(1);
				var storyPt3 = new LightHousePt3_Story();
				storyPt3.gotoAndStop(1);
				
				var storyLineObjects = [storyPt1, storyPt2, storyPt3];
				var storyline = new StoryLine(storyLineObjects);				
				
				storyline.addEventListener("StoryEnds", removeLighthouseStory);
				RestaurantScene(this.parent).addChild(storyline);
			}
			else
			{
				var userRecipes = GlobalVarContainer.getUser().getRecipes();
				userRecipes.sortOn("id", Array.NUMERIC);
				var j = 0;
				for (var i:int = 0; i<userRecipes.length; ++i)
				{
					//trace(j, RecipeInfo.getSpecialRecipes()[j], userRecipes[i].id);
					if (RecipeInfo.getSpecialRecipes()[j] == userRecipes[i].id)
					{
						j++;
					}
				}
				RestaurantScene(this.parent).addSpecialRecipePopUp(RecipeInfo.getSpecialRecipes()[j]);
			}
		}
		
		private function removeLighthouseStory(evt:Event):void
		{
			evt.currentTarget.removeEventListener("StoryEnds", removeLighthouseStory);
			
			GlobalVarContainer.getUser().setLightHouse(1);
			GlobalVarContainer.getUser().getChanges().lighthouse = 1;
			
			RestaurantScene(this.parent).removeChild(evt.currentTarget as Sprite);
			RestaurantScene(this.parent).addSpecialRecipePopUp(RecipeInfo.getSpecialRecipes()[0]);
		}
		
		private function closeMap(evt:MouseEvent):void
		{
			RestaurantScene(this.parent).removeOverlay();
			RestaurantScene(this.parent).removeSpecialRecipePopUp();
			RestaurantScene(this.parent).closeIslandMap();
		}
		
		public function startMap():void
		{
			display.gotoAndPlay(1);
		}
		
		public function disableGoBack():void
		{
			display.yourHouse.removeEventListener(MouseEvent.CLICK, closeMap);
		}
		
		public function enableGoBack():void
		{
			display.yourHouse.addEventListener(MouseEvent.CLICK, closeMap);
		}
	}	
}