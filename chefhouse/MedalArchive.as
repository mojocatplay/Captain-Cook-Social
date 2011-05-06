package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	
	import restaurant.*;
	import util.*;
	import retrieveInfo.*;
	
	public class MedalArchive extends MovieClip
	{
		private var MedalUpgrade_Symbol:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("MedalUpgrade_Symbol"));
		private var Medal_Info:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("Medal_Info"));
		private var display;
		private var userBadges;
		private var medal_Info;
		
		private const NUM_MEDAL = 16;
		private var badgesArray:Array = new Array(NUM_MEDAL);
		private const BADGES = [1, 2, 3, 4, 6, 7, 9, 10, 12, 13, 15, 16, 18, 19, 21, 22];
		
		public function MedalArchive():void
		{
			display = new Sprite();
			
			medal_Info = new Medal_Info();
			
			displayBadges();
			this.addChild(display);
		}
		
		private function displayBadges():void
		{
			for (var i:int = 0; i<NUM_MEDAL; ++i)
			{
				var medal = MedalInfo.matchMedalDisplay(BADGES[i]);
				if (i < NUM_MEDAL/2)
				{
					medal.x = 50 + 109*int(i%2);
				}
				else
				{
					medal.x = 354 + 109*int(i%2);
				}

				medal.y = 45.75 + 82*int((i%8)/2);
				medal.index = BADGES[i];
				
				if (i%2 == 0)
				{
					var symbol = new MedalUpgrade_Symbol();
					symbol.x = 128.15 + 305*((i/2)%2);
					symbol.y = 68 + 82*int(i/4);
					
					display.addChild(symbol);
				}
				
				medal.addEventListener(MouseEvent.MOUSE_OVER, showMedalInfo);
				display.addChild(medal);
				badgesArray[i] = medal;
			}
			
			loadUserBadges();
		}
		
		private function showMedalInfo(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, showMedalInfo);
			var medalType = BADGES[badgesArray.indexOf(evt.currentTarget)];
			medal_Info.descriptionText.text = MedalInfo.matchMedalDescription(medalType);
			medal_Info.medalName.text = MedalInfo.matchMedalName(medalType);
			
			medal_Info.scaleX = medal_Info.scaleY = 1/0.7;
			
			medal_Info.x = MovieClip(evt.currentTarget).x - medal_Info.width/2 + MovieClip(evt.currentTarget).width/2;
			medal_Info.y = MovieClip(evt.currentTarget).y + 70;
			
			display.addChild(medal_Info);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, removeMedalInfo);
		}
		
		private function removeMedalInfo(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, removeMedalInfo);
			
			display.removeChild(medal_Info);
			
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, showMedalInfo);
		}
		
		public function loadUserBadges():void
		{
			userBadges = GlobalVarContainer.getUser().getBadges();
			
			for (var i:int = 0; i<userBadges.length; ++i)
			{
				for (var j:int = 0; j<NUM_MEDAL; ++j)
				{
					if (badgesArray[j].index == userBadges[i])
					{
						badgesArray[j].gotoAndStop(2);
					}
				}
			}
		}
	}
}