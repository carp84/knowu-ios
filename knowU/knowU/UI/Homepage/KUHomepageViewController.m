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
#import "KUHTTPClient.h"
#import "NSDate+Addition.h"
#import "KUPetAlertView.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "Masonry.h"
#import "KULoginDayModel.h"
#import "KUPetTypeModel.h"
#import <AFNetworking.h>
#import "KULocationDAO.h"
#import "KULocationModel.h"
#import "KUGPS.h"

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
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (weak, nonatomic) IBOutlet UIButton *inputLocationButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftSpliteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightSpliteImageView;

@property (nonatomic, strong) NSDictionary *petDictionary;

@property (nonatomic, copy) NSString *action;

@property (nonatomic, assign) CLLocationCoordinate2D nowLocation;
@property (nonatomic, copy) NSString *locationWithSystem;

@end

@implementation KUHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    [self initNotification];
    
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
    
    WEAKSELF;
    KUGPS *gps = [KUGPS manager];
    [gps initLocation];
    gps.locationBlock = ^(NSString *placeName, CLLocationCoordinate2D locationCoordinate){
        
        weakSelf.nowLocation = locationCoordinate;
        if (placeName.length) {
            self.locationWithSystem = placeName;
        }
        
        [weakSelf uploadLocation:locationCoordinate];
        
    };
    
    [[KUHTTPClient manager] loginDayWithUID:self.userName success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        if ([model isKindOfClass: [KULoginDayModel class]]) {
            [self showPetTypeWithLoginModel:(KULoginDayModel *)model];
        }
    } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:[NSString stringWithFormat:@"error code is %ld, message is %@", (long)model.code, model.message] delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
    }];
    
    //如果数据库中有数据就先上传数据
    [self uploadCache];
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundFetch:) name:@"KUPerformFetchNotification" object:nil];
}

#pragma mark- 如果数据库中有数据就先上传数据
- (void)uploadCache{
    NSArray *dataArray = [KULocationDAO selectNotUpload];
    for (KULocationModel *locationModel in dataArray) {
        NSMutableDictionary *traceDictionary = [NSMutableDictionary dictionary];
        [traceDictionary setObject:locationModel.userId.length ? locationModel.userId : @"" forKey:@"userId"];
        [traceDictionary setObject:[locationModel.latitude isKindOfClass:[NSNumber class]] ? locationModel.latitude : @"" forKey:@"latitude"];
        [traceDictionary setObject:[locationModel.longitude isKindOfClass:[NSNumber class]] ? locationModel.longitude : @"" forKey:@"longitude"];
        [traceDictionary setObject:locationModel.timestamp.length ? locationModel.timestamp : @"" forKey:@"timestamp"];
        [traceDictionary setObject:locationModel.address.length ? locationModel.address : @"" forKey:@"address"];
        [traceDictionary setObject:locationModel.action.length ? locationModel.action : @"" forKey:@"action"];
        [traceDictionary setObject:[locationModel.dayOfWeek isKindOfClass:[NSNumber class]] ? locationModel.dayOfWeek : @""forKey:@"dayOfWeek"];
        [traceDictionary setObject:locationModel.otherDescription.length ? locationModel.otherDescription : @"" forKey:@"otherDescription"];
        [[KUHTTPClient manager] uploadTraceWithUID:locationModel.userId
                                         traceInfo:traceDictionary
                                           success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
                                               [KULocationDAO deleteWithIndex:@(locationModel.index)];
                                           } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
                                               
                                           }];
    }
}

- (void)backgroundFetch:(NSNotification *)notification{
    WEAKSELF;
    KUGPS *gps = [KUGPS manager];
    [gps initLocation];
    gps.locationBlock = ^(NSString *placeName, CLLocationCoordinate2D locationCoordinate){
        
        weakSelf.nowLocation = locationCoordinate;
        if (placeName.length) {
            self.locationWithSystem = placeName;
        }
        
        [weakSelf uploadLocation:locationCoordinate];
        
    };
}

- (void)showPetTypeWithLoginModel:(KULoginDayModel *)loginModel{
    [[KUHTTPClient manager] petTypeWithUID:self.userName success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        if ([model isKindOfClass:[KUPetTypeModel class]]) {
            self.petDictionary = [self petInfoWithIndex:((KUPetTypeModel *)model).petType];
            [self showWithLoginInfoWithModel:loginModel];
        }
    } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        self.petDictionary = [self petInfoWithIndex:-1];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:[NSString stringWithFormat:@"error code is %ld, message is %@", (long)model.code, model.message] delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
    }];
}

#pragma mark- 根据登录天数展示不同数据
- (void)showWithLoginInfoWithModel:(KULoginDayModel *)model {
    
    self.loginDayLabel.text = [NSString stringWithFormat:@"%d天", 4 - model.day];
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
    @try {
        WEAKSELF;
        KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] firstObject];
        view.inputBlock = ^(NSString *location){
            weakSelf.action = location;
            [weakSelf uploadLocation:self.nowLocation];
        };
        [view showWithType:KUFeedAlertType image:[UIImage imageNamed:[self.petDictionary objectForKey:@"alert"]]];
    }
    @catch (NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:[NSString stringWithFormat:@"exception is %@, reason is %@", exception.name, exception.reason] delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
    }
    @finally {
        
    }
    
}

- (IBAction)inputLocation:(UIButton *)sender {
    @try {
        WEAKSELF;
        KUPetAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"KUPetAlertView" owner:self options:nil] firstObject];
        view.inputBlock = ^(NSString *location){
            weakSelf.userInputLocation = location;
            [weakSelf uploadLocation:self.nowLocation];
        };
        [view showWithType:KULocationAlertType image:[UIImage imageNamed:[self.petDictionary objectForKey:@"alert"]]];
    }
    @catch (NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:[NSString stringWithFormat:@"exception is %@, reason is %@", exception.name, exception.reason] delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
    }
    @finally {
        
    }
    
}

- (void)uploadLocation:(CLLocationCoordinate2D)coordinate{
    if ([self networkReachability]) {
        NSMutableDictionary *traceDictionary = [NSMutableDictionary dictionary];
        [traceDictionary setObject:self.userName.length ? self.userName : @"" forKey:@"userId"];
        [traceDictionary setObject:@(self.nowLocation.latitude) forKey:@"latitude"];
        [traceDictionary setObject:@(self.nowLocation.longitude) forKey:@"longitude"];
        [traceDictionary setObject:[[NSDate date] convertStringWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"timestamp"];
        [traceDictionary setObject:self.locationWithSystem.length ? self.locationWithSystem : @"" forKey:@"address"];
        [traceDictionary setObject:self.action.length ? self.action : @"" forKey:@"action"];
        [traceDictionary setObject:@([[NSDate date] weekdayWithDate]) forKey:@"dayOfWeek"];
        [traceDictionary setObject:self.userInputLocation.length ? self.userInputLocation : @"" forKey:@"otherDescription"];
        
        [[KUHTTPClient manager] uploadTraceWithUID:self.userName
                                         traceInfo:traceDictionary
                                           success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
                                               NSLog(@"%@ %@", operation, model);
                                               self.locationWithSystem = nil;
                                               self.userInputLocation = nil;
                                               self.action = nil;
                                           } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
                                               
                                           }];
    }
    else{
        KULocationModel *model = [[KULocationModel alloc] init];
        model.userId = self.userName;
        model.latitude = @(self.nowLocation.latitude);
        model.longitude = @(self.nowLocation.longitude);
        model.timestamp = [[NSDate date] convertStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        model.address = self.locationWithSystem;
        model.action = self.action;
        model.dayOfWeek = @([[NSDate date] weekdayWithDate]);
        model.otherDescription = self.userInputLocation;
        [KULocationDAO insertWithModel:model];
    }
}

- (BOOL)networkReachability{
    BOOL reabchability = NO;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
        {
            reabchability = NO;
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            reabchability = YES;
        }
            break;
        default:
            break;
    }
    return reabchability;
}

- (void)networkingReachabilityChange:(NSNotification *)notification{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
       [self uploadCache];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KUPerformFetchNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
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
