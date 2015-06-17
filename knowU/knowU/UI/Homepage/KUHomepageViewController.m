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
#import "KULoginDayModel.h"
#import "KUPetTypeModel.h"

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

@property (nonatomic, assign) CLLocationCoordinate2D nowLocation;

@property (nonatomic, copy) NSString *action;

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

- (NSDictionary *)petInfoWithIndex:(NSInteger)index{
    
    NSArray *array = @[@{@"pet" : @"秘书" , @"alert" : @"弹框秘书"},
                       @{@"pet" : @"助手" , @"alert" : @"弹框助手"},
                       @{@"pet" : @"女神" , @"alert" : @"弹框女神"},
                       @{@"pet" : @"宠物" , @"alert" : @"弹框宠物"},
                       @{@"pet" : @"运动女" , @"alert" : @"弹框运动女"},
                       @{@"pet" : @"运动男" , @"alert" : @"弹框运动男"}];
    if (index == -1) {
        return [array objectAtIndex:arc4random() % [array count]];
    }
    return [array objectAtIndex:index - 1];
}

- (void)initData {
    
    
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
    
    self.updateLocationDate = [NSDate date];
    self.userInputLocation = @"";
    self.locationWithSystem = @"";
    self.action = @"";
    
    [[KUHTTPClient manager] loginDayWithUID:self.userName success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        if ([model isKindOfClass: [KULoginDayModel class]]) {
            [self showPetTypeWithLoginModel:(KULoginDayModel *)model];
        }
    } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:model.message delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
    }];
}

- (void)showPetTypeWithLoginModel:(KULoginDayModel *)loginModel{
    [[KUHTTPClient manager] petTypeWithUID:self.userName success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        if ([model isKindOfClass:[KUPetTypeModel class]]) {
            self.petDictionary = [self petInfoWithIndex:((KUPetTypeModel *)model).petType];
            [self showWithLoginInfoWithModel:loginModel];
        }
    } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        self.petDictionary = [self petInfoWithIndex:-1];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:model.message delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
    }];
}

#pragma mark- 根据登录天数展示不同数据
- (void)showWithLoginInfoWithModel:(KULoginDayModel *)model {
    
    self.loginDayLabel.text = [NSString stringWithFormat:@"%d天", model.day];
    [self.loginDayLabel showOtherFontFromLocation:[self.loginDayLabel.text length] - 1 length:1 fontSize:[UIFont systemFontOfSize:12]];
    
    self.totalLoginDayLabel.text = [NSString stringWithFormat:@"已登录%d天", model.day];
    
    switch (model.day) {
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
    
    self.titleLabel.text = model.day < 5 ? STRING_HOMEPAGE_HATCH_TITLE : STRING_HOMEPAGE_FEED_TITLE;
    self.petImageView.image = [UIImage imageNamed:[self.petDictionary objectForKey:@"pet"]];
    if (model.day == 4) {
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
        self.petImageView.hidden = model.day < 5 ? YES : NO;
        self.inputLocationButton.hidden = model.day < 5 ? YES : NO;
        self.feedButton.hidden = model.day < 5 ? YES : NO;
        
        self.giftImageView.hidden = model.day < 5 ? NO : YES;
        self.loginDayLabel.hidden = model.day < 5 ? NO : YES;
        self.totalLoginDayLabel.hidden = model.day < 5 ? NO : YES;
        self.showLoginDayImageView.hidden = model.day < 5 ? NO : YES;
    }
}

- (IBAction)feed:(UIButton *)sender {
    WEAKSELF;
    KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] objectAtIndex:0];
    view.inputBlock = ^(NSString *location){
        weakSelf.action = location;
        [weakSelf uploadLocation:self.nowLocation];
    };
    [view showWithType:KUFeedAlertType image:[UIImage imageNamed:[self.petDictionary objectForKey:@"alert"]]];
}

- (IBAction)inputLocation:(UIButton *)sender {
    WEAKSELF;
    KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] objectAtIndex:0];
    view.inputBlock = ^(NSString *location){
        weakSelf.userInputLocation = location;
        [weakSelf uploadLocation:self.nowLocation];
    };
    [view showWithType:KULocationAlertType image:[UIImage imageNamed:[self.petDictionary objectForKey:@"alert"]]];
}

- (void)uploadLocation:(CLLocationCoordinate2D)coordinate{
    NSLog(@"%@ %@ ", self.userName, self.userInputLocation);
    [[KUHTTPClient manager] uploadTraceWithUID:self.userName traceInfo:
     @{@"userId"            : self.userName,
       @"latitude"          : @(self.nowLocation.latitude),
       @"longitude"         : @(self.nowLocation.longitude),
       @"timestamp"         : [[NSDate date] convertStringWithFormat:@"yyyy-MM-dd HH:mm:ss"],
       @"address"           : self.locationWithSystem,
       @"action"            : self.action,
       @"dayOfWeek"         : @([[NSDate date] weekdayWithDate]),
       @"otherDescription"  : self.userInputLocation}
        success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
           NSLog(@"%@ %@", operation, model);
            self.locationWithSystem = @"";
            self.userInputLocation = @"";
            self.action = @"";
       } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
           
       }];
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            if ([self.updateLocationDate isCanUpdate:[NSDate date]]) {
                self.nowLocation = newLocation.coordinate;

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
