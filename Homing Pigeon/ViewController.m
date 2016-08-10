//
//  ViewController.m
//  Homing Pigeon
//
//  Created by Mohamed Ayadi on 08/09/16.
//  Copyright (c) 2016 Mohamed Ayadi. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"

#define Timer 60 // seconds * mins
@interface ViewController ()
{
    __block UIBackgroundTaskIdentifier bgTask;
}
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

@synthesize locationManager;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
      bgTask = 0;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;

    /* You needed to request permission. Comment out one or both of these to test out the behavior.
     * You can change the request text in your Info.plist
     */
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSURL *homeIndexUrl = [mainBundle URLForResource:@"index" withExtension:@"html"];
        
        NSURLRequest *urlReq = [NSURLRequest requestWithURL:homeIndexUrl];
        [self.webView loadRequest:urlReq];
    } else {
        NSLog(@"There IS internet connection");
        if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        [self.locationManager startUpdatingLocation];
    }
    
    
    
    /**
     * NOTE: The location is going to be 0, 0 if you check at this point because the request to update
     * has not gone through yet. It will be updating the location constantly and each time it does, the
     * delegate method below will fire, so you can get the updated location from there.
     */
    float latitude = self.locationManager.location.coordinate.latitude;
    float longitude = self.locationManager.location.coordinate.longitude;
    NSUserDefaults *deviceToken = [NSUserDefaults standardUserDefaults];
    NSString *theDeviceToken = [deviceToken stringForKey:@"deviceToken"];
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor]; //in NSUUID form
    NSString *uuidString = uuid.UUIDString; //if you just need the string
    NSURL *webView = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.homingpigeon.co/App/index.php?deviceid=%@&latitude=%.8f&longitude=%.8f&devicesystem=ios&devicetoken=%@", uuidString, latitude, longitude, theDeviceToken]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:webView];
    [_webView loadRequest:requestObj];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    
    
    [NSTimer scheduledTimerWithTimeInterval:Timer target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];

    
}
-(void)updateLocation{
    [locationManager startUpdatingLocation];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    bgTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task, preferably in chunks.
        NSUserDefaults *deviceToken = [NSUserDefaults standardUserDefaults];
        NSString *theDeviceToken = [deviceToken stringForKey:@"deviceToken"];
        
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor]; //in NSUUID form
        NSString *uuidString = uuid.UUIDString; //if you just need the string
        
        NSURL *webView = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.homingpigeon.co/App/index.php?deviceid=%@&latitude=%.8f&longitude=%.8f&devicesystem=ios&devicetoken=%@", uuidString, self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, theDeviceToken]];
        
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:webView];
        [_webView loadRequest:requestObj];

        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

@end
