using System.IO;
using UnityEngine;

public class IonicComms : MonoBehaviour
{
    private static IonicComms Instance = null;

#if !UNITY_EDITOR && UNITY_IOS
    [System.Runtime.InteropServices.DllImport( "__Internal" )]
    private static extern void uHideUnity();

    [System.Runtime.InteropServices.DllImport( "__Internal" )]
    private static extern void uSendResultToIonic( string result );
	
	[System.Runtime.InteropServices.DllImport( "__Internal" )]
	private static extern void uNotifyUnityReady();
#endif

    void Awake()
    {
        if( Instance == null )
        {
            Instance = this;
        }
        else if( this != Instance )
        {
            Destroy( this );
        }
    }
    
    void Start()
    {
        if( Instance != this )
            return;

        DontDestroyOnLoad( gameObject );

#if !UNITY_EDITOR && UNITY_ANDROID
        AndroidJavaClass activityClass = new AndroidJavaClass( "com.unity3d.player.UnityPlayer" );
        AndroidJavaObject activity = activityClass.GetStatic<AndroidJavaObject>( "currentActivity" );

        string data = activity.Get<string>( "commStr" );
        OnMessageReceivedFromIonic( data );
#elif !UNITY_EDITOR && UNITY_IOS
		uNotifyUnityReady();
#endif
    }
	
	void Update()
    {
        if( Input.GetKeyDown( KeyCode.Escape ) )
            FinishActivity();
    }

    public void OnMessageReceivedFromIonic( string message )
    {
        if( string.IsNullOrEmpty( message ) )
            return;

        // Process message here
    }

    public static void FinishActivity( string returnMessage = null )
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        return;
#endif

        if( Instance == null )
        {
            Application.Quit();
        }
		else
		{
#if UNITY_EDITOR
#elif UNITY_ANDROID
			AndroidJavaClass activityClass = new AndroidJavaClass( "com.unity3d.player.UnityPlayer" );
			AndroidJavaObject activity = activityClass.GetStatic<AndroidJavaObject>( "currentActivity" );

			if( !string.IsNullOrEmpty( returnMessage ) )
				activity.Set<string>( "commStr", returnMessage );

			activity.Call( "closeApp" );
#elif UNITY_IOS
			if( !string.IsNullOrEmpty( returnMessage ) )
				uSendResultToIonic( returnMessage );
						
			uHideUnity();
#else
			Application.Quit();
#endif
		}
    }
}