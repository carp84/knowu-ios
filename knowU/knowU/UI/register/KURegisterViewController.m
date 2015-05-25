//
//  KUSignInViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/1.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KURegisterViewController.h"
#import "KUHTTPClient.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "UITextField+RACSignalSupport.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "Masonry.h"
#import "KUBaseInfoViewController.h"
#import "CONSTS.h"
#import "DevicePlatInfo.h"
@interface KURegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@end

@implementation KURegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    [self initNotification];
}

- (void)initUI{
    [self.backButton setBackgroundImage:[UIImage imageNamed:IMAGE_BACK_NORMAL] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:IMAGE_BACK_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateNormal];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateHighlighted];
    self.nextStepButton.userInteractionEnabled = NO;
    
//    if ([DevicePlatInfo devicePlatform] == 3.5) {
//        [self.userNameView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.logoImageView.mas_bottom).offset(23);
//        }];
//    }
}

- (void)initData{
    
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkipButtonImage:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userNameTextField resignFirstResponder];
    [self.mailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
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
        tranformY = -150;
    }
    else if ([DevicePlatInfo devicePlatform] == 4) {
        tranformY = -120;
    }
    else if ([DevicePlatInfo devicePlatform] == 4.7) {
        tranformY = -80;
    }
    else if ([DevicePlatInfo devicePlatform] == 5.5) {
        tranformY = -30;
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
    if ([self.userNameTextField.text length] && [self.mailTextField.text length] && [self.passwordTextField.text length] && [self.confirmPasswordTextField.text length]) {
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_NORMAL] forState:UIControlStateNormal];
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_HIGHLIGHTED] forState:UIControlStateHighlighted];
        self.nextStepButton.userInteractionEnabled = YES;
    }
    else {
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateNormal];
        [self.nextStepButton setBackgroundImage:[UIImage imageNamed:IMAGE_RIGISTER_NO_USE] forState:UIControlStateHighlighted];
        self.nextStepButton.userInteractionEnabled = NO;
    }
}

- (IBAction)popToViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushToViewController:(UIButton *)sender {
    if (![self.userNameTextField.text length]) {
        [self showAlertViewWithMessage:STRING_NO_USER_NAME];
        return;
    }
    
    if (![self.mailTextField.text length]) {
        [self showAlertViewWithMessage:STRING_NO_MAIL];
        return;
    }
    if (![self.passwordTextField.text length]) {
        [self showAlertViewWithMessage:STRING_NO_PASSWORD];
        return;
    }
    
    if (![self.confirmPasswordTextField.text length]) {
        [self showAlertViewWithMessage:STRING_NO_CONFIRM_PASSWORD];
        return;
    }
    
    if (![self.confirmPasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        [self showAlertViewWithMessage:STRING_PASSWORD_NO_SAME];
        return;
    }
    
//    [[KUHTTPClient manager] registerWithUID:self.userNameTextField.text mail:self.mailTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        KUBaseInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"KUBaseInfoViewController"];
        controller.userName = self.userNameTextField.text;
        controller.password = self.passwordTextField.text;
        [self.navigationController pushViewController:controller animated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@ %@", operation, error);
//    }];
}

- (void)showAlertViewWithMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:message delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
    [alertView show];
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
