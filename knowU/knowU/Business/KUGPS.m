//
//  KUGPS.m
//  knowU
//
//  Created by HanJiatong on 15/7/4.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUGPS.h"
#import <UIKit/UIKit.h>
#import "CONSTS.h"

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
        [self initLocation];
    }
    return self;
}

- (void)initLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager) {
            [self.locationManager stopUpdatingHeading];
            self.locationManager.delegate = nil;
            self.locationManager = nil;
        }
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000;
        self.locationManager.delegate = self;
        self.locationManager.activityType = CLActivityTypeFitness;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            //        [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (void)startMonitoringSignificantLocationChanges{
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)startUpdatingLocation{
    [self.locationManager startUpdatingLocation];
}

- (void)stopMonitoringSignificantLocationChanges{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
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
