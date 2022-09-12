/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.utilities
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import pl.mateuszmackowiak.nativeANE.utilities.support.AbstractNativeUtilities;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;

	/**
	 * Simple NativeAlert extension that allows you to
	 * Open device specific alerts and recieve information about
	 * what button the user pressed to close the alert.
	 * 
	 * @author Mateusz Maćkowiak
	 * @see http://mateuszmackowiak.wordpress.com/
	 * @since 2011
	 * 
	 */
	//public class NativeUtilities extends AbstractNativeUtilities
	public class NativeUtilities
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		/**
		 * The id of the extension that has to be added in the descriptor file.
		 */
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeDialogs";
		
		/**
		 * The current Version of the Extension.
		 */
		public static const VERSION:String = "0.9.5 Beta";
				
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
		 * @see pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent
		 * @see http://mateuszmackowiak.wordpress.com/
		 * 
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.OPENED
		 * pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.CLOSEED
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
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function getStatusBarHeight():Number
		{
			var barHeight:Number =-1;
			try
			{
				if(isIOS() || isAndroid())
					barHeight = _context.call("getStatusBarHeight") as Number;
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
		public function isDarkMode():Boolean
		{
			var dark:Boolean;
			//try
			//{
				if(isIOS() || isAndroid())
					dark = _context.call("isDarkMode") as Boolean;
			//} 
			//catch(error:Error) 
			//{
			//	showError("'isDarkMode' "+error.message,error.errorID);
			//}
			return dark;
		}
		
		
		
		
		/**@private*/
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function statusBarStyleLight(light:Boolean):void
		{
			try
			{
				if(isIOS() || isAndroid())
					_context.call("statusBarStyleLight", light);
			} 
			catch(error:Error) 
			{
				showError("'statusBarStyleLight' "+error.message,error.errorID);
			}
		}
		
		

		
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