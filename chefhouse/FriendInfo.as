package chefhouse
{
	import flash.events.*;
	import flash.display.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import restaurant.*;
	import util.*;
	
	public class FriendInfo extends MovieClip
	{
		private var Friend_Info:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("Friend_Info"));
		private var FriendSpecial_Info:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("FriendSpecial_Info"));
		private var VisitFriend_Tooltip:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("VisitFriend_Tooltip"));

		private var visitfriend_tooltip;
		
		public var friend_id;
		public var level;
		public var exp;
		public var friend;
		
		private var friendDisplay;
		private var restaurantScene;
		
		public function FriendInfo(friend:Friend, restaurantScene:RestaurantScene):void
		{
			this.restaurantScene = restaurantScene;
			
			this.friend = friend;
			this.friend_id = friend.getUserId();
			this.level = friend.getLevel();
			this.exp = friend.getExp();
			
			if (friend.getUserId() != 1)
			{
				friendDisplay = new Friend_Info();
			}
			else
			{
				friendDisplay = new FriendSpecial_Info();
			}
			visitfriend_tooltip = new VisitFriend_Tooltip();
			visitfriend_tooltip.x = -36.8;
			visitfriend_tooltip.y = -87.7;
			visitfriend_tooltip.visitButt.mouseChildren = false;
			//friendDisplay.visitfriend_tooltip = visitfriend_tooltip;
			
			visitfriend_tooltip.visible = false;
			if (checkAlreadyChallenged()|| GlobalVarContainer.getUser().getLevel() < 2)
			{
				visitfriend_tooltip.challengeButt.gotoAndStop("disabled");
			}
			else
			{
				visitfriend_tooltip.challengeButt.addEventListener(MouseEvent.CLICK, challengePlayer);
			}
			
			visitfriend_tooltip.visitButt.addEventListener(MouseEvent.CLICK, visitPlayer);

			friendDisplay.addEventListener(MouseEvent.CLICK, onFriendDisplayOver)
						
			friendDisplay.friendName.text = friend.getLastName();
			friendDisplay.levelInfo.friendLevel.text = "Level " + friend.getLevel().toString();
			
			Functions.addImage(friendDisplay, friend.getPicSquare(), 15, 10);
			if (friendDisplay.friend_id == GlobalVarContainer.getUser().getId()) {
				Functions.addImage(GlobalVarContainer.getUser().getDisplay(), friend.getPicSquare(), 15, 10);
			}
			
			this.buttonMode = true;
			this.addChild(visitfriend_tooltip);
			this.addChild(friendDisplay);
		}
		
		private function checkAlreadyChallenged():Boolean
		{
			var myChallenges = GlobalVarContainer.getUser().getMyChallenges();
			for (var i:int = 0; i<myChallenges.length; ++i)
			{
				if (myChallenges[i][0] == friend.getUserId())
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function checkChallenge():void
		{
			if (checkAlreadyChallenged()|| GlobalVarContainer.getUser().getLevel() < 2)
			{
				visitfriend_tooltip.challengeButt.gotoAndStop("disabled");
				visitfriend_tooltip.challengeButt.removeEventListener(MouseEvent.CLICK, challengePlayer);
			}
			else
			{
				visitfriend_tooltip.challengeButt.addEventListener(MouseEvent.CLICK, challengePlayer);
			}
		}
		
		public function removeShowFriendInfo():void
		{
			friendDisplay.removeEventListener(MouseEvent.CLICK, onFriendDisplayOver);
		}
		
		private function onFriendDisplayOver(evt:Event):void
		{
			if (friend_id != GlobalVarContainer.getUser().getId())
			{
				dispatchEvent(new Event("closeOtherInfo"));
				evt.currentTarget.removeEventListener(MouseEvent.CLICK, onFriendDisplayOver);
				visitfriend_tooltip.visible = true;
				TweenLite.from(visitfriend_tooltip, 0.2, {y:"20", alpha:0});
				evt.currentTarget.addEventListener(MouseEvent.CLICK, onFriendDisplayOut);
			}
			else
			{
				dispatchEvent(new Event("closeOtherInfo"));
			}
		}
		
		private function onFriendDisplayOut(evt:Event):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, onFriendDisplayOut);
			visitfriend_tooltip.visible = false;
			friendDisplay.addEventListener(MouseEvent.CLICK, onFriendDisplayOver);
			friendDisplay.addEventListener(MouseEvent.MOUSE_OUT, friendDisplay.onOut);
		}
		
		public function hideToolTip():void
		{
			visitfriend_tooltip.visible = false;
			friendDisplay.removeEventListener(MouseEvent.CLICK, onFriendDisplayOut);
			friendDisplay.addEventListener(MouseEvent.CLICK, onFriendDisplayOver);
			friendDisplay.gotoAndStop(1);
			friendDisplay.addEventListener(MouseEvent.MOUSE_OUT, friendDisplay.onOut);
		}
		
		public function setLevelText(level:Number):void
		{
			friendDisplay.levelInfo.friendLevel.text = "Level " + level.toString();
		}
		
		private function challengePlayer(evt:Event):void
		{
			dispatchEvent(new Event("challengeFriend"));
			hideToolTip();
		}
		
		private function visitPlayer(evt:Event):void
		{
			dispatchEvent(new Event("visitFriend"));
			hideToolTip();
		}
	}
}