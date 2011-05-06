package chefhouse
{
	import flash.utils.*;
	import flash.display.*;
	import flash.events.*;
	import loader.*;	
	import restaurant.*;
	import flash.external.ExternalInterface;
	
	import util.*;
	
		
	public class AddCoinsPopUp extends MovieClip
	{
		private var timer:Timer;
		private var display;
		private var options;
		private var AddCoins_PopUp:Class = Class(index.utilsAsset.loaderInfo.applicationDomain.getDefinition("AddCoins_PopUp"));
		
		public function AddCoinsPopUp():void
		{
			display = new AddCoins_PopUp();
			options = [display.paymentOption1, display.paymentOption2, display.paymentOption3, display.paymentOption4];
			
			setUpOptionButtons();
			display.closeButt.addEventListener(MouseEvent.CLICK, closeThis);
			this.addChild(display);
		}
		
		private function setUpOptionButtons():void
		{
			var length = options.length;
			
			options[0].optionText.text = "260000 for 25USD";
			options[1].optionText.text = "120000 for 12USD";
			options[2].optionText.text = "55000 for 6USD";
			options[3].optionText.text = "25000 for 3USD";
			
			options[0].addEventListener(MouseEvent.CLICK, addCoin1);
			options[1].addEventListener(MouseEvent.CLICK, addCoin2);
			options[2].addEventListener(MouseEvent.CLICK, addCoin3);
			options[3].addEventListener(MouseEvent.CLICK, addCoin4);
		}
		
		private function addCoin1(evt:MouseEvent):void {
			//a
			addCoinGeneral(260000);
		}
		private function addCoin2(evt:MouseEvent):void {
			//a
			addCoinGeneral(120000);
		}
		private function addCoin3(evt:MouseEvent):void {
			//a
			addCoinGeneral(55000);
		}
		private function addCoin4(evt:MouseEvent):void {
			//a
			addCoinGeneral(25000);
		}
		
		private function addCoinGeneral(amount:int):void {
			checkForCoin();
			var link:String;
			var userId = GlobalVarContainer.getUser().getId();
			
			link = GlobalVarContainer.HOSTURL +'cc/users/buy_coin/'+userId+'/'+amount;
			if (ExternalInterface.available) { 
				try {
					ExternalInterface.call("window.open", link, "_blank", "height=600,width=1024,toolbar=no,scrollbars=yes"); 
				}
				catch (errObject:Error){
					trace(errObject.message);
				}
			} 
		}

		private function checkForCoin():void {
			trace('face');
			timer = new Timer(10000);
			timer.addEventListener(TimerEvent.TIMER, doCheckForCoin, false, 0, true);
			timer.start();

			//keep requesting every 10 sec for coin info
		}

		private function doCheckForCoin(evt:Event = null) {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'checkForCoin';
			var onResult:Function = checkForCoinSuccess;
			var onFault:Function = checkForCoinFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}


		private function checkForCoinSuccess(object:*) {
			var numb:int = int (object);
			if (numb != -1) {
				trace(numb);
				timer.stop();
				GlobalVarContainer.getUser().setMoney(GlobalVarContainer.getUser().getMoney() + numb);
				GlobalVarContainer.indexInstant.getMoneyBar().addMoney(numb);
				//do update
				//stop timer
			}
			//update coin value
			trace('checkForCoinSuccess');
		}

		private function checkForCoinFail(object:*) {
			trace('checkForCoinSuccess');
		}
		
		private function closeThis(evt:Event):void
		{
			RestaurantScene(this.parent).removePopUpWithOverlay(this);
		}
	}
}