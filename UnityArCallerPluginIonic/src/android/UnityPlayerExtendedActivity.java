package com.unitycaller.ionic;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;

import org.apache.cordova.plugin.CordovaUnityLauncher;

import com.unity3d.player.UnityPlayer;
import com.unity3d.player.UnityPlayerActivity;

public class UnityPlayerExtendedActivity extends UnityPlayerActivity
{
	public static class IonicToUnityBroadcastReceiver extends BroadcastReceiver
	{
		@Override
		public void onReceive(Context context, Intent intent) 
		{
			if( intent.hasExtra( "func" ) && intent.hasExtra( "param" ) )
				UnityPlayer.UnitySendMessage("IonicComms", intent.getStringExtra( "func" ), intent.getStringExtra( "param" ) );
			else
				Log.w( "UnityIonic", "No 'func' or 'param' input is specified in IonicToUnityBroadcastReceiver!" );
		}
	}

	public String commStr = "";

	private IonicToUnityBroadcastReceiver broadcastReceiver = new IonicToUnityBroadcastReceiver();

	@Override protected void onCreate (Bundle savedInstanceState)
	{
		Intent intent = getIntent();
		if( intent.hasExtra( "my_param" ) )
			commStr = intent.getStringExtra( "my_param" );
		else
			commStr = "";

		registerReceiver(broadcastReceiver, new IntentFilter( CordovaUnityLauncher.IONIC2UNITY_SEND_MESSAGE_BROADCAST ) );
		super.onCreate(savedInstanceState);
	}

	@Override protected void onDestroy ()
	{
		unregisterReceiver( broadcastReceiver );
		super.onDestroy();
	}

	public void sendMessageToIonic( String message )
	{
		if( message != null && message.length() > 0 )
		{
			// Need to send broadcast for IPC as Ionic and Unity run on different processes
			Intent ionicMessage = new Intent( CordovaUnityLauncher.UNITY2IONIC_SEND_MESSAGE_BROADCAST );
			ionicMessage.putExtra( "message", message );
			sendBroadcast( ionicMessage );
		}
		else
		{
			Log.w( "UnityIonic", "Message to Ionic is null or empty!" );
		}
	}

	// Called from Unity to return to Ionic
	public void closeApp()
	{
		if( commStr == null )
			commStr = "";

		Intent resultIntent = new Intent();
		resultIntent.putExtra("my_param", commStr);
		setResult(Activity.RESULT_OK, resultIntent);

		finish();
	}
}