//
//  KUGPS.h
//  knowU
//
//  Created by HanJiatong on 15/7/4.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface KUGPS : NSObject

/** 坐标改变后的回调
    placeName   获取的地点名称，如果无法反解地点名称，请传nil就好
    coordinate  新的坐标*/
@property (nonatomic, copy) void (^locationBlock)(NSString *placeName, CLLocationCoordinate2D locationCoordinate);

+ (instancetype)manager;
- (void)initLocation;

- (void)startMonitoringSignificantLocationChanges;
- (void)startUpdatingLocation;

- (void)stopMonitoringSignificantLocationChanges;
- (void)stopUpdatingLocation;
@end
