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
#import "Masonry.h"
#import "KUHomepageViewController.h"

@interface KULoginViewController ()

@property (nonatomic, strong) NSMutableData *receiveData;
/** 用户名*/
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *hideHandImageView;
@property (weak, nonatomic) IBOutlet UIImageView *showHandImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
    [self initNotification];
}

- (void)initData{
    RAC(self.loginButton, userInteractionEnabled) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
            return @(userName.length > 0 && password.length > 0);
    }];
    
    RAC(self.headerImageView, image) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
            if (userName.length > 0 && password.length > 0) {
                return [UIImage imageNamed:@"sign_peo_2_0"];
            }
            else{
                return [UIImage imageNamed:@"sign_peo_1_0"];
            }
    }];

    RAC(self.hideHandImageView, hidden) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
        return @(userName.length > 0 && password.length > 0);
    }];

    RAC(self.showHandImageView, hidden) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
        return @(!(userName.length > 0 && password.length > 0));
    }];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat tranformY = keyboardRect.origin.y - [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(@(-keyboardRect.size.height));
//        }];
//        [self.scrollView layoutIfNeeded];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(UIButton *)sender {
//    [[KUHTTPClient manager] loginWithUID:self.userNameTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        KUHomepageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"KUHomepageViewController"];
        [self.navigationController pushViewController:controller animated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

- (IBAction)register:(UIButton *)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
*/

@end
