//
//  ViewController.m
//  knowU
//
//  Created by HanJiatong on 15/4/26.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 10;
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    NSLog(@"%@", locations);
    if ([locations count]) {
        CLLocation *location = [locations firstObject];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation: location completionHandler:^(NSArray *array, NSError *error) {
            
            NSLog(@"%@\n%@ %@ %d %@ %@",array,error.localizedDescription, error.domain, error.code, error.localizedRecoveryOptions, error.helpAnchor);
            if (array.count > 0) {
                
                CLPlacemark *placemark = [array objectAtIndex:0];
                //                NSLog(@"%@",placemark.addressDictionary);
                //                for (NSString *key in placemark.addressDictionary) {
                //                    NSLog(@"%@ %@", key, placemark.addressDictionary[key]);
                //                }
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath = [path stringByAppendingPathComponent: @"location.plist"];
                NSLog(@"%@", filePath);
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                if (!dictionary) {
                    dictionary = [[NSMutableDictionary alloc] init];
                }
                [dictionary setObject:placemark.addressDictionary forKey:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
                NSLog(@"%@", dictionary);
                [dictionary writeToFile:filePath atomically:YES];
                NSLog(@"name:%@", placemark.name);
                NSLog(@"thoroughfare:%@", placemark.thoroughfare);
                NSLog(@"subThoroughfare:%@", placemark.subThoroughfare);
                NSLog(@"locality:%@", placemark.locality);
                NSLog(@"subLocality:%@", placemark.subLocality);
                NSLog(@"administrativeArea:%@", placemark.administrativeArea);
                NSLog(@"subAdministrativeArea:%@", placemark.subAdministrativeArea);
                NSLog(@"postalCode:%@", placemark.postalCode);
                NSLog(@"ISOcountryCode:%@", placemark.ISOcountryCode);
                NSLog(@"country:%@", placemark.country);
                NSLog(@"inlandWater:%@", placemark.inlandWater);
                NSLog(@"ocean:%@", placemark.ocean);
                NSLog(@"areasOfInterest:%@", placemark.areasOfInterest);
            }
        }];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation %@", newLocation);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        
        NSLog(@"%@\n%@ %@ %d %@ %@",array,error.localizedDescription, error.domain, error.code, error.localizedRecoveryOptions, error.helpAnchor);
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            //                NSLog(@"%@",placemark.addressDictionary);
            //                for (NSString *key in placemark.addressDictionary) {
            //                    NSLog(@"%@ %@", key, placemark.addressDictionary[key]);
            //                }
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [path stringByAppendingPathComponent: @"location.plist"];
            NSLog(@"%@", filePath);
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            if (!dictionary) {
                dictionary = [[NSMutableDictionary alloc] init];
            }
            [dictionary setObject:placemark.addressDictionary forKey:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
            NSLog(@"%@", dictionary);
            [dictionary writeToFile:filePath atomically:YES];
            NSLog(@"name:%@", placemark.name);
            NSLog(@"thoroughfare:%@", placemark.thoroughfare);
            NSLog(@"subThoroughfare:%@", placemark.subThoroughfare);
            NSLog(@"locality:%@", placemark.locality);
            NSLog(@"subLocality:%@", placemark.subLocality);
            NSLog(@"administrativeArea:%@", placemark.administrativeArea);
            NSLog(@"subAdministrativeArea:%@", placemark.subAdministrativeArea);
            NSLog(@"postalCode:%@", placemark.postalCode);
            NSLog(@"ISOcountryCode:%@", placemark.ISOcountryCode);
            NSLog(@"country:%@", placemark.country);
            NSLog(@"inlandWater:%@", placemark.inlandWater);
            NSLog(@"ocean:%@", placemark.ocean);
            NSLog(@"areasOfInterest:%@", placemark.areasOfInterest);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
