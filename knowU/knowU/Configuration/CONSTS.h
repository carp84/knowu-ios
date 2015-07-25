//
//  CONSTS.h
//  knowU
//
//  Created by HanJiatong on 15/4/28.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#ifndef knowU_CONSTS_h
#define knowU_CONSTS_h

#define WEAKSELF typeof(self) __weak weakSelf = self;
static const NSTimeInterval TIME_OUT_INTERVAL = 60;

//leancloud的id和key
static NSString *AVAppID = @"kz2851jtfvpgvi3epwg1373fhbnt30gj3zqeju9enqvdz1y4";
static NSString *AVAppKey = @"7d16fp02n6mi36swjf0l12ca7avruoct366s9ln15058dpn9";

#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height

//判断iphone4S

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone5S

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6P放大模式
#define iPhone6PlusZoom ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

//判断系统版本是否大于IOS8
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

#define IMAGE_IPHONE4_BACKGROUND        @"640x960.png"
#define IMAGE_IPHONE5_BACKGROUND        @"640x1136.png"
#define IMAGE_IPHONE6_BACKGROUND        @"750x1334.png"
#define IMAGE_IPHONE6PLUS_BACKGROUND    @"1242x2208.png"

#define IMAGE_REGISTER_MALE_SELECTED    @"注册_男icon_选中"
#define IMAGE_REGISTER_MALE_NORMAL      @"注册_男icon_一般"
#define IMAGE_REGISTER_FEMALE_SELECTED  @"注册_女icon_选中"
#define IMAGE_REGISTER_FRMALE_NORMAL    @"注册_女icon_一般"
#define IMAGE_LOGIN_NORMAL              @"登录_btn_一般"
#define IMAGE_LOGIN_HIGHLIGHTED         @"登录_btn_按下"
#define IMAGE_BACK_NORMAL               @"注册_btn_返回_一般"
#define IMAGE_BACK_HIGHLIGHTED          @"注册_btn_返回_按下"
#define IMAGE_REGISTER_NORMAL           @"注册_btn_一般"
#define IMAGE_REGISTER_HIGHLIGHTED      @"注册_btn_按下"
#define IMAGE_RIGISTER_NO_USE           @"注册_btn_不可用"
#define IMAGE_ALERT_CANCEL_NORMAL       @"取消-一般"
#define IMAGE_ALERT_CANCEL_HIGHLIGHTED  @"取消-anxia"
#define IMAGE_ALERT_CONFIRM_NORMAL      @"确定-一般"
#define IMAGE_ALERT_CONFIRM_HIGHLIGHTED @"确定-anxia"

/*************************************AlertView信息*******************************************/
#define STRING_TIP_TITLE                @"温馨提示"
#define STRING_CONFIRM                  @"确定"

/*************************************填写基本信息*******************************************/
#define STRING_NO_HOME_ADDRESS          @"填写家庭地址才能进入下一步操作哦～～"
#define STRING_NO_COMPANY_ADDRESS       @"填写单位地址才能进入下一步操作哦～～"

/*************************************填写注册信息*******************************************/
#define STRING_NO_USER_NAME             @"赶紧给自己起个好听的昵称吧^_^"
#define STRING_USER_NAME_UNAVAILABLE    @"用户名由数字、字母下划线组成"
#define STRING_NO_MAIL                  @"没有邮箱怎么找回密码呢？赶紧填写吧"
#define STRING_NO_PASSWORD              @"没有密码账户会不安全的"
#define STRING_NO_CONFIRM_PASSWORD      @"两次密码输入不一致哦～～"
#define STRING_PASSWORD_NO_SAME         @"两次输入的密码怎么不一致？修改下试试吧^_^"
#define STRING_VALID_MAIL               @"邮箱好像不对哦"

/*************************************填写详细信息*******************************************/
#define STRING_NO_BIRTHDAY              @"请填写出生日期"
#define STRING_NO_SEX                   @"请选择性别"
#define STRING_NO_CAREER                @"请输入职业"
#define STRING_NO_CELL                  @"请输入电话"
#define IMAGE_POINT                     @"list_icon_jump"
/*************************************主页*******************************************/
#define IMAGE_HOMEPAGE_GIFT_1           @"主页_礼盒_1"
#define IMAGE_HOMEPAGE_GIFT_2           @"主页_礼盒_2"
#define IMAGE_HOMEPAGE_GIFT_3           @"主页_礼盒_3"
#define IMAGE_HOMEPAGE_GIFT_4           @"主页_礼盒_4"
#define STRING_HOMEPAGE_FEED_TITLE      @"最懂你的APP"
#define STRING_HOMEPAGE_HATCH_TITLE     @"惊喜 ・ 还有"
#endif
