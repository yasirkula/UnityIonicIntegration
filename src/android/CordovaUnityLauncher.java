package org.apache.cordova.plugin;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CordovaUnityLauncher extends CordovaPlugin
{
	public static class UnityToIonicBroadcastReceiver extends BroadcastReceiver
	{
		@Override
		public void onReceive(Context context, Intent intent) 
		{
			if( intent.hasExtra( "message" ) )
			{
				CordovaUnityLauncher ionicPlugin = CordovaUnityLauncher.getInstance();
				if( ionicPlugin != null )
					ionicPlugin.onMessageReceivedFromUnity( intent.getStringExtra( "message" ) );
			}
			else
				Log.w( "UnityIonic", "No 'message' input is specified in UnityToIonicBroadcastReceiver!" );
		}
	}

	private static CordovaUnityLauncher Instance = null;

	public final int UNITY_LAUNCH_OP = 11;

	public static final String IONIC2UNITY_SEND_MESSAGE_BROADCAST = "IONIC2UNITY_SEND_MESSAGE";
	public static final String UNITY2IONIC_SEND_MESSAGE_BROADCAST = "UNITY2IONIC_SEND_MESSAGE";

	private CallbackContext callback = null;

	private UnityToIonicBroadcastReceiver broadcastReceiver = new UnityToIonicBroadcastReceiver();

	public static CordovaUnityLauncher getInstance() 
	{
		return Instance;
	}

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException 
	{
		if (action.equals("launchAR")) 
		{
			String param = "";
			try
			{
				param = args.getString(0);
			}
			catch( Exception e )
			{
			}

			callback = callbackContext;

			cordova.setActivityResultCallback (this);

			Intent intent = new Intent();
			intent.setClassName(cordova.getActivity().getPackageName(),"com.unitycaller.ionic.UnityPlayerExtendedActivity");
			intent.putExtra("my_param", param);
			
			Instance = this;
			cordova.getActivity().registerReceiver(broadcastReceiver, new IntentFilter( UNITY2IONIC_SEND_MESSAGE_BROADCAST ) );

			cordova.startActivityForResult (this, intent, UNITY_LAUNCH_OP);

			return true;
		}
		else if (action.equals("sendMessage")) 
		{
			try
			{
				String func = args.getString(0);
				String param = args.getString(1);

				// Need to send broadcast for IPC as Ionic and Unity run on different processes
				Intent unityMessage = new Intent( IONIC2UNITY_SEND_MESSAGE_BROADCAST );
				unityMessage.putExtra( "func", func );
				unityMessage.putExtra( "param", param );
				cordova.getActivity().sendBroadcast( unityMessage );
			}
			catch( Exception e )
			{
				Log.e( "UnityIonic", "exception", e );
			}

			return true;
		}

		return false;
	}

	public void onMessageReceivedFromUnity(String message) 
	{
		if( callback != null )
		{
			PluginResult result = new PluginResult(PluginResult.Status.OK, "MESSAGE" + message);
			result.setKeepCallback(true);
			callback.sendPluginResult(result);
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) 
	{
		if( requestCode == UNITY_LAUNCH_OP && callback != null )
		{
			if( resultCode == Activity.RESULT_OK && data.hasExtra("my_param") )
			{
				cordova.getActivity().unregisterReceiver( broadcastReceiver );
				
				PluginResult result = new PluginResult(PluginResult.Status.OK, "RETURN" + data.getStringExtra("my_param"));
				result.setKeepCallback(true);
				callback.sendPluginResult(result);
			}
			else
			{
				PluginResult result = new PluginResult(PluginResult.Status.ERROR, "" );
				result.setKeepCallback(true);
				callback.sendPluginResult(result);
			}
		}
	}
}