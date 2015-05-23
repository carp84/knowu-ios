//
//  KUFeedPetViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/18.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUFeedPetViewController.h"
#import "DevicePlatInfo.h"
#import "CONSTS.h"
#import "UIColor+Addition.h"
#import "KUPetAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "KUHTTPClient.h"
#import "NSDate+Addition.h"

@interface KUFeedPetViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UIView *leftTopWhiteView;
@property (nonatomic, strong) UIView *leftBottomWhiteView;
@property (nonatomic, strong) UIView *leftTopGrayView;
@property (nonatomic, strong) UIView *leftBottomGrayView;

@property (nonatomic, strong) UIView *rightTopWhiteView;
@property (nonatomic, strong) UIView *rightBottomWhiteView;
@property (nonatomic, strong) UIView *rightTopGrayView;
@property (nonatomic, strong) UIView *rightBottomGrayView;

@property (nonatomic, copy) NSString *userInputLocation;
@property (nonatomic, copy) NSString *locationWithSystem;

@end

@implementation KUFeedPetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)initUI {
    if ([DevicePlatInfo devicePlatform] == 3.5) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE4_BACKGROUND];
    }
    else if ([DevicePlatInfo devicePlatform] == 4) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE5_BACKGROUND];
    }
    else if ([DevicePlatInfo devicePlatform] == 4.7) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE6_BACKGROUND];
    }
    else if ([DevicePlatInfo devicePlatform] == 5.5) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE6PLUS_BACKGROUND];
    }
   
    //左面
    self.leftTopWhiteView = [[UIView alloc] initWithFrame:CGRectMake(27, self.titleLabel.center.y - 1.5, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.leftTopWhiteView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.leftTopWhiteView];
    
    self.leftTopGrayView = [[UIView alloc] initWithFrame:CGRectMake(27, self.leftTopWhiteView.frame.origin.y + self.leftTopWhiteView.frame.size.height + 0.5, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.leftTopGrayView.backgroundColor = [UIColor homepageGrayLine];
    [self.backgroundView addSubview:self.leftTopGrayView];
    
    self.leftBottomWhiteView = [[UIView alloc] initWithFrame:CGRectMake(27, self.leftTopWhiteView.frame.origin.y + self.leftTopWhiteView.frame.size.height + 2, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.leftBottomWhiteView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.leftBottomWhiteView];
    
    self.leftBottomGrayView = [[UIView alloc] initWithFrame:CGRectMake(27, self.leftTopGrayView.frame.origin.y + self.leftTopGrayView.frame.size.height + 2, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.leftBottomGrayView.backgroundColor = [UIColor homepageGrayLine];
    [self.backgroundView addSubview:self.leftBottomGrayView];
    
    //右面
    self.rightTopWhiteView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + self.titleLabel.frame.size.width / 2 + 20, self.titleLabel.center.y - 1.5, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.rightTopWhiteView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.rightTopWhiteView];
    
    self.rightTopGrayView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + self.titleLabel.frame.size.width / 2 + 20, self.rightTopWhiteView.frame.origin.y + self.rightTopWhiteView.frame.size.height + 0.5, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.rightTopGrayView.backgroundColor = [UIColor homepageGrayLine];
    [self.backgroundView addSubview:self.rightTopGrayView];
    
    self.rightBottomWhiteView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + self.titleLabel.frame.size.width / 2 + 20, self.rightTopWhiteView.frame.origin.y + self.rightTopWhiteView.frame.size.height + 2, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.rightBottomWhiteView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.rightBottomWhiteView];
    
    self.rightTopWhiteView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + self.titleLabel.frame.size.width / 2 + 20, self.rightTopGrayView.frame.origin.y + self.rightTopGrayView.frame.size.height + 2, [UIScreen mainScreen].bounds.size.width / 2 - self.titleLabel.frame.size.width / 2 - 27 - 20, 0.5)];
    self.rightTopWhiteView.backgroundColor = [UIColor homepageGrayLine];
    [self.backgroundView addSubview:self.rightTopWhiteView];
}


- (void)initData
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (IBAction)feed:(UIButton *)sender {
    
}

- (IBAction)inputLocation:(UIButton *)sender {
    WEAKSELF;
    KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] objectAtIndex:0];
    view.inputBlock = ^(NSString *location){
        weakSelf.userInputLocation = location;
    };

}

- (void)uploadLocation:(CLLocationCoordinate2D)coordinate{
    [[KUHTTPClient manager] uploadTraceWithUID:@"yy" traceInfo:
     @{@"userId"            : self.userName,
       @"latitude"          : @(coordinate.latitude),
       @"longitude"         : @(coordinate.longitude),
       @"timestamp"         : [[NSDate date] convertStringWithFormat:@"yyyy-MM-dd HH:mm:ss"],
       @"address"           : self.locationWithSystem,
       @"action"            : @"",
       @"dayOfWeek"         : @([[NSDate date] weekdayWithDate]),
       @"otherDescription"  : self.userInputLocation} success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        NSLog(@"%@ %@", operation, model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];

}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            self.locationWithSystem = placemark.name;
            [self uploadLocation:newLocation.coordinate];
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
