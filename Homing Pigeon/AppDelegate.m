//
//  AppDelegate.m
//  Homing Pigeon
//
//  Created by Mohamed Ayadi on 08/09/16.
//  Copyright (c) 2016 Mohamed Ayadi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // for iOS 8
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    application.applicationIconBadgeNumber = 0;
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString * deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]   stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"the generated device token string is : %@",deviceTokenString);
    
    NSUserDefaults *deviceTokenUserDefault = [NSUserDefaults standardUserDefaults];
    [deviceTokenUserDefault setObject:deviceTokenString forKey:@"deviceToken"];
    [deviceTokenUserDefault synchronize];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
        UIApplication *app = [UIApplication sharedApplication];
        
        //create new uiBackgroundTask
        __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        //and create new timer with async call:
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //run function methodRunAfterBackground
            NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)methodRunAfterBackground
{
    NSLog(@"%@",@"hii");
    
}

@end
