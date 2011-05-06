package characters
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.*;
	
	import restaurant.*;

	public class GameCharacter extends Base
	{
		private var Pirate1Char:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("Pirate1Char"));
		private var ThodanChar:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("ThodanChar"));
		private var Islamic:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("Islamic"));
		private var WaiterCheap:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("WaiterCheap"));
		private var ChefChar:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("ChefChar"));
		private var Pirate2Char:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("Pirate2Char"));
		private var Pirate3Char:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("Pirate3Char"));
		private var NinjaChar:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("NinjaChar"));
		private var FakeVIPChar:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("FakeVIPChar"));
		private var Critic_VIP:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("Critic_VIP"));
		private var Diva_VIP:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("Diva_VIP"));
		private var BigBoss_VIP:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("BigBoss_VIP"));
		private var MasterChef_VIP:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("MasterChef_VIP"));
		private var EmotionCharacter:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("EmotionCharacter"));
		private var CaptainCook_Char:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("CaptainCook_Char"));
		private var WaiterExpensive:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("WaiterExpensive"));
		
		private var eventArray:Array = new Array();
		public static const BJ_TYPE:String = "bj char";
		public static const RESTAURANT_TYPE:String = "restaurant char";
		
		public static const THODAN_CHAR:String = "tho dan";
		public static const PIRATE1_CHAR:String = "pirate 1";
		public static const PIRATE2_CHAR:String = "pirate 2";
		public static const PIRATE3_CHAR:String = "pirate 3";
		public static const VIP1_CHAR:String = "vip 1";
		public static const ISLAMIC_CHAR:String = "islamic";
		public static const WAITERCHEAP_CHAR:String = "waiter cheap";
		public static const CHEF_CHAR:String = "chef";
		public static const WAITEREXPENSIVE_CHAR = "waiter expensive";
		public static const NINJA_CHAR:String = "ninja";
		public static const DIVA_CHAR:String = "diva";
		public static const FOODCRITIC_CHAR:String = "critic";
		public static const BIGBOSS_CHAR:String = "big boss";
		public static const MASTERCHEFVIP_CHAR:String = "master chef vip";
		public static const CAPTAINCOOK_CHAR:String = "captain cook";
		
		public static const CHAR_ARRAY:Array = [VIP1_CHAR, THODAN_CHAR, PIRATE1_CHAR, PIRATE2_CHAR, PIRATE3_CHAR, ISLAMIC_CHAR, WAITERCHEAP_CHAR, CHEF_CHAR, THODAN_CHAR];
		
		public static const TIMER_TRIGGERED:String = "triggered";
		public static const TIMER_STOPPED:String = "stopped";
		
		public static const UP:int = 0;
		public static const DOWN:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = 3;
		
		protected var orientation;
		protected var direction;
		
		protected var charFace:MovieClip;
		protected var movingTween:TweenMax;
		protected const velocity:int = 300;
		
		public var i:int;
		
		private var alreadyDispatch = false;
		private var alreadyDispatchMoving = false;
		
		private var flipLeft = true;
		
		private var timeLimit = 10;
		private var time:int;
		private var timer:Timer = new Timer(1000);
		public var vip:Boolean = false;
		
		private var emoBubble;
		
		public function GameCharacter (character:String = GameCharacter.THODAN_CHAR, x:int = 0, y:int = 0, vip:Boolean = false, charType:String = GameCharacter.BJ_TYPE):void
		{
			setChar(character, charType);
			setLocation(x, y);
			this.vip = vip;
			this.orientation = RIGHT;
			this.direction = DOWN;
eventController(			this, Event.ENTER_FRAME,  checkProgress);
		}
		
		private function setChar(character:String, charType:String):void
		{
			if (character === GameCharacter.PIRATE1_CHAR)
			{
				charFace = new Pirate1Char();
			}
			else if (character === GameCharacter.THODAN_CHAR)
			{
				charFace = new ThodanChar();
			}
			else if (character === ISLAMIC_CHAR)
			{
				charFace = new Islamic();
			}
			else if (character === WAITERCHEAP_CHAR)
			{
				charFace = new WaiterCheap();
				charFace.frame.visible = false;
			}
			else if (character === CHEF_CHAR)
			{
				charFace = new ChefChar();
				charFace.frame.visible = false;
			}
			else if (character === WAITEREXPENSIVE_CHAR)
			{
				charFace = new WaiterExpensive();
				charFace.frame.visible = false;
			}
			else if (character === PIRATE2_CHAR)
			{
				charFace = new Pirate2Char();
			}
			else if (character === PIRATE3_CHAR)
			{
				charFace = new Pirate3Char();
			}
			else if (character === NINJA_CHAR)
			{
				charFace = new NinjaChar();
			}
			else if (character === VIP1_CHAR)
			{
				charFace = new FakeVIPChar();
			}
			else if (character === FOODCRITIC_CHAR)
			{
				charFace = new Critic_VIP();
			}
			else if (character === BIGBOSS_CHAR)
			{
				charFace = new BigBoss_VIP();
			}
			else if (character === DIVA_CHAR)
			{
				charFace = new Diva_VIP();
			}
			else if (character === MASTERCHEFVIP_CHAR)
			{
				charFace = new MasterChef_VIP();
			}
			else if (character === CAPTAINCOOK_CHAR)
			{
				charFace = new CaptainCook_Char();
			}
			charFace.gotoAndStop("original");
			
			this.addChild (charFace);
		}
		
		private function setLocation(x: int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function moveChar(startX:int, startY:int, endX:int, endY:int, v:int = velocity, oC:Object=null, oCParams:Array = null, onUpdate:Object = null):void
		{
			var distance;
			var xDiff = endX - startX;
			var yDiff = endY - startY;
			charFace.play();
			distance = Math.sqrt(xDiff*xDiff + yDiff*yDiff);
			
			if (startX > endX && this.orientation == GameCharacter.RIGHT)
			{
				flipChar();
			}
			if (startX < endX && this.orientation == GameCharacter.LEFT)
			{
				flipChar();
			}
			if (startY - endY > 5 && this.direction === DOWN)
			{
				reverseChar();
			}
			if (startY - endY < 5 && this.direction === UP)
			{
				reverseChar();
			}
			
			if (oC === null)
			{
				movingTween = TweenMax.to(this, distance/v, {
					x:endX, 
					y:endY, 
					onComplete:doneMoving, 
					onUpdate: onUpdate,
					ease:Linear.easeNone
				});
			}
			else
			{
				movingTween = TweenMax.to(this, distance/v, {
					x:endX, 
					y:endY, 
					onUpdate: onUpdate,
					onComplete:oC, 
					onCompleteParams:oCParams, 
					ease:Linear.easeNone
				});
			}
		}
		
		public function stopMoving():void
		{
			charFace.gotoAndStop("original");
			TweenMax.killTweensOf(this);
		}
		
		protected function startMoving():void
		{
			charFace.gotoAndPlay("original");
		}
		
		protected function doneMoving():void
		{
			charFace.gotoAndStop("original");
		}
		
		public function flipChar():void
		{
			if (flipLeft)
			{
				charFace.scaleX = -1;
				charFace.x += charFace.width;
				flipLeft = !flipLeft;
				this.orientation = LEFT;
			}
			else
			{
				charFace.scaleX = 1;				
				charFace.x -= charFace.width;
				flipLeft = !flipLeft;
				this.orientation = RIGHT;				
			}
		}
		
		protected function reverseChar():void
		{
			if (this.direction === UP)
			{
				charFace.gotoAndPlay("original");
				this.direction = DOWN;
			}
			else if (this.direction === DOWN)
			{
				charFace.gotoAndPlay("reverse");
				this.direction = UP;
			}
		}
				
		private function checkProgress(evt:Event):void
		{
			if (movingTween != null)
			{
				//trace (movingTween.currentProgress);
				if (movingTween.currentProgress > 0.4 && !alreadyDispatch)
				{
					this.dispatchEvent(new Event("should add now"));
					alreadyDispatch = true;
				}
				
				if (movingTween.currentProgress > 0.4 && !alreadyDispatchMoving)
				{
					this.dispatchEvent(new Event("done moving"));
					alreadyDispatchMoving = true;
				}
			}
		}
		
		public function resetAlready():void
		{
			if (alreadyDispatchMoving)
			{
				alreadyDispatchMoving = false;
			}
		}
		
		public function triggerVIP():void
		{
			setUpTimer();
			setUpBubble();
		}
		
		private function setUpBubble():void
		{
			emoBubble = new EmotionCharacter();
			emoBubble.x = this.width/2 - 10;
			emoBubble.y = -emoBubble.height - 35;
			this.addChild(emoBubble);
		}
		
		private function setUpTimer():void
		{
			time = timeLimit;
eventController(			timer, TimerEvent.TIMER,  updateTimer);
			timer.start();
			timer.dispatchEvent(new Event(TIMER_TRIGGERED));
		}
		
		private function updateTimer(evt:Event):void
		{			
			if (time < 0.2 * timeLimit)
			{
				emoBubble.gotoAndStop("starve");
			}
			else if (time < 0.4 * timeLimit)
			{
				emoBubble.gotoAndStop("midfin");
			}
			else if (time < 0.6 * timeLimit)
			{
				emoBubble.gotoAndStop("angry");
			}
			else if(time < 0.8 * timeLimit)
			{
				emoBubble.gotoAndStop("kiss");
			}
			
			
			if (time>0)
			{
				time--;
			}
			else
			{
				timer.stop();
				dispatchEvent(new Event(TIMER_STOPPED));
			}
		}
		
		public function deactivateTimer():void
		{
			timer.stop();
		}
		
		public function activateTimer():void
		{
			timer.start();
		}
		
		public function performMagic():void
		{
			charFace.gotoAndPlay("magic");
		}
		public function eventController(object:Object, eventType:String, func:Function) {
			eventArray.push([object, eventType, func]);
			object.addEventListener.call(object, eventType, func, false, 0, true);
		}

		public function destroy():void {
			stopMoving();
			for each (var tmp:* in eventArray) {
				tmp[0].removeEventListener(tmp[1], tmp[2]);
			}
			eventArray = null;
		}
	}
}