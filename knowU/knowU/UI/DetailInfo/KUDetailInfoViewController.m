//
//  KUDetailInfoViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/10.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUDetailInfoViewController.h"
#import "CONSTS.h"
typedef NS_ENUM(NSInteger, KUDetailInfoButtonType) {
    ButtonTypeOfMale = 1,   //1表示性别为女，2表示性别为男
    ButtonTypeOfFemale
};

@interface KUDetailInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *careerTextField;
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
/** 性别类型*/
@property (assign) NSInteger sexType;

@end

@implementation KUDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)initUI {
    
}

- (void)initData {
    
}

- (IBAction)selectSex:(UIButton *)sender {
    self.sexType = sender.tag;
    switch (sender.tag) {
        case ButtonTypeOfFemale:
        {
            [self.femaleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_FEMALE_SELECTED] forState:UIControlStateNormal];
            [self.femaleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_FEMALE_SELECTED] forState:UIControlStateHighlighted];
            
            [self.maleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_MALE_NORMAL] forState:UIControlStateNormal];
            [self.maleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_MALE_NORMAL] forState:UIControlStateHighlighted];
        }
            break;
        case ButtonTypeOfMale:
        {
            [self.femaleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_FRMALE_NORMAL] forState:UIControlStateNormal];
            [self.femaleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_FRMALE_NORMAL] forState:UIControlStateHighlighted];
            
            [self.maleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_MALE_SELECTED] forState:UIControlStateNormal];
            [self.maleButton setImage:[UIImage imageNamed: IMAGE_REGISTER_MALE_SELECTED] forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
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
