Notification installation instructions
Android
1) Gideros project

    Create Gideros project
    Export it as Android project
    Import it in Eclipse

2) Copying files

    Copy .so files from libs folder to each separate armeabi folder
    Add gcm.to the project
        Copy gcm.jar into libs folder
        Right click on Reference libraries
        Select Build path -> Configure Build Path
        Click Add JARs and navigate to your project libs folder.
        Select gcm.jar and click OK (if it's not there, but you have copied it, refresh the project)
        Go to Order and Export tab and check gcm.jar
    Copy to src/giderosmobile/android/plugins folder/notification folder into project's src/giderosmobile/android/plugins folder

3) Modify Android manifest

    Add permissions: (replace com.yourdomain.yourapp with your bundle name)

        <permission android:name="com.yourdomain.yourapp.permission.C2D_MESSAGE" android:protectionLevel="signature" />

        <uses-permission android:name="com.yourdomain.yourapp.permission.C2D_MESSAGE" />

        <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />

        <uses-permission android:name="android.permission.GET_ACCOUNTS" />

        <uses-permission android:name="android.permission.WAKE_LOCK" />

    Add services and receivers to application tag (replace com.yourdomain.yourapp with your bundle name) example manifest included:

        <receiver android:name="com.giderosmobile.android.plugins.notification.NotificationClass"></receiver>

        <receiver android:name="com.giderosmobile.android.plugins.notification.NotificationRestore" >
           	<intent-filter>
            	<action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>

        <receiver android:name="com.giderosmobile.android.plugins.notification.GCMReceiver" android:permission="com.google.android.c2dm.permission.SEND" >
          	<intent-filter>
          		<action android:name="com.google.android.c2dm.intent.RECEIVE" />
          		<action android:name="com.google.android.c2dm.intent.REGISTRATION" />
          		<category android:name="com.yourdomain.yourapp" />
          	</intent-filter>
        </receiver>

        <service android:name="com.giderosmobile.android.plugins.notification.GCMIntentService" />

4) Modify Main activity file

    Load notification library: System.loadLibrary("notification");
    Add external class: "com.giderosmobile.android.plugins.notification.NotificationClass"
    Add intent handing:

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
    }

