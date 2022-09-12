package com.fluocode.nativeANE;

import com.adobe.fre.FREASErrorException;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRENoSuchNameException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import java.util.Set;

public class FREUtilities {

	public static CharSequence[] convertFREArrayToCharSequenceArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		
    	int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		
    		CharSequence[] csa = new CharSequence[lenth];
        	FREObject obj=null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		csa[i] = obj.getAsString();
			}
        	return csa;
    	}
		return null;
	}

	
	public static int[] convertFREArrayToIntArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		
    	int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		
    		int[] sa = new int[lenth];
        	FREObject obj=null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		sa[i] = obj.getAsInt();
			}
        	return sa;
    	}
		return null;
	}

	public static double[] convertFREArrayToDoubleArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		
    	int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		
    		double[] sa = new double[lenth];
        	FREObject obj=null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		sa[i] = obj.getAsDouble();
			}
        	return sa;
    	}
		return null;
	}

	public static String[] convertFREArrayToStringArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		
    	int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		
    		String[] sa = new String[lenth];
        	FREObject obj=null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		sa[i] = obj.getAsString();
			}
        	return sa;
    	}
		return null;
	}
	
	public static boolean[] convertFREArrayToBooleadArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		boolean[] ba = new boolean[lenth];
        	FREObject obj = null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		ba[i] = obj.getAsBool();
			}
        	return ba;
    	}
		return null;
	}

	public static FREArray getVectorFromSet( int numElements, boolean fixed, Set<Integer> set ) {
		try {
			FREArray vector = FREArray.newArray( "int", numElements, fixed );
			long i = 0;
			for( Integer element : set ) {
				vector.setObjectAt( i++, FREObject.newObject( element.intValue() ) );
			}
			return vector;
		} catch( FREASErrorException e ) {
			e.printStackTrace();
		} catch( FREWrongThreadException e ) {
			e.printStackTrace();
		} catch( FRENoSuchNameException e ) {
			e.printStackTrace();
		} catch( FREInvalidObjectException e ) {
			e.printStackTrace();
		} catch( FRETypeMismatchException e ) {
			e.printStackTrace();
		}
		return null;
	}

}
