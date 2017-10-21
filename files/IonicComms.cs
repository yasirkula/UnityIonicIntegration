using System.IO;
using UnityEngine;

public class IonicComms : MonoBehaviour
{
	private static IonicComms Instance = null;

#if !UNITY_EDITOR && UNITY_IOS
	[System.Runtime.InteropServices.DllImport( "__Internal" )]
	private static extern void uHideUnity();

	[System.Runtime.InteropServices.DllImport( "__Internal" )]
	private static extern void uNotifyUnityReady();

	[System.Runtime.InteropServices.DllImport( "__Internal" )]
	private static extern void uSendMessageToIonic( string message );

	[System.Runtime.InteropServices.DllImport( "__Internal" )]
	private static extern void uSendResultToIonic( string result );
#endif

	[RuntimeInitializeOnLoadMethod( RuntimeInitializeLoadType.AfterSceneLoad )]
	static void Init()
	{
		if( Instance == null )
		{
			Instance = new GameObject( "IonicComms" ).AddComponent<IonicComms>();
			DontDestroyOnLoad( Instance.gameObject );
		}
	}

	void Awake()
	{
		if( Instance == null )
		{
			Instance = this;

			gameObject.name = "IonicComms";
			DontDestroyOnLoad( gameObject );
		}
		else if( this != Instance )
			Destroy( this );
	}

	void Start()
	{
		if( Instance != this )
			return;

#if !UNITY_EDITOR && UNITY_ANDROID
		using( AndroidJavaClass activityClass = new AndroidJavaClass( "com.unity3d.player.UnityPlayer" ) )
		using( AndroidJavaObject activity = activityClass.GetStatic<AndroidJavaObject>( "currentActivity" ) )
		{
			string data = activity.Get<string>( "commStr" );
			OnMessageReceivedFromIonic( data );
		}
#elif !UNITY_EDITOR && UNITY_IOS
		uNotifyUnityReady();
#endif
	}

	private void OnMessageReceivedFromIonic( string message )
	{
		if( string.IsNullOrEmpty( message ) )
			return;

		// Process message here

	}

	public static void SendMessageToIonic( string message )
	{
		if( message == null || message.Length == 0 )
			return;

#if !UNITY_EDITOR && UNITY_ANDROID
		using( AndroidJavaClass activityClass = new AndroidJavaClass( "com.unity3d.player.UnityPlayer" ) )
		using( AndroidJavaObject activity = activityClass.GetStatic<AndroidJavaObject>( "currentActivity" ) )
		{
			activity.Call( "sendMessageToIonic", message );
		}
#elif !UNITY_EDITOR && UNITY_IOS
		uSendMessageToIonic( message );
#endif
	}

	public static void FinishActivity( string returnMessage = null )
	{
#if UNITY_EDITOR
		UnityEditor.EditorApplication.isPlaying = false;
		return;
#endif

		if( returnMessage == null )
			returnMessage = "";

		if( Instance == null )
		{
			Application.Quit();
		}
		else
		{
#if UNITY_EDITOR
#elif UNITY_ANDROID
			using( AndroidJavaClass activityClass = new AndroidJavaClass( "com.unity3d.player.UnityPlayer" ) )
			using( AndroidJavaObject activity = activityClass.GetStatic<AndroidJavaObject>( "currentActivity" ) )
			{
				activity.Set<string>( "commStr", returnMessage );
				activity.Call( "closeApp" );
			}
#elif UNITY_IOS
			uSendResultToIonic( returnMessage );			
			uHideUnity();
#else
			Application.Quit();
#endif
		}
	}
}
