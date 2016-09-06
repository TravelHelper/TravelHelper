//
//  YBZTranslationController.h
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZBaseViewController.h"
#import "SYTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface YBZTranslationController : YBZBaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

//@property (nonatomic , strong) NSString *title;
//@property (nonatomic , strong) NSString *level;
//@property (nonatomic , strong) NSString *state;
//@property (nonatomic , strong) NSString *content;
//@property (nonatomic , strong) NSString *time;
//@property (nonatomic , strong) NSString *pay;

@property(strong,nonatomic) CLLocationManager *myLocationManager;
@property(strong,nonatomic) CLGeocoder *myGeocoder;
@property(strong,nonatomic) CLLocation *myLocation;
@end
