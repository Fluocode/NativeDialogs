package com.fluocode.nativeANE.functions;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;


import com.fluocode.nativeANE.NativeDialogsExtension;
import android.annotation.SuppressLint;
import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Build;
import android.util.Log;
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



	
	

    	

}



