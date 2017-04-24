package com.unitycaller.ionic;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.unity3d.player.UnityPlayerActivity;

public class UnityPlayerExtendedActivity extends UnityPlayerActivity
{
    public String commStr = "";

    @Override protected void onCreate (Bundle savedInstanceState)
    {
        Intent intent = getIntent();
        if( intent.hasExtra( "my_param" ) )
            commStr = intent.getStringExtra( "my_param" );
        else
            commStr = "";

        super.onCreate(savedInstanceState);
    }

    public void closeApp()
    {
        //Intent intent = new Intent( this, UnityReturnBlankActivity.class );
        //startActivity( intent );

        Intent resultIntent = new Intent();
        resultIntent.putExtra("my_param", commStr);
        setResult(Activity.RESULT_OK, resultIntent);

        finish();
    }
}
