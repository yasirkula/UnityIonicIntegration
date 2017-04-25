using System.IO;
using UnityEngine;

public class IonicComms : MonoBehaviour
{
    private static IonicComms Instance = null;

#if !UNITY_EDITOR && UNITY_IOS
    [System.Runtime.InteropServices.DllImport( "__Internal" )]
    private static extern bool uHideUnity();

    [System.Runtime.InteropServices.DllImport( "__Internal" )]
    private static extern void uSendResultToIonic( string result );
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
#endif
    }

    public void OnMessageReceivedFromIonic( string message )
    {
        if( string.IsNullOrEmpty( message ) )
            return;

        // Process message here
    }

    private void Update()
    {
        if( Input.GetKeyDown( KeyCode.Escape ) )
            FinishActivity();
    }

    public static void FinishActivity( string returnMessage = null )
    {
        if( Instance != null )
            Instance.startTime = Mathf.Infinity;
        
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#elif UNITY_ANDROID
        AndroidJavaClass activityClass = new AndroidJavaClass( "com.unity3d.player.UnityPlayer" );
        AndroidJavaObject activity = activityClass.GetStatic<AndroidJavaObject>( "currentActivity" );

        if( !string.IsNullOrEmpty( returnMessage ) )
            activity.Set<string>( "commStr", returnMessage );

        activity.Call( "closeApp" );
#elif UNITY_IOS
        if( uHideUnity() == true ) 
        {
            Debug.Log( "Returned from Unity..." );

            if( !string.IsNullOrEmpty( returnMessage ) )
                uSendResultToIonic( returnMessage );
        }
#else
        Application.Quit();
#endif
    }
}