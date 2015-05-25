//
//  KUBaseInfoViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/10.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUBaseInfoViewController.h"
#import "KUHTTPClient.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "UITextField+RACSignalSupport.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "Masonry.h"
#import "KUDetailInfoViewController.h"
#import "CONSTS.h"
#import "DevicePlatInfo.h"

@interface KUBaseInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *homeAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (weak, nonatomic) IBOutlet UIButton *singleNextStepButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *homeAddressView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@end

@implementation KUBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initNotification];
}

- (void)initUI{
    [self.backButton setBackgroundImage:[UIImage imageNamed:IMAGE_BACK_NORMAL] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:IMAGE_BACK_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateNormal];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateHighlighted];
    self.nextStepButton.userInteractionEnabled = NO;
    
    [self.singleNextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateNormal];
    [self.singleNextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateHighlighted];
    self.singleNextStepButton.userInteractionEnabled = NO;
    
//    if ([DevicePlatInfo devicePlatform] == 3.5) {
//        [self.homeAddressView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.logoImageView.mas_bottom).offset(28);
//        }];
//    }
}


- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkipButtonImage:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.homeAddressTextField resignFirstResponder];
    [self.companyAddressTextField resignFirstResponder];
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
        tranformY = -180;
    }
    else if ([DevicePlatInfo devicePlatform] == 4) {
        tranformY = -100;
    }
    else if ([DevicePlatInfo devicePlatform] == 4.7) {
        tranformY = -60;
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

- (void)changeSkipButtonImage:(NSNotification *)notification{
    if ([self.homeAddressTextField.text length] && [self.companyAddressTextField.text length]) {
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_NORMAL] forState:UIControlStateNormal];
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_HIGHLIGHTED] forState:UIControlStateHighlighted];
        self.nextStepButton.userInteractionEnabled = YES;
        
        [self.singleNextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_NORMAL] forState:UIControlStateNormal];
        [self.singleNextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_HIGHLIGHTED] forState:UIControlStateHighlighted];
        self.singleNextStepButton.userInteractionEnabled = YES;
    }
    else {
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateNormal];
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateHighlighted];
        self.nextStepButton.userInteractionEnabled = NO;
        
        [self.singleNextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateNormal];
        [self.singleNextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateHighlighted];
        self.singleNextStepButton.userInteractionEnabled = NO;
    }
}

- (IBAction)pushToViewController:(UIButton *)sender {
//    if (![self.homeAddressTextField.text length]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_HOME_ADDRESS delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
//        [alertView show];
//        return;
//    }
//
//    if (![self.companyAddressTextField.text length]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_COMPANY_ADDRESS delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
//        [alertView show];
//        return;
//    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    KUDetailInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"KUDetailInfoViewController"];
    controller.userName = self.userName;
    controller.password = self.password;
    controller.homeAddress = self.homeAddressTextField.text;
    controller.companyAddress = self.companyAddressTextField.text;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)popToViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
