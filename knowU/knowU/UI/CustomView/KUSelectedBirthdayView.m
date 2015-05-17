//
//  KUSelectedBirthdayView.m
//  knowU
//
//  Created by HanJiatong on 15/5/15.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUSelectedBirthdayView.h"
#import "UIColor+Addition.h"
#import "NSDate+Addition.h"
#import "Masonry.h"
@interface KUSelectedBirthdayView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *selectedView;

@end

@implementation KUSelectedBirthdayView

- (void)awakeFromNib{
    self.picker.backgroundColor = [UIColor whiteColor];
}

//- (instancetype) 

- (IBAction)cancel:(UIButton *)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.alpha = 0;
        self.blackView.backgroundColor = [UIColor ColorFromRGB:0 alpha:0];
        [self.selectedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
        }];
        [self.selectedView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}
- (IBAction)confirm:(UIButton *)sender {
    if (self.selectedBirthdayBlock) {
        self.selectedBirthdayBlock([self.picker.date convertString]);
    }
    [self cancel:sender];
}

- (void)show {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        self.blackView.backgroundColor = [UIColor ColorFromRGB:0 alpha:0.6];
        [self.selectedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).with.offset(-202);
        }];
        [self.selectedView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
