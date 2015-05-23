//
//  KUPetAlertView.m
//  knowU
//
//  Created by HanJiatong on 15/5/18.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUPetAlertView.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "UITextField+RACSignalSupport.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "KUTextField.h"
@interface KUPetAlertView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet KUTextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation KUPetAlertView

- (void)awakeFromNib{
    RAC(self.confirmButton, enabled) = [RACSignal combineLatest:@[self.locationTextField.rac_textSignal] reduce:^(NSString *loc){
        return @(loc.length > 0);
    }];
    //输入您所在地点的具体位置
}
- (IBAction)cancel:(UIButton *)sender {
    [self.locationTextField resignFirstResponder];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)confirm:(UIButton *)sender {
    
    if (self.inputBlock) {
        self.inputBlock(self.locationTextField.text);
    }
    [self cancel:sender];
}

- (void)showWithType:(KUAlertType)type image:(UIImage *)image{
    switch (type) {
        case KULocationAlertType:
        {
            self.locationTextField.placeholder = @"输入您所在地点的具体位置";
        }
            break;
        case KUFeedAlertType:
        {
            self.locationTextField.placeholder = @"吃饭/睡觉/喝水...";
        }
            break;
        default:
            break;
    }
    [self showWithImage:image];
}

- (void)showWithImage:(UIImage *)image{
    self.petImageView.image = image;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    [self layoutIfNeeded];
    self.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self confirm:self.confirmButton];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
