package loader{
	import flash.net.*;
	import flash.events.*;
	import util.*;
	public class HttpLoader {
		
		private static var valid:Boolean = true;
		
		/*public static var gatewayAddress:String = GlobalVarContainer.HOSTURL + 'cc/cpamf/gateway';*/
		public static var gatewayAddress:String = GlobalVarContainer.HOSTURL + 'cpamf/gateway';
/*		public static const GATEWAY = 'http://localhost/cc/cpamf/gateway';*/
/*		public static const GATEWAY = 'http://aagpwv8h.facebook.joyent.us/cc/cpamf/gateway';*/
		public static function load(remoteClass:String, remoteMethod:String, onResult:Function, onFault:Function, params:Array = null):void {
			trace(remoteClass+'.'+remoteMethod);
			//perfect place to put in facebook info
			if (valid) {
				var data:Object = new Object();
				data.facebookVars = GlobalVarContainer.browserVars;
				data.facebookVars.session = GlobalVarContainer.getUser().getSession();
				var gateway:NetConnection = new NetConnection();
				var res:Responder = new Responder(onResult, onFault);
				var tmpArray:Array = [remoteClass + '.' + remoteMethod, res];
				tmpArray.push(data);
				if (params != null) {
					var size = params.length;
					for (var i:int = 0; i < size; ++i) {
						tmpArray.push(params[i]);
					}
				}			
				gateway.connect(gatewayAddress);
				gateway.call.apply(null, tmpArray);
			}			
		}
		
		public static function stop() {
			valid = false;
		}
	}
}