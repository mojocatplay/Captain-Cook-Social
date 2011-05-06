package baseobject
{
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	
	public dynamic class BaseObject extends MovieClip
	{
		public var container = new MovieClip();
		private var imageURL:URLRequest;
		public var loader:Loader = new Loader();
		
		// janus new defined
		public var img:Bitmap = new Bitmap();
		
		public var sequence:int = 0;
		public var objectname:String = '';
		public var objectid:int = 0;
		public var objecttype:int = 1; // 1 is ingredient, 0 is condiment
		public var objecturl:String = '';
		public var objectBitmap:Bitmap;
		
		public var objectclass:String = '';
		
		public var blackOverlay_ref;
		
		protected var gui:GUI;
		
		// global constants
		
		//public const BASE_URL = "http://bathanh.comp.nus.edu.sg";
		public const BASE_URL = "http://d91442b6.fb.joyent.us";
    	public const BASE_PATH = "captain";
		
		public const ingrebaseName:String = BASE_URL+"/"+BASE_PATH+"/images/ingredient/";
		public const condimentbaseName:String = BASE_URL+"/"+BASE_PATH+"/images/ingredient/";		
		public const utenbaseName:String = BASE_URL+"/"+BASE_PATH+"/images/utensil/";
		
		public const OVERLAY_ALPHA = 0.75;
		public const INGREDIENT_TYPE = 1;
		public const CONDIMENT_TYPE = 0;
		
		public const CANVAS_WIDTH = 760;
		public const CANVAS_HEIGHT = 620;
		
		private var stringURL:*;
		
		public function BaseObject(stringURL:*=undefined, posX:int=0, posY:int=0, scalX:Number = 0, scalY:Number = 0) 
		{
			gui = new GUI();
			var dataType:String = typeof(stringURL);
			////trace(dataType);
			if (stringURL != undefined)
			{
				if (dataType == "string")
				{	
					if(stringURL != '')
						setImage(stringURL);
				}
				else if (dataType == "object")
				{
					//objectBitmap = stringURL;
					//img = stringURL;
					//img = stringURL;
					////trace(stringURL);
					this.stringURL = stringURL;
					stringURL.x = posX;
					stringURL.y = posY;
					container.addChild(stringURL);
				}
				
			}
			
			//setLocation(posX, posY);
			
			if (scalX && scalY)
				setSize(scalX,scalY);
				
			//addChild(container);
			////trace("yes baby");
			////trace(container.width);
			
		}

		//janus newly declared
		protected function addLibImage(imgObject:*):void
		{

		}
		
		//janus newly declared
		public function reloadBitmapObject(imgObject:* = undefined):void
		{	
			//if first load, this will be bypassed since child has not been added
			//already loaded and added  as child before, remove it
			if ( container.numChildren != 0 )
			{
				container.removeChildAt(0);
			}
			
			if ( imgObject != undefined)
			{
				container.addChild(imgObject);
			}
			
		}
		
		public function setIconAlpha(da:int):void
		{
			stringURL.alpha = 0;
		}
		
		protected function setImage(url:*):void
		{
			var dataType:String = typeof(url);
			if (dataType == "string")
			{
				var imageURL:URLRequest = new URLRequest(url);
				var loader:Loader = new Loader();
			
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					if (container.numChildren != 0)
					{
						container.removeChildAt(0);
					}
					container.addChild(loader);
				});
				loader.load(imageURL);
			}
			if (dataType == "object")
			{
	
			}
		}
		
		function imageLoaded(event:Event):void
		{
			this.addChild(loader);
			
			//trace('content width is ' + event.target.content.width);
			this.width = event.target.content.width;
			this.height =event.target.content.height;
			//trace("my wid is " + this.width);
			//this.addChild(event.target.content);
			//imageLoader.x = 100;
			//imageLoader.y = 100;

			//loader.width = 200;
			//loader.height = 200;
		}
		
		protected function onImgComplete(evt:Event):void
		{
			var img:Bitmap = new Bitmap(evt.target.content);
			addChild(img);
		}
		
		public function setLocation(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function setSize(scalX:Number, scalY:Number):void
		{
			container.scaleX = scalX;
			container.scaleY = scalY;
			////trace('width' + container.numChildren);
			////trace("scale" + scalX + scalY);
		}
		
		protected function setDepth(depth:int):void
		{
			
		}
		
		public function addContainer():void
		{
			addChild(container);
		}
		
		// loading the dark background overlay
		public function loadBlackOverlay(alphavalue:Number):void
		{
			var blackBG:MovieClip = new MovieClip();
			blackBG.x = 0;
			blackBG.y = 0;
			blackBG.graphics.beginFill(0x000000);
			
			// mask width is set at 420
			blackBG.graphics.drawRect(0,0,800,800);
			blackBG.graphics.endFill();
			blackBG.alpha = alphavalue;
			
			this.addChild(blackBG);
			
			blackOverlay_ref = blackBG;
		}
		
				// loading the dark background overlay
		public function removeBlackOverlay():void
		{
			if (this.contains(blackOverlay_ref))
			{
				this.removeChild(blackOverlay_ref);
			}
		}
		
		public function getObjectID():int
		{
			return objectid;
		}
		
		public function getObjectName():String
		{
			return objectname;
		}
		
		public function getObjectURL():String
		{
			return objecturl;
		}
		
		public function getObjectType():String
		{
			return objectclass;
		}
	}
}