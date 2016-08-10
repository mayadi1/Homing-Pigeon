//
//  ViewController.h
//  Homing Pigeon
//
//  Created by Mohamed Ayadi on 08/09/16.
//  Copyright (c) 2016 Mohamed Ayadi. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

