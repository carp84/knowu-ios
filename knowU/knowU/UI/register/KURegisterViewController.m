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

@interface KURegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@end

@implementation KURegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initData];
}

- (void)initData{
    RAC(self.nextStepButton, userInteractionEnabled) = [RACSignal combineLatest:@[
                                                                               self.nickNameTextField.rac_textSignal,
                                                                               self.mailTextField.rac_textSignal,
                                                                               self.passwordTextField.rac_textSignal,
                                                                               self.confirmPasswordTextField.rac_textSignal] reduce:^(NSString *nickName, NSString *mail, NSString *password, NSString *confirmPassword){
                                                                                   return @(nickName.length > 0 && mail.length > 0 && password.length > 0 && confirmPassword.length > 0);
                                                                               }];
}
- (IBAction)popToViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushToViewController:(UIButton *)sender {
    [[KUHTTPClient manager] registerWithUID:self.nickNameTextField.text mail:self.mailTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        NSLog(@"%@ %@", operation, model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ %@", operation, error);
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
