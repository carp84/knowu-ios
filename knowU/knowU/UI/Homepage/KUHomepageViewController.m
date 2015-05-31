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
#import "Masonry.h"

@interface KUHomepageViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
/** 标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 显示连续登录天数*/
@property (weak, nonatomic) IBOutlet UILabel *loginDayLabel;        //还剩几天

/** 显示总登录天数*/
@property (weak, nonatomic) IBOutlet UILabel *totalLoginDayLabel;   //已登陆几天

/** 显示登录天数的背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *showLoginDayImageView;

/** 宠物图片*/
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;

@property (nonatomic, copy) NSString *userInputLocation;
@property (nonatomic, copy) NSString *locationWithSystem;
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (weak, nonatomic) IBOutlet UIButton *inputLocationButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftSpliteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightSpliteImageView;

/** 上传数据的时间，3秒之内禁止上传数据，避免数据重复*/
@property (nonatomic, strong) NSDate *updateLocationDate;

@property (nonatomic, strong) NSDictionary *petDictionary;

@end

@implementation KUHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    
}

- (void)initUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (iPhone4) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE4_BACKGROUND];
        [self initUIWith35Screen];
    }
    else if (iPhone5) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE5_BACKGROUND];
    }
    else if (iPhone6) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE6_BACKGROUND];
    }
    else if (iPhone6Plus || iPhone6PlusZoom) {
        self.backgroundView.image = [UIImage imageNamed:IMAGE_IPHONE6PLUS_BACKGROUND];
    }
    
    [self.loginDayLabel showOtherFontFromLocation:self.loginDayLabel.text.length - 1 length:1 fontSize:[UIFont systemFontOfSize:10]];

}

#pragma mark- 3.5寸屏幕UI
- (void)initUIWith35Screen{
    [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@33);
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(20);
    }];

    [self.showLoginDayImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    
    [self.petImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.width.equalTo(@155);
        make.height.equalTo(@270);
        
    }];

    [self.feedButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.petImageView.mas_bottom).offset(0);
        make.height.equalTo(@35);
        make.width.equalTo(@110);
        make.centerX.equalTo(@(-60));
    }];

    [self.giftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];

}

#pragma mark- 其他屏幕UI
- (void)initUIWithOtherScreen{
    
}

- (void)initData {
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pet" ofType:@"plist"]];
    self.petDictionary = [array objectAtIndex:arc4random() % [array count]];

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
    self.petImageView.image = [UIImage imageNamed:[self.petDictionary objectForKey:@"pet"]];
    if (totalLoginDay.integerValue == 4) {
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
    WEAKSELF;
    KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] objectAtIndex:0];
    view.inputBlock = ^(NSString *location){
        weakSelf.userInputLocation = location;
    };
    [view showWithType:KUFeedAlertType image:[UIImage imageNamed:[self.petDictionary objectForKey:@"alert"]]];
}

- (IBAction)inputLocation:(UIButton *)sender {
    WEAKSELF;
    KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] objectAtIndex:0];
    view.inputBlock = ^(NSString *location){
        weakSelf.userInputLocation = location;
    };
    [view showWithType:KULocationAlertType image:[UIImage imageNamed:[self.petDictionary objectForKey:@"alert"]]];
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
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:newLocation.timestamp.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alertView show];
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
