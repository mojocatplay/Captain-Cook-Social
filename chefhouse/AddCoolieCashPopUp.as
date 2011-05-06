package chefhouse
{
	import flash.utils.*;
	import flash.display.*;
	import flash.events.*;
	import loader.*;	
	import restaurant.*;
	import flash.external.ExternalInterface;
	
	import util.*;
		
	public class AddCoolieCashPopUp extends MovieClip
	{
		private var display;
		private var options;
		private var AddCoolieCash_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("AddCoolieCash_PopUp"));
		private var timer:Timer;
		
		public function AddCoolieCashPopUp():void
		{
			display = new AddCoolieCash_PopUp();
			options = [display.paymentOption1, display.paymentOption2, display.paymentOption3, display.paymentOption4];
			
			setUpOptionButtons();
			display.closeButt.addEventListener(MouseEvent.CLICK, closeThis);
			this.addChild(display);
		}
		
		private function setUpOptionButtons():void
		{
			var length = options.length;
			
			options[0].optionText.text = "260 for 25USD";
			options[1].optionText.text = "120 for 12USD";
			options[2].optionText.text = "55 for 6USD";
			options[3].optionText.text = "25 for 3USD";
			
			options[0].addEventListener(MouseEvent.CLICK, addCash1);
			options[1].addEventListener(MouseEvent.CLICK, addCash2);
			options[2].addEventListener(MouseEvent.CLICK, addCash3);
			options[3].addEventListener(MouseEvent.CLICK, addCash4);
		}
		
		private function addCash1(evt:MouseEvent):void {
			//a
			addCashGeneral(260);
		}
		private function addCash2(evt:MouseEvent):void {
			//a
			addCashGeneral(120);
		}
		private function addCash3(evt:MouseEvent):void {
			//a
			addCashGeneral(55);
		}
		private function addCash4(evt:MouseEvent):void {
			//a
			addCashGeneral(25);
		}

		private function addCashGeneral(amount:int):void {
			checkForCash();
			var link:String;
			var userId = GlobalVarContainer.getUser().getId();

			link = GlobalVarContainer.HOSTURL + 'cc/users/buy_cash/'+userId+'/'+amount;
			if (ExternalInterface.available) { 
				try {
					ExternalInterface.call("window.open", link, "_blank", "height=600,width=1024,toolbar=no,scrollbars=yes"); 
				}
				catch (errObject:Error){
					trace(errObject.message);
				}

			} 
		}
		
		private function checkForCash():void {
			trace('face');
			timer = new Timer(10000);
			timer.addEventListener(TimerEvent.TIMER, doCheckForCash, false, 0, true);
			timer.start();
			
			//keep requesting every 10 sec for cash info
		}
		
		private function doCheckForCash(evt:Event = null) {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'checkForCash';
			var onResult:Function = checkForCashSuccess;
			var onFault:Function = checkForCashFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		
		private function checkForCashSuccess(object:*) {
			var numb:int = int (object);
			if (numb != -1) {
				trace(numb);
				timer.stop();
				GlobalVarContainer.indexInstant.getCoolieCashBar().addMoney(numb);
				//do update
				//stop timer
			}
			//update cash value
			trace('checkForCashSuccess');
		}
		
		private function checkForCashFail(object:*) {
			trace('checkForCashSuccess');
		}
		
		private function closeThis(evt:Event):void
		{
			RestaurantScene(this.parent).removePopUpWithOverlay(this);
		}
	}
}