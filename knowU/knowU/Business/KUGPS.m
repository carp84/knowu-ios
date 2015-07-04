//
//  KUGPS.m
//  knowU
//
//  Created by HanJiatong on 15/7/4.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUGPS.h"
#import <UIKit/UIKit.h>

static KUGPS *location;

@interface KUGPS ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation KUGPS

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[KUGPS alloc] init];
    });
    return location;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10;
        self.locationManager.delegate = self;
        self.locationManager.activityType = CLActivityTypeFitness;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            //        [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        NSLog(@"%f", newLocation.coordinate.longitude);
        if (self.locationBlock) {
            if (array.count > 0) {
                CLPlacemark *placemark = [array objectAtIndex:0];
                self.locationBlock(placemark.name, newLocation.coordinate);
            }
            else {
                self.locationBlock(nil, newLocation.coordinate);
            }
        }
    }];
}

@end
