//
//  KUHomepageViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/1.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUHomepageViewController.h"
#import "DevicePlatInfo.h"
#import "CONSTS.h"
#import "UILabel+Addition.h"
#import "UIColor+Addition.h"
#import "KUProfile.h"
#import <CoreLocation/CoreLocation.h>
#import "KUHTTPClient.h"
#import "NSDate+Addition.h"
#import "KUPetAlertView.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"

@interface KUHomepageViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

@property (nonatomic, strong) UIView *leftTopWhiteView;
@property (nonatomic, strong) UIView *leftBottomWhiteView;
@property (nonatomic, strong) UIView *leftTopGrayView;
@property (nonatomic, strong) UIView *leftBottomGrayView;

@property (nonatomic, strong) UIView *rightTopWhiteView;
@property (nonatomic, strong) UIView *rightBottomWhiteView;
@property (nonatomic, strong) UIView *rightTopGrayView;
@property (nonatomic, strong) UIView *rightBottomGrayView;

/** 标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 显示连续登录天数*/
@property (weak, nonatomic) IBOutlet UILabel *loginDayLabel;

/** 显示总登录天数*/
@property (weak, nonatomic) IBOutlet UILabel *totalLoginDayLabel;

/** 显示登录天数的背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *showLoginDayImageView;

/** 宠物图片*/
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;

@property (nonatomic, copy) NSString *userInputLocation;
@property (nonatomic, copy) NSString *locationWithSystem;
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (weak, nonatomic) IBOutlet UIButton *inputLocationButton;

/** 上传数据的时间，3秒之内禁止上传数据，避免数据重复*/
@property (nonatomic, strong) NSDate *updateLocationDate;

@end

@implementation KUHomepageViewController

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
    
    [self.loginDayLabel showOtherFontFromLocation:self.loginDayLabel.text.length - 1 length:1 fontSize:[UIFont systemFontOfSize:10]];
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

- (void)initData {
    [self showWithLoginInfo:[[KUProfile manager] readFile]];
    [[KUProfile manager] updateFile];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    self.updateLocationDate = [NSDate date];
    self.userInputLocation = @"";
}

#pragma mark- 根据登录天数展示不同数据
- (void)showWithLoginInfo:(NSDictionary *)dictionary {
    NSNumber *loginDay = [dictionary objectForKey:@"loginDay"];
    NSNumber *totalLoginDay = [dictionary objectForKey:@"totalLoginDay"];
    
    self.loginDayLabel.text = [NSString stringWithFormat:@"%ld天", (long)loginDay.integerValue];
    [self.loginDayLabel showOtherFontFromLocation:[self.loginDayLabel.text length] - 1 length:1 fontSize:[UIFont systemFontOfSize:12]];
    
    self.totalLoginDayLabel.text = [NSString stringWithFormat:@"已登录%ld天", (long)totalLoginDay.integerValue];
    
    switch (totalLoginDay.integerValue) {
        case 1:
        {
            self.giftImageView.image = [UIImage imageNamed:IMAGE_HOMEPAGE_GIFT_1];
        }
            break;
        case 2:
        {
            self.giftImageView.image = [UIImage imageNamed:IMAGE_HOMEPAGE_GIFT_2];
        }
            break;
        case 3:
        {
            self.giftImageView.image = [UIImage imageNamed:IMAGE_HOMEPAGE_GIFT_3];
        }
            break;
        case 4:
        {
            self.giftImageView.image = [UIImage imageNamed:IMAGE_HOMEPAGE_GIFT_4];
        }
            break;
        default:{
        }
            break;
    }
    
    self.titleLabel.text = totalLoginDay.integerValue < 5 ? STRING_HOMEPAGE_HATCH_TITLE : STRING_HOMEPAGE_FEED_TITLE;
    
    if (totalLoginDay.integerValue == 5) {
        self.petImageView.hidden = NO;
        self.inputLocationButton.hidden = NO;
        self.feedButton.hidden = NO;
        
        self.petImageView.alpha = 0;
        self.inputLocationButton.alpha = 0;
        self.feedButton.alpha = 0;
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.giftImageView.alpha = 0.5;
            self.loginDayLabel.alpha = 0.5;
            self.totalLoginDayLabel.alpha = 0.5;
            self.showLoginDayImageView.alpha = 0.5;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.giftImageView.alpha = 0;
                self.loginDayLabel.alpha = 0;
                self.totalLoginDayLabel.alpha = 0;
                self.showLoginDayImageView.alpha = 0;
                
                self.petImageView.alpha = 1;
                self.inputLocationButton.alpha = 1;
                self.feedButton.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    else {
        self.petImageView.hidden = totalLoginDay.integerValue < 5 ? YES : NO;
        self.inputLocationButton.hidden = totalLoginDay.integerValue < 5 ? YES : NO;
        self.feedButton.hidden = totalLoginDay.integerValue < 5 ? YES : NO;
        
        self.giftImageView.hidden = totalLoginDay.integerValue < 5 ? NO : YES;
        self.loginDayLabel.hidden = totalLoginDay.integerValue < 5 ? NO : YES;
        self.totalLoginDayLabel.hidden = totalLoginDay.integerValue < 5 ? NO : YES;
        self.showLoginDayImageView.hidden = totalLoginDay.integerValue < 5 ? NO : YES;
    }
}

- (IBAction)feed:(UIButton *)sender {
    
}

- (IBAction)inputLocation:(UIButton *)sender {
    WEAKSELF;
    KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] objectAtIndex:0];
    view.inputBlock = ^(NSString *location){
        weakSelf.userInputLocation = location;
    };
    [view show];
}

- (void)uploadLocation:(CLLocationCoordinate2D)coordinate{
    [[KUHTTPClient manager] uploadTraceWithUID:self.userName traceInfo:
     @{@"userId"            : self.userName,
       @"latitude"          : @(coordinate.latitude),
       @"longitude"         : @(coordinate.longitude),
       @"timestamp"         : [[NSDate date] convertStringWithFormat:@"yyyy-MM-dd HH:mm:ss"],
       @"address"           : self.locationWithSystem,
       @"action"            : @"",
       @"dayOfWeek"         : @([[NSDate date] weekdayWithDate]),
       @"otherDescription"  : self.userInputLocation}
        success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
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
            if ([self.updateLocationDate isCanUpdate:[NSDate date]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:newLocation.timestamp.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                CLPlacemark *placemark = [array objectAtIndex:0];
                self.locationWithSystem = placemark.name;
                [self uploadLocation:newLocation.coordinate];
            }
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
