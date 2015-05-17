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

@interface KUBaseInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *homeAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation KUBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initNotification];
}

- (void)initUI {
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
    
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-keyboardRect.size.height));
        }];
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
        }];
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)pushToViewController:(UIButton *)sender {
    if (![self.homeAddressTextField.text length]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_HOME_ADDRESS delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
        return;
    }

    if (![self.companyAddressTextField.text length]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_TIP_TITLE message:STRING_NO_COMPANY_ADDRESS delegate:nil cancelButtonTitle:STRING_CONFIRM otherButtonTitles: nil];
        [alertView show];
        return;
    }
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
