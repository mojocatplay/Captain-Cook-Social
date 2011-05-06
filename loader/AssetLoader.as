package loader
{
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	import util.*;

	public class AssetLoader extends EventDispatcher
	{
		public static const STORYLINE_ASSET:int = 1;
		public static const RESTAURANT_ASSET:int = 2;
		public static const COOKING_ASSET:int = 3;
		public static const GAMEUTILS_ASSET:int = 4;
		
		public static const NORMAL_BOARD = 101;
		public static const CROSS_BOARD = 102;
		public static const NORMALVSCOMP_BOARD = 103;
		public static const NORMALTUTORIAL_BOARD = 104;
		
		private var assetLoader:Loader;
		private var request:URLRequest;
		private var assetsURL:String;
		private var _asset:MovieClip;
		private var _type:int;
		
		public function AssetLoader(indexInstance:index, requestURL:String, type:int)
		{
			this.assetsURL = requestURL;
			this._type = type;
			
			request = new URLRequest(requestURL);
			assetLoader = new Loader();
			assetLoader.load(request);
			assetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onComplete(evt:Event):void
		{
			_asset = evt.currentTarget.content as MovieClip;
			this.dispatchEvent(new Event("complete"));
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get asset():MovieClip
		{
			return _asset;
		}
	}
}