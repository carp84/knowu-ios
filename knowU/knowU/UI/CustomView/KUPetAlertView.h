//
//  KUPetAlertView.h
//  knowU
//
//  Created by HanJiatong on 15/5/18.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KUAlertType) {
    KULocationAlertType = 1,   //1表示输入的是地点，2表示喂养
    KUFeedAlertType
};

@interface KUPetAlertView : UIView

@property (nonatomic, copy) void (^inputBlock)(NSString *location);

- (void)showWithType:(KUAlertType)type image:(UIImage *)image;

@end
