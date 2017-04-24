# Unity Ionic Integration (with Vuforia support)
This tutorial will show you how to integrate your Unity app into an Ionic app and send messages between them (optional). It is tested on a medium-scale commercial Unity project with Vuforia plugin (optional).

Before we start, I'd like to give credits to these other guides that helped me overcome some challenges I've faced along the way:
- will be
- added here very soon
- sorry for the inconvenience :-D

(some screenshots will be added in future revisions)

## System Requirements
- Android: Android Studio
- iOS: Xcode

## Ionic-side Setup
- First things first, you should import the plugin (available in this git repo) into your Ionic app using `ionic plugin add path/to/UnityArCallerPluginIonic`
- Now, you can call Unity from your Ionic app using the following code snippet (it is for TypeScript but shouldn't be different from Javascript):
```typescript
declare let unityARCaller: any;

openUnity() {
	// it is possible to send a string message to Unity-side (optional)
	unityARCaller.launchAR("my message for Unity-side", this.uSuccessCallback, this.uFailedCallback );
}

uSuccessCallback = (param) => {
	// param:String is the (optional) message received from Unity-side
	alert( param );
};
uFailedCallback = (error) => {
	// should ignore this callback
};
```

- All you have to do is call **openUnity()** function whenever you want to show Unity content and, (optionally) pass a String message to it. Upon returning from Unity to Ionic, **uSuccessCallback** is called with an (optional) String parameter *param* that is returned from the Unity-side

## Unity-side Setup
- In the first scene of your game, create an empty GameObject called **IonicComms** and add the following IonicComms script as component:
```csharp
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
```

- If you pass a String message from Ionic to Unity, it will be available in the **OnMessageReceivedFromIonic** function
- When you want to return to Ionic from Unity-side, just call **IonicComms.FinishActivity()** function (or, optionally, **IonicComms.FinishActivity( "message to Ionic" )** to send a message back)
- **SO, DO NOT USE Application.Quit() ANYMORE!**
- *for Vuforia users:* disable *Auto Graphics API* in Player Settings and remove everything but **OpenGLES2**

## Android Steps
- In Unity, open **Build Settings** and set **Build System** to **Gradle (New)**. Then, select the **Export Project** option and click **Export** button to export your Unity project as a Gradle project to an empty folder
- Build your Ionic project using `ionic build android` (use `ionic platform add android`, if Android platform is not added yet)
- Open *platforms/android* folder inside your Ionic project's path with Android Studio
- Open **settings.gradle** and insert the following lines (**don't forget to change the path in the second line!**):
```
include ':UnityProject'
project(':UnityProject').projectDir = new File('C:\\absolute path\\to your\\unity export folder')
```

- Open **build.gradle** of **android** module and insert the following line to where all the other compile command(s) are located at:
```
compile project(':UnityProject')
```

- Click **Sync now** (top-right) and wait until Android Studio yields an error
- In **build.gradle** of **UnityProject** module, change `apply plugin: 'com.android.application'` to `apply plugin: 'com.android.library'`
- Inside **jniLibs** folder of **android** module, delete *unity-classes.jar*, if exists
- Click **Sync now** again and wait for another error
- Inside **manifests** folder of **android** module, open *AndroidManifest.xml* and switch to **Merged Manifest** tab
- Click on the "*Suggestion: add 'tools:replace="android:icon"' to <application> element at AndroidManifest.xml to override*" text
- Open *AndroidManifest.xml* of **UnityProject** module and switch to **Text** tab
- Remove the `<activity>...</activity>` with the following intent:
```xml
<intent-filter>
	<action android:name="android.intent.action.MAIN" />
	<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
```

- Now you can Run the **android** module

**NOTE:** if you are able to build your Ionic project successfully the first time but not the second time, remove the Android platform using `ionic platform remove android` and add it again using `ionic platform add android`.

## iOS Steps
- Coming soon