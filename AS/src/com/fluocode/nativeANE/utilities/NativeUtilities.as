/** 
 * @author Mateusz Maćkowiak
 * @see http://fluocode.com/
 * @since 2011
 */
package com.fluocode.nativeANE.utilities
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import flash.system.Capabilities;
	
	import com.fluocode.nativeANE.utilities.support.AbstractNativeUtilities;
	import com.fluocode.nativeANE.events.NativeDialogEvent;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;

	/**
	 * Simple NativeAlert extension that allows you to
	 * Open device specific alerts and recieve information about
	 * what button the user pressed to close the alert.
	 * 
	 * @author Mateusz Maćkowiak
	 * @see http://fluocode.com/
	 * @since 2011
	 * 
	 */
	public class NativeUtilities extends AbstractNativeUtilities
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		/**
		 * The id of the extension that has to be added in the descriptor file.
		 */
		public static const EXTENSION_ID : String = "com.fluocode.nativeANE.NativeDialogs";
		
		/**
		 * The current Version of the Extension.
		 */
		public static const VERSION:String = "0.9.5 Beta";
		
		/**
		 * The current Version of the Extension.
		 */
		public static const CUTOUTMODE_DEFAULT:int = 0;
		public static const CUTOUTMODE_SHORT_EDGES:int = 1;
		public static const CUTOUTMODE_NEVER:int = 2;
				
		//---------------------------------------------------------------------
		//
		// Private Static Properties.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		//private static var _defaultTheme:uint = DEFAULT_THEME;
		//---------------------------------------------------------------------
		//
		// private properties.
		//
		//---------------------------------------------------------------------
		/**@private*/
		private var _closeLabel:String = null;
		/**@private*/
		private var _buttons:Vector.<String> = null;
		/**@private*/
		private var _theme:int = -1;
		/**@private*/
		private var _closeHandler:Function=null;
		/**@private*/
		private var _disposeAfterClose:Boolean = false;

		
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * 
		 * @param theme the selected theme for the NativeUtilities.
		 * 
		 * @since 2011
		 * 
		 * @see com.fluocode.nativeANE.events.NativeDialogEvent
		 * @see http://fluocode.com/
		 * 
		 * 
		 * @event com.fluocode.nativeANE.events.NativeDialogEvent.OPENED
		 * com.fluocode.nativeANE.events.NativeDialogEvent.CLOSEED
		 */
		public function NativeUtilities(theme:int=-1)
		{
			super(abstractKey);

			init();
		}
		
		
		
		/**@private*/
		override protected function init():void{
			try{
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, "NativeUtilitiesContext");
				//_context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the NativeUtilities extension: "+e.message,e.errorID);
			}
		}
		
		public static var ctx:ExtensionContext;
		
		/**@private*/
		public static function get context():ExtensionContext{
			try{
				if(!ctx)
					ctx = ExtensionContext.createExtensionContext(EXTENSION_ID, "NativeUtilitiesContext");
				
			}catch(e:Error){
				showError("Error initiating contex of the NativeUtilities extension: "+e.message,e.errorID);
			}
			return ctx;
		}
		
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function showError(message:*,id:int=0):void{
			showError(message,id);
		}
		
		
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		//public static function getStatusBarHeight(stage:Stage=null):Number
		public static function getStatusBarHeight():Number
		{
			var barHeight:Number =-1;
			try
			{
				if(isIOS() || isAndroid()){
					barHeight = context.call("getStatusBarHeight") as Number;
					/*
					if(stage){
						var relY:Number = stage.stageHeight/Capabilities.screenResolutionY;
						barHeight = barHeight *relY;
						if(isIOS())
							barHeight = barHeight/2;
					}
					*/
					if(isIOS())
					barHeight = barHeight*2;
				}
			} 
			catch(error:Error) 
			{
				showError("'getStatusBarHeight' "+error.message,error.errorID);
			}
			return barHeight;
		}
		
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function isDarkMode():Boolean
		{
			var dark:Boolean;
			try
			{
				if(isIOS() || isAndroid())
					dark = context.call("isDarkMode") as Boolean;
			} 
			catch(error:Error) 
			{
				showError("'isDarkMode' "+error.message,error.errorID);
			}
			return dark;
		}
		
		
		
		
		/**@private*/
		/**
		 * Block Screenshot
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function blockScreenshot(block:Boolean):void
		{
			trace('blockScreenshot is android', isAndroid());
			trace('blockScreenshot is iOS', isIOS());
			if( !isAndroid()  ) return;
			try
			{
				//if(isIOS() || isAndroid())
				if(isAndroid())
					context.call("blockScreenshoty", block);
			} 
			catch(error:Error) 
			{
				showError("'blockScreenshot' "+error.message,error.errorID);
			}
		}
		
		
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function statusBarStyleLight(light:Boolean):void
		{
			try
			{
				if(isIOS() || isAndroid())
					context.call("statusBarStyleLight", light);
			} 
			catch(error:Error) 
			{
				showError("'statusBarStyleLight' "+error.message,error.errorID);
			}
		}
		
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function statusBarColor(color:uint):void
		{
			if( !isAndroid()  ) return;
			var strColor:String =  "#" + color.toString(16);
			try
			{
				if(isAndroid())
					context.call("statusBarColor", strColor);
			} 
			catch(error:Error) 
			{
				showError("'statusBarColor' "+error.message,error.errorID);
			}
		}
		
		/**@private*/
		/**
		 * Fullscreen mode
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function fullscreen(mode:Boolean):void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("fullscreenMode", mode);
			} 
			catch(error:Error) 
			{
				showError("'fullscreenMode' "+error.message,error.errorID);
			}
		}
		
		
		/**@private*/
		/**
		 * Change the navigation bar color.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function navigationBarColor(color:uint):void
		{
			if( !isAndroid()  ) return;
			var strColor:String =  "#" + color.toString(16);
			try
			{
				if(isAndroid())
					context.call("navigationBarColor", strColor);
			} 
			catch(error:Error) 
			{
				showError("'navigationBarColor' "+error.message,error.errorID);
			}
		}
		
		/**@private*/
		/**
		 * Change the status bar color to trasparent.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function statusBarTransparent():void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("statusBarTransparent");
			} 
			catch(error:Error) 
			{
				showError("'statusBarTransparent' "+error.message,error.errorID);
			}
		}
		
		/**@private*/
		/**
		 * Change the navigation bar color to trasparent.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function navigationBarTransparent():void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("navigationBarTransparent");
			} 
			catch(error:Error) 
			{
				showError("'navigationBarTransparent' "+error.message,error.errorID);
			}
		}
		
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function navigationBarStyleLight(light:Boolean):void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("navigationBarStyleLight", light);
			} 
			catch(error:Error) 
			{
				showError("'navigationBarStyleLight' "+error.message,error.errorID);
			}
		}
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function hideNavigation(light:Boolean):void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("hideNavigation", light);
			} 
			catch(error:Error) 
			{
				showError("'hideNavigation' "+error.message,error.errorID);
			}
		}
		
		
	
		
		//////////////////////////////////////////////////////////////////
		
		 /**
         * Sets UI visibility flags.
         * @param flags Values from the <code>AndroidUIFlags</code> class.
         * @see com.marpies.ane.androidutils.data.AndroidUIFlags
         */
        public static function setUIVisibility( flags:int ):void {
            if( !isAndroid()  ) return;

            context.call( "setUIVisibility", flags );
        }
		
		
		/**
         * Hides the status bar. This changes flags on the entire application's window and not the main view.
         * This means that when another native view appears (for example, a dialog), the status bar will stay hidden.
         * If the status bar was hidden using <code>setUIVisibility</code> then it would show up when the dialog appears.
         */
        public static function hideWindowStatusBar():void {
            if( !isAndroid()  ) return;

            context.call( "hideWindowStatusBar" );
        }

        /**
         * Makes the navigation bar translucent. Supported on Android Kitkat (API 19) and above.
         */
        public static function setTranslucentNavigation():void {
            if( !isAndroid()  ) return;

            context.call( "setTranslucentNavigation" );
        }
		
		
		
		
		 /**
         * Set brightness for application's window.
         * @param value Decimal between 0-1, or -1 to use user's preference.
         */
        public static function setBrightness( value:Number ):void {
            if( !isAndroid()  ) return;

            context.call( "setBrightness", value );
        }
		
		
		
		/**
		 * Sets the cutout mode. Use <code>CutoutMode.SHORT_EDGES</code> to render app within device's cutout area.
		 * @param mode
		 */
		public static function setCutoutMode( mode:int ):void {
			if( !isAndroid()  ) return;

			context.call( "setCutoutMode", mode );
		}

        /**
         * Enables or disables system UI visibility listener.
         * Add event listener for <code>AndroidUIVisibilityEvent.CHANGE</code> to be notified
         * when the system UI flags change.
         *
         * @param enable Set to <code>true</code> to enable the listener, <code>false</code> to remove it.
         */
        public static function enableUIVisibilityListener( enable:Boolean ):void {
            if( !isAndroid()  ) return;

            context.call( "UIVisibilityListener", enable );
        }
		
		
		public static function get supportedUIFlags():Vector.<int> {
            if( !isAndroid()  ) return new <int>[];

            return context.call( "getSupportedUIFlags") as Vector.<int>;
        }
		
		
		  public static function get displayCutoutRects():Vector.<Rectangle> {
            if( !isAndroid()   ) return null;

            return context.call( "getDisplayCutoutRects") as Vector.<Rectangle>;
        }
		
		
		
		//////////////////////////////////////////////////////////////////
		

		
		/**
		 * Whether the extension is available on the device (<code>true</code>);<br>otherwise <code>false</code>.
		 */
		public static function get isSupported():Boolean{
			if(isIOS()|| isAndroid())
				return true;
			else 
				return false;
		}
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onStatus( event : StatusEvent ) : void
		{
			event.stopImmediatePropagation();
			if(event.code==NativeDialogEvent.OPENED){
				_isShowing = true;
				if(hasEventListener(NativeDialogEvent.OPENED))
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				
			}
			else if( event.code == NativeDialogEvent.CLOSED || event.code =="ALERT_CLOSED")
			{
				_isShowing = false;
				
				var level:int = int(event.level);
				if(isWindows())
					level--;
				var wasPrevented:Boolean = true;
				if(hasEventListener(NativeDialogEvent.CLOSED)){
					wasPrevented = dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,String(level)));
					if(wasPrevented && _closeHandler!=null){
						removeEventListener(NativeDialogEvent.CLOSED,_closeHandler);
						_closeHandler = null;
					}
				}
				
				if(_disposeAfterClose && wasPrevented){
					dispose();
				}
				
			}else{
				showError(event);
			}
		}
		
		
		
		
		
		
		
		
		
		
	}
}