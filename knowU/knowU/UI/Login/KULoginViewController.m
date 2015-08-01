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
#import "DevicePlatInfo.h"
#import "CONSTS.h"
#import "KUBaseModel.h"
#import "KUGPS.h"
@interface KULoginViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableData *receiveData;
/** 用户名*/
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *hideHandImageView;
@property (weak, nonatomic) IBOutlet UIImageView *showHandImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation KULoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initUI];
    [self initData];
    [self initNotification];
}

- (void)initUI{
    [self.loginButton setBackgroundImage:[UIImage imageNamed:IMAGE_LOGIN_NORMAL] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:IMAGE_LOGIN_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.registerButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_NORMAL] forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:[UIImage imageNamed:IMAGE_REGISTER_HIGHLIGHTED] forState:UIControlStateHighlighted];
}

- (void)initData{
    KUGPS *gps = [KUGPS manager];
    gps.locationBlock = ^(NSString *placeName, CLLocationCoordinate2D locationCoordinate){
    };
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithContentsOfFile:[self userInfoPath]];
    if (userInfo) {
        self.userNameTextField.text = [userInfo objectForKey:@"name"];
        self.passwordTextField.text = [userInfo objectForKey:@"password"];
    }
    
    RAC(self.loginButton, userInteractionEnabled) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
            return @([userName length] > 0 && [password length]> 0);
    }];
    
    RAC(self.headerImageView, image) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
            if ([userName length] > 0 && [password length] > 0) {
                return [UIImage imageNamed:@"sign_peo_2_0"];
            }
            else{
                return [UIImage imageNamed:@"sign_peo_1_0"];
            }
    }];

    RAC(self.hideHandImageView, hidden) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
        return @([userName length] > 0 && [password length] > 0);
    }];

    RAC(self.showHandImageView, hidden) =
    [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^(NSString *userName, NSString *password){
        return @(!([userName length] > 0 && [password length] > 0));
    }];
    
    
}

- (NSString *)userInfoPath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"userInfo.plist"];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
    if (iPhone4) {
        tranformY = -100;
    }
    else if (iPhone5) {
        tranformY = -20;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(UIButton *)sender {
    [[KUHTTPClient manager] loginWithUID:self.userNameTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        NSDictionary *userInfo = @{@"name" : self.userNameTextField.text,
                                   @"password" : self.passwordTextField.text};
        [userInfo writeToFile:[self userInfoPath] atomically:YES];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        KUHomepageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"KUHomepageViewController"];
        controller.userName = self.userNameTextField.text;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        navigationController.navigationBar.hidden = YES;
        [self presentViewController:navigationController animated:NO completion:NULL];
    } failure:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:[NSString stringWithFormat:@"error code is %ld, message is %@", (long)model.code, model.message] delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
    }];
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
