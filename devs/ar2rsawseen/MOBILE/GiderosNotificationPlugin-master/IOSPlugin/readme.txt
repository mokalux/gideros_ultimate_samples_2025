IOS
1) Gideros project

    Create Gideros project
    Export it as IOS project
    Open project in Xcode

2) Copying files

    Copy Plugins/Notification folder int your Xcode project's Plugins folder
    Add files to your Xcode project:
        Right click on Plugins folder in your Xcode project
        Select Add file to "Your project name"
        Select: Create groups for any added folders
        select Notification folder and click Add

3) Modify AppDelegate file

    Add these properties to AppDelegate.h file class:

        @property (nonatomic, retain) UILocalNotification *launchLocalNotification;

        @property (nonatomic, retain) NSDictionary *launchRemoteNotification;

    Add these lines in the start of the application didFinishLaunchingWithOptions method in the AppDelegate.mm file:

        self.launchLocalNotification =
            [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];

        self.launchRemoteNotification =
            [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    Add these methods at the end of AppDelegate.m file class:

        - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
            UIApplicationState state = application.applicationState;
            NSNumber *launched = [NSNumber numberWithBool:(state ==UIApplicationStateInactive)];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:notification, @"notification", launched, @"launched", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onLocalNotification" object:self userInfo:dic];
        }

        - (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
        {
            UIApplicationState state = application.applicationState;
            NSNumber *launched = [NSNumber numberWithBool:(state ==UIApplicationStateInactive)];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"payLoad", launched, @"launched", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onPushNotification" object:self userInfo:dic];
        }

        - (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[deviceToken description] forKey:@"token"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onPushRegistration" object:self userInfo:dic];
        }

        - (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:error forKey:@"error"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onPushRegistrationError" object:self userInfo:dic];
        }

