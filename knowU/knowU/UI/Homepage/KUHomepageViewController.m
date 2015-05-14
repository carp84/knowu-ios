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
@interface KUHomepageViewController ()

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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginDayLabel;

@end

@implementation KUHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
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
