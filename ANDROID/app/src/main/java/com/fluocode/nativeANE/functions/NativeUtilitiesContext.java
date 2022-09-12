package com.fluocode.nativeANE.functions;

import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;


import com.adobe.fre.FREArray;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.fluocode.nativeANE.FREUtilities;
import com.fluocode.nativeANE.NativeDialogsExtension;
import android.annotation.SuppressLint;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Build;
import android.util.Log;
import android.view.DisplayCutout;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
 * @author Mateusz Mackowiak
 */
public class NativeUtilitiesContext  extends FREContext {


	public static final String KEY = "NativeUtilitiesContext";



	@Override
	public void dispose()
	{
		Log.d(KEY, "Disposing Extension Context");

		//if(this!=null){
		//	this.dismiss();
		//	this = null;		}
	}

	/**
	 * Registers AS function name to Java Function Class
	 */
	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Log.d(KEY, "Registering Extension Functions");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put(getStatusBarHeight.KEY, new getStatusBarHeight());
		functionMap.put(isDarkMode.KEY, new isDarkMode());
		functionMap.put(statusBarStyleLight.KEY, new statusBarStyleLight());
		functionMap.put(statusBarColor.KEY, new statusBarColor());
		functionMap.put(navigationBarStyleLight.KEY, new navigationBarStyleLight());
		////
		functionMap.put( GetSupportedUIFlags.KEY, new GetSupportedUIFlags() );
		functionMap.put( SetUIVisibility.KEY, new SetUIVisibility() );
		functionMap.put( UIVisibilityListener.KEY, new UIVisibilityListener() );
		functionMap.put( SetCutoutMode.KEY, new SetCutoutMode() );
		functionMap.put( GetDisplayCutoutRects.KEY, new GetDisplayCutoutRects() );
		functionMap.put(SetBrightness.KEY, new SetBrightness() );
		functionMap.put(SetTranslucentNavigation.KEY, new SetTranslucentNavigation() );
		functionMap.put(IsImmersiveSupported.KEY, new IsImmersiveSupported() );
		functionMap.put(HideWindowStatusBar.KEY, new HideWindowStatusBar() );
		// add other functions here
		return functionMap;
	}


	public  class getStatusBarHeight implements FREFunction{
		public static final String KEY = "getStatusBarHeight";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{


			try {
				// status bar height
				int statusBarHeight = 0;
				int resourceId = frecontext.getActivity().getResources().getIdentifier("status_bar_height", "dimen", "android");
				if (resourceId > 0) {
					statusBarHeight = frecontext.getActivity().getResources().getDimensionPixelSize(resourceId);
				}

				//// action bar height
				//int actionBarHeight = 0;
				//final TypedArray styledAttributes = getActivity().getTheme().obtainStyledAttributes(
				//		new int[] { android.R.attr.actionBarSize }
				//);
				//actionBarHeight = (int) styledAttributes.getDimension(0, 0);
				//styledAttributes.recycle();

				//// navigation bar height
				//int navigationBarHeight = 0;
				//int resourceId = getResources().getIdentifier("navigation_bar_height", "dimen", "android");
				//if (resourceId > 0) {
				//	navigationBarHeight = resources.getDimensionPixelSize(resourceId);
				//}

				return FREObject.newObject(statusBarHeight);

			} catch( Exception e ) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}

			return null;
		}
	}

	public class isDarkMode implements FREFunction{
		public static final String KEY = "isDarkMode";

		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{

			try{

				int nightModeFlags =
						frecontext.getActivity().getResources().getConfiguration().uiMode &
								Configuration.UI_MODE_NIGHT_MASK;
				Log.i(KEY, "::: NIGHTMODE STATUS : " + nightModeFlags );
				if( nightModeFlags == Configuration.UI_MODE_NIGHT_YES)// || nightModeFlags == 32)
					return FREObject.newObject(true);
				else
					return FREObject.newObject(false);
			}catch (Exception e){
				frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
				e.printStackTrace();
			}
			return null;
		}
	}
	public class statusBarStyleLight implements FREFunction{
		public static final String KEY = "statusBarStyleLight";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{
			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) {
				Log.i( KEY,  "Changing bar style is not supported "+Build.VERSION.SDK_INT+' '+ Build.VERSION_CODES.HONEYCOMB);
				return null;
			}

			try{
				//Receiving a Boolean
				boolean v = args[0].getAsBool();
				Log.i( KEY,  "statusBarStyleLight " + v);
				if(v) {
					View decorView = frecontext.getActivity().getWindow().getDecorView(); //set status background black
					decorView.setSystemUiVisibility(decorView.getSystemUiVisibility() & ~View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR); //set status text  light
				}else{
					frecontext.getActivity().getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);//  set status text dark
				}
			}catch (Exception e){
				frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
				e.printStackTrace();
			}
			return null;
		}
	}


	public class navigationBarStyleLight implements FREFunction {
		public static final String KEY = "navigationBarStyleLight";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{
			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) {
				Log.i( KEY,  "Changing bar style is not supported" );
				return null;
			}

			try{
				//Receiving a Boolean
				boolean v = args[0].getAsBool();
				Log.i( KEY,  "navigationBarStyleLight " + v);
				if(v) {
					View decorView = frecontext.getActivity().getWindow().getDecorView(); //set status background black
					decorView.setSystemUiVisibility(decorView.getSystemUiVisibility() & ~View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR); //set status text  light
				}else{
					frecontext.getActivity().getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);//  set status text dark
				}
			}catch (Exception e){
				frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
				e.printStackTrace();
			}
			return null;
		}
	}


	public class statusBarColor implements FREFunction {

		public static final String KEY = "statusBarColor";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
				Log.i(KEY, "Changing status bar color is not supported");
				return null;
			}

			try {
				int color = Color.parseColor(args[0].getAsString());
				Window window = frecontext.getActivity().getWindow();
				window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
				window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
				window.setStatusBarColor(color);
			} catch (Exception e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage());
			}

			return null;
		}
	}

	//////////////////
	public class GetSupportedUIFlags implements FREFunction {

		public static final String KEY = "getSupportedUIFlags";

		public FREObject call(FREContext frecontext, FREObject[] args) {

			Set<Integer> supportedFlags = new HashSet<Integer>();

			int systemVersion = Build.VERSION.SDK_INT;
			if (systemVersion >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
				supportedFlags.add(View.SYSTEM_UI_FLAG_VISIBLE);
				supportedFlags.add(View.SYSTEM_UI_FLAG_LOW_PROFILE);
				supportedFlags.add(View.SYSTEM_UI_FLAG_HIDE_NAVIGATION);
			}
			if (systemVersion >= Build.VERSION_CODES.JELLY_BEAN) {
				supportedFlags.add(View.SYSTEM_UI_FLAG_FULLSCREEN);
			}
			if (systemVersion >= Build.VERSION_CODES.KITKAT) {
				supportedFlags.add(View.SYSTEM_UI_FLAG_IMMERSIVE);
				supportedFlags.add(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
			}

			return FREUtilities.getVectorFromSet(supportedFlags.size(), true, supportedFlags);
			//return FREObjectUtils.getVectorFromSet( supportedFlags.size(), true, supportedFlags );
		}
	}


	public class SetUIVisibility implements FREFunction {
		public static final String KEY = "setUIVisibility";
		public FREObject call(FREContext frecontext, FREObject[] args){
			int flags = 0;
			try {
				flags = args[0].getAsInt();
			} catch (FRETypeMismatchException e) {
				e.printStackTrace();
			} catch (FREInvalidObjectException e) {
				e.printStackTrace();
			} catch (FREWrongThreadException e) {
				e.printStackTrace();
			}
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
				frecontext.getActivity().getWindow().getDecorView().setSystemUiVisibility( flags );
			}
			// SYSTEM_UI_FLAG_HIDE_NAVIGATION     14
			// hide nav, appears on touch

			// SYSTEM_UI_FLAG_LOW_PROFILE     14   (STATUS_BAR_HIDDEN 11)
			// dim status bar and nav

			// SYSTEM_UI_FLAG_VISIBLE       14   (STATUS_BAR_VISIBLE 11)
			// status bar visible (default)

			// SYSTEM_UI_FLAG_FULLSCREEN		 16
			// hides status bar

			// SYSTEM_UI_FLAG_IMMERSIVE 			19
			// immersive but on swipe the status and nav remain visible

			// SYSTEM_UI_FLAG_IMMERSIVE_STICKY 			19
			// truly immersive

			// IMMERSIVE
			// use with SYSTEM_UI_FLAG_HIDE_NAVIGATION, SYSTEM_UI_FLAG_FULLSCREEN

			return null;
		}
	}

	@SuppressLint("NewApi")
	public class UIVisibilityListener implements FREFunction, View.OnSystemUiVisibilityChangeListener  {
		public static final String KEY = "UIVisibilityListener";
		public FREObject call(FREContext frecontext, FREObject[] args){
			boolean enable = false;
			try {
				enable = args[0].getAsBool();
			} catch (FRETypeMismatchException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREInvalidObjectException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREWrongThreadException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
				frecontext.getActivity().getWindow().getDecorView().setOnSystemUiVisibilityChangeListener( enable ? this : null );
			}
			return null;
		}

		@Override
		public void onSystemUiVisibilityChange(int visibility) {
			//frecontext.dispatchEvent( UIVisibilityEvent.CHANGE, String.valueOf( visibility ) );
		}
	}

	//////

	public class SetCutoutMode implements FREFunction {

		public static final String KEY = "setCutoutMode";

		public FREObject call(FREContext frecontext, FREObject[] args){

			if (Build.VERSION.SDK_INT >= 28) {
				int value = 0;
				try {
					value = args[0].getAsInt();
				} catch (FRETypeMismatchException e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				} catch (FREInvalidObjectException e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				} catch (FREWrongThreadException e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				}

				Window window = frecontext.getActivity().getWindow();
				WindowManager.LayoutParams params = window.getAttributes();
				params.layoutInDisplayCutoutMode = value;
				window.setAttributes(params);
			}

			return null;
		}
	}

	public class GetDisplayCutoutRects implements FREFunction
	{
		public static final String KEY = "getDisplayCutoutRects";

		public FREObject call(FREContext frecontext, FREObject[] args){

			if (Build.VERSION.SDK_INT >= 28) {
				try {
					View view = frecontext.getActivity().getWindow().getDecorView();
					DisplayCutout cutout = view.getRootWindowInsets().getDisplayCutout();
					if (cutout == null) {
						return null;
					}

					List<Rect> rects = cutout.getBoundingRects();

					FREArray freArray = FREArray.newArray("flash.geom.Rectangle", rects.size(), true);
					long i = 0;

					for(Rect rect : rects) {
						FREObject x = FREObject.newObject(rect.left);
						FREObject y = FREObject.newObject(rect.top);
						FREObject w = FREObject.newObject(rect.width());
						FREObject h = FREObject.newObject(rect.height());
						FREObject[] params = new FREObject[] { x, y, w, h };
						FREObject freRect = FREObject.newObject("flash.geom.Rectangle", params);
						freArray.setObjectAt(i, freRect);
						i++;
					}

					return freArray;
				} catch(Exception e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				}
			}
			return null;
		}
	}

	public class SetBrightness implements FREFunction {
		public static final String KEY = "setBrightness";

		public FREObject call(FREContext frecontext, FREObject[] args){

			Window window = frecontext.getActivity().getWindow();
			WindowManager.LayoutParams lp = window.getAttributes();
			try {
				lp.screenBrightness = (float) args[0].getAsDouble();
			} catch (FRETypeMismatchException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREInvalidObjectException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREWrongThreadException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}
			window.setAttributes( lp );

			return null;
		}
	}



	public class SetTranslucentNavigation implements FREFunction {

		public static final String KEY = "setTranslucentNavigation";

		public FREObject call(FREContext frecontext, FREObject[] args){

			/* Enable translucent navigation on Kitkat and above */
			if( Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT ) {
				Window window = frecontext.getActivity().getWindow();
				window.addFlags( WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION );
			}

			return null;
		}

	}


	public class IsImmersiveSupported implements FREFunction {

		public static final String KEY = "isImmersiveSupported";

		public FREObject call(FREContext frecontext, FREObject[] args){

			try {
				return FREObject.newObject( Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT );
			} catch( FREWrongThreadException e ) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}

			return null;
		}

	}


	public class HideWindowStatusBar implements FREFunction {

		public static final String KEY = "hideWindowStatusBar";
		public FREObject call(FREContext frecontext, FREObject[] args){

			Window window = frecontext.getActivity().getWindow();
			window.clearFlags( WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN );
			/* Enabled translucent status bar on Kitkat and above */
			if( Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT ) {
				window.addFlags( WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS );
			}
			window.addFlags( WindowManager.LayoutParams.FLAG_FULLSCREEN );

			return null;
		}

	}


	//////////////////






}



