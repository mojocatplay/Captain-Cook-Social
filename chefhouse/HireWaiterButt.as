package chefhouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class HireWaiterButt extends Sprite
	{
		private var HireWaiter_Button:Class = Class(index.restaurantAsset.loaderInfo.applicationDomain.getDefinition("HireWaiter_Button"));
		
		private var display;
		private var countDownTime:int;
		private var countDownTimer;
		private var maxTime:int;
		public var countingDown:Boolean = false;
		public function HireWaiterButt(time:Number = -1, maxTime:Number = -1):void
		{
			display = new HireWaiter_Button();
			display.timeText.visible = false;
			//display.waiterBar.visible = false;
			this.addChild(display);
			
			countDownTimer = new Timer(1000);
			countDownTimer.addEventListener(TimerEvent.TIMER, deductTimer);
			
			if (time > 0)
			{
				//display.gotoAndStop(2);
				this.maxTime = maxTime;
				this.countDownTime = time;
				display.timeText.visible = true;
				//display.waiterBar.visible = true;
				
				display.timeText.text = convertTime(time);
				//display.waiterBar.scaleX = time/maxTime;
				countDownTimer.start();
				countingDown = true;
			}			
		}
		
		public function startCountDown(time:Number, maxTime:Number):void
		{
			//display.gotoAndStop(2);
			display.timeText.visible = true;
			//display.waiterBar.visible = true;
			
			this.maxTime = maxTime*3600;
			countDownTime = time*3600;
			//trace(countDownTime);
			
			display.timeText.text = convertTime(countDownTime);
			countingDown = true;
			
			countDownTimer.start();
		}
		
		private function convertTime(time):String
		{
			var hour = int(time/3600);
			var minute = int((time/60)%60);
			var second = int(time%60);
			var hourString, minString, secString;
			
			if (hour < 10)
			{
				hourString = "0" + hour.toString();
			}
			else
			{
				hourString = hour.toString();
			}
			
			if (minute < 10)
			{
				minString = "0" + minute.toString();
			}
			else
			{
				minString = minute.toString();
			}
			
			if (second < 10)
			{
				secString = "0" + second.toString();
			}
			else
			{
				secString = second.toString();
			}
			
			return hourString + ":" + minString + ":" + secString + " left";
		}
		
		private function deductTimer(evt:TimerEvent):void
		{
			countDownTime--;
			display.timeText.text = convertTime(countDownTime);
			//display.waiterBar.scaleX = countDownTime/maxTime;
			
			if (countDownTime === 0)
			{
				dispatchEvent(new Event("endTimer"));
				countDownTimer.stop();
				//display.gotoAndStop(1);
				display.timeText.visible = false;
				//display.waiterBar.visible = false;
				countingDown = false;
			}
			else
			{
				
			}
		}
		
		public function getTimeRemaining():Number
		{
			return countDownTime;
		}
	}
}