//
//  DevicePlatInfo.m
//  card
//
//  Created by HanJiatong on 15/2/21.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "DevicePlatInfo.h"
#import "CONSTS.h"
@implementation DevicePlatInfo

+ (NSString *)deviceName{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (CGFloat)devicePlatform{
    if ([[self deviceName] isEqualToString:@"iPhone5,1"] || [[self deviceName] isEqualToString:@"iPhone5,2"] || [[self deviceName] isEqualToString:@"iPhone5,3"] || [[self deviceName] isEqualToString:@"iPhone5,4"] || [[self deviceName] isEqualToString:@"iPhone6,1"] || [[self deviceName] isEqualToString:@"iPhone6,2"]) {
        return 4;
    }
    else if ([[self deviceName] isEqualToString:@"iPhone7,1"]) {
        return 5.5;
    }
    else if ([[self deviceName] isEqualToString:@"iPhone7,2"]) {
        return 4.7;
    }
    else{
        return 3.5;
    }
}

@end
