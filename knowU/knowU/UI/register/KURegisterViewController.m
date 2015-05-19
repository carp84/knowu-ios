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
@end

@implementation KURegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initData];
    [self initNotification];
}

- (void)initData{
    RAC(self.nextStepButton, userInteractionEnabled) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal,self.mailTextField.rac_textSignal,self.passwordTextField.rac_textSignal,self.confirmPasswordTextField.rac_textSignal] reduce:^(NSString *nickName, NSString *mail, NSString *password, NSString *confirmPassword){
            return @(nickName.length > 0 && mail.length > 0 && password.length > 0 && confirmPassword.length > 0);
    }];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
        tranformY = -80;
    }
    else if ([DevicePlatInfo devicePlatform] == 4.7) {
        tranformY = -80;
    }
    else if ([DevicePlatInfo devicePlatform] == 5.5) {
        tranformY = -100;
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

- (IBAction)popToViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushToViewController:(UIButton *)sender {
    if (![self.userNameTextField.text length]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_USER_NAME delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (![self.mailTextField.text length]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_MAIL delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (![self.passwordTextField.text length]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_PASSWORD delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (![self.confirmPasswordTextField.text length]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_CONFIRM_PASSWORD delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if ([self.confirmPasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_PASSWORD_NO_SAME delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    
    [[KUHTTPClient manager] registerWithUID:self.userNameTextField.text mail:self.mailTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        KUBaseInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"KUBaseInfoViewController"];
        controller.userName = self.userNameTextField.text;
        controller.password = self.passwordTextField.text;
        [self.navigationController pushViewController:controller animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ %@", operation, error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
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
