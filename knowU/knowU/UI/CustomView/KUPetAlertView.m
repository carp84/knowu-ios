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
#import "CONSTS.h"

@interface KUPetAlertView () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet KUTextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextView *actionTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation KUPetAlertView

- (void)awakeFromNib{
    //输入您所在地点的具体位置
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:IMAGE_ALERT_CANCEL_NORMAL] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:IMAGE_ALERT_CANCEL_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:IMAGE_ALERT_CONFIRM_NORMAL] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:IMAGE_ALERT_CONFIRM_HIGHLIGHTED] forState:UIControlStateHighlighted];
    self.actionTextView.delegate = self;
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.actionTextView resignFirstResponder];
}

- (void)showWithType:(KUAlertType)type image:(UIImage *)image{
    switch (type) {
        case KULocationAlertType:
        {
            self.placeholderLabel.text = @"输入您所在地点的具体位置";
            self.titleLabel.text = @"快来告诉你的位置～";
        }
            break;
        case KUFeedAlertType:
        {
            self.placeholderLabel.text = @"吃饭/睡觉/喝水...";
            self.titleLabel.text = @"快来告诉你正在干什么吧～";
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.actionTextView.text length]) {
        self.placeholderLabel.hidden = YES;
        if ([self.actionTextView.text length] > 20) {
            self.actionTextView.text = [self.actionTextView.text substringWithRange:NSMakeRange(0, 20)];
        }
    }
    else {
        self.placeholderLabel.hidden = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
