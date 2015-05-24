//
//  KUDetailInfoViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/10.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUDetailInfoViewController.h"
#import "CONSTS.h"
#import "KUSelectedBirthdayView.h"
#import "Masonry.h"
#import "KUBrithdayTextField.h"
#import "KUHTTPClient.h"
#import "KUHomepageViewController.h"
#import "NSString+Addition.h"
#import "DevicePlatInfo.h"

typedef NS_ENUM(NSInteger, KUDetailInfoButtonType) {
    ButtonTypeOfMale = 1,   //1表示性别为女，2表示性别为男
    ButtonTypeOfFemale
};

@interface KUDetailInfoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *careerTextField;
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
/** 性别类型*/
@property (assign) NSInteger sexType;

@property (nonatomic, strong) KUSelectedBirthdayView *pickerView;

@property (weak, nonatomic) IBOutlet KUBrithdayTextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (nonatomic, getter=isSkipFillInDetailInfo) BOOL skipFillInDetailInfo;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation KUDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    [self initNotification];
}

- (void)initUI {
    WEAKSELF;
    self.pickerView = [[[NSBundle mainBundle] loadNibNamed:@"KUSelectedBirthdayView" owner:self options:nil] objectAtIndex:0];
    self.pickerView.alpha = 0;
    self.pickerView.selectedBirthdayBlock = ^(NSString *birthday){
        NSLog(@"%@", birthday);
        weakSelf.birthdayTextField.text = birthday;
        weakSelf.skipFillInDetailInfo = NO;
        [weakSelf changeSkipButtonTitle:nil];
    };
    [self.view addSubview:self.pickerView];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    self.birthdayTextField.touchBlock = ^{
        [weakSelf.pickerView show];
        
    };
    
    [self.backButton setBackgroundImage:[UIImage imageNamed:IMAGE_BACK_NORMAL] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:IMAGE_BACK_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.skipButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_NORMAL] forState:UIControlStateNormal];
    [self.skipButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_HIGHLIGHTED] forState:UIControlStateHighlighted];
}

- (void)initData {
    self.sexType = 0;
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkipButtonTitle:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat tranformY = 0;//keyboardRect.origin.y - [UIScreen mainScreen].bounds.size.height;
    if ([DevicePlatInfo devicePlatform] == 3.5) {
        tranformY = -200;
    }
    else if ([DevicePlatInfo devicePlatform] == 4) {
        tranformY = -100;
    }
    else if ([DevicePlatInfo devicePlatform] == 4.7) {
        tranformY = -100;
    }
    else if ([DevicePlatInfo devicePlatform] == 5.5) {
        tranformY = -80;
    }
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, tranformY);
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeSkipButtonTitle:(NSNotification *)notification{
    if ([self.careerTextField.text length] || [self.cellTextField.text length] || self.sexType != 0 || [self.birthdayTextField.text length]) {
        [self.skipButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.skipButton setTitle:@"确定" forState:UIControlStateHighlighted];
        self.skipFillInDetailInfo = NO;
    }
    else {
        [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [self.skipButton setTitle:@"跳过" forState:UIControlStateHighlighted];
        self.skipFillInDetailInfo = YES;
    }
}

- (IBAction)selectSex:(UIButton *)sender {
    self.sexType = sender.tag;
    self.skipFillInDetailInfo = NO;
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
    [self changeSkipButtonTitle:nil];
}
- (IBAction)popToViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pushToViewController:(UIButton *)sender {
    
    
//    if (self.skipFillInDetailInfo) {
        [self handlePushViewController];
//    }
//    else {
//        [[KUHTTPClient manager] fillUserInfoWithUID:self.userName
//                                           password:self.password
//                                           userInfo:@{@"userId"         : self.userName,
//                                                      @"password"       : [self.password MD5],
//                                                      @"homeAddress"    : self.homeAddress,
//                                                      @"workAddress"    : self.companyAddress,
//                                                      @"birthday"       : self.birthdayTextField.text,
//                                                      @"gender"         : @(self.sexType),
//                                                      @"jobDescription" : self.careerTextField.text,
//                                                      @"mobile"         : self.cellTextField.text
//                                                      }
//                                            success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
//                                                [self handlePushViewController];
//                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                
//                                            }];
//
//    }
}

- (void)handlePushViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    KUHomepageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"KUHomepageViewController"];
    controller.userName = self.userName;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBar.hidden = YES;
    [self presentViewController:navigationController animated:NO completion:NULL];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
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
