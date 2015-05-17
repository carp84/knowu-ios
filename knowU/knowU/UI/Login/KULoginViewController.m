//
//  KULoginViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/1.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KULoginViewController.h"
#import "KUHTTPClient.h"
#import "JSONKit.h"
#import "NSString+Addition.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "UITextField+RACSignalSupport.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
@interface KULoginViewController ()

@property (nonatomic, strong) NSMutableData *receiveData;
/** 用户名*/
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation KULoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
//    [[KUHTTPClient manager] uploadTraceWithUID:@"yy" traceInfo:@{@"userId"         : @"yy",
//                                                                 @"latitude"       : @"130",
//                                                                 @"longitude"    : @"45",
//                                                                 @"timestamp"       : @"1996-07-09 23:58:59",
//                                                                 @"address"         : @"北京",
//                                                                 @"action" : @"写代码的",
//                                                                 @"dayOfWeek"         : @1,
//                                                                 @"otherDescription" : @"1"} success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
//        NSLog(@"%@ %@", operation, model);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
    [self initData];
}

- (void)initData{
    RAC(self.loginButton, userInteractionEnabled) = [RACSignal combineLatest:@[
                                                                self.userNameTextField.rac_textSignal,
                                                                self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
                                                                    return @(userName.length > 0 && password.length > 0);
                                                                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(UIButton *)sender {
}

- (IBAction)register:(UIButton *)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",sender);
    if ([segue.identifier isEqualToString:@"login"]) {
        [[KUHTTPClient manager] loginWithUID:self.userNameTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
            [segue perform];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
}


@end
