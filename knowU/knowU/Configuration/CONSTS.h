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
#define IMAGE_IPHONE4_BACKGROUND       @"640x960.png"
#define IMAGE_IPHONE5_BACKGROUND       @"640x1136.png"
#define IMAGE_IPHONE6_BACKGROUND       @"750x1334.png"
#define IMAGE_IPHONE6PLUS_BACKGROUND   @"1242x2208.png"

#define IMAGE_REGISTER_MALE_SELECTED   @"注册_男icon_选中"
#define IMAGE_REGISTER_MALE_NORMAL     @"注册_男icon_一般"
#define IMAGE_REGISTER_FEMALE_SELECTED @"注册_女icon_选中"
#define IMAGE_REGISTER_FRMALE_NORMAL   @"注册_女icon_一般"

/*************************************AlertView信息*******************************************/
#define STRING_TIP_TITLE               @"温馨提示"
#define STRING_CONFIRM                 @"确定"

/*************************************填写基本信息*******************************************/
#define STRING_NO_HOME_ADDRESS         @"填写家庭地址才能进入下一步操作哦～～"
#define STRING_NO_COMPANY_ADDRESS      @"填写单位地址才能进入下一步操作哦～～"

/*************************************填写注册信息*******************************************/
#define STRING_NO_USER_NAME            @"赶紧给自己起个好听的昵称吧^_^"
#define STRING_NO_MAIL                 @"没有邮箱怎么找回密码呢？赶紧填写吧"
#define STRING_NO_PASSWORD             @"没有密码账户会不安全的"
#define STRING_NO_CONFIRM_PASSWORD     @"两次密码输入不一致哦～～"
#define STRING_PASSWORD_NO_SAME        @"两次输入的密码怎么不一致？修改下试试吧^_^"

/*************************************填写详细信息*******************************************/
#define STRING_NO_BIRTHDAY             @"请填写出生日期"
#define STRING_NO_SEX                  @"请选择性别"
#define STRING_NO_CAREER               @"请输入职业"
#define STRING_NO_CELL                 @"请输入电话"
#endif
