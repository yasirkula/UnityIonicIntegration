package org.apache.cordova.plugin;

import android.app.Activity;
import android.content.Intent;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CordovaUnityLauncher extends CordovaPlugin
{
    public final int UNITY_LAUNCH_OP = 11;

    private CallbackContext callback = null;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("launchAR")) {
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

            cordova.startActivityForResult (this, intent, UNITY_LAUNCH_OP);
            return true;
        }

        return false;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if( requestCode == UNITY_LAUNCH_OP && callback != null )
        {
            if( resultCode == Activity.RESULT_OK && data.hasExtra("my_param") )
            {
                PluginResult result = new PluginResult(PluginResult.Status.OK, data.getStringExtra("my_param"));
                result.setKeepCallback(true);
                callback.sendPluginResult(result);
            }
            else
            {
                PluginResult result = new PluginResult(PluginResult.Status.ERROR, "no params" );
                result.setKeepCallback(true);
                callback.sendPluginResult(result);
            }
        }
    }
}