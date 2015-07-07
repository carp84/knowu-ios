//
//  AppDelegate.m
//  knowU
//
//  Created by HanJiatong on 15/4/26.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworking.h>
#import "CONSTS.h"
#import "KUGPS.h"
@interface AppDelegate ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setMinimumBackgroundFetchInterval: UIApplicationBackgroundFetchIntervalMinimum];
    [application beginBackgroundTaskWithExpirationHandler:^{

    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [[KUGPS manager] stopUpdatingLocation];
//    [[KUGPS manager] startMonitoringSignificantLocationChanges];
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 * 5 target:self selector:@selector(updateLocation:) userInfo:nil repeats:YES];
    [self.timer fire];
    
}

- (void)updateLocation:(NSTimer *)timer{
    NSLog(@"updateLocation");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KUPerformFetchNotification" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[KUGPS manager] stopMonitoringSignificantLocationChanges];
//    [[KUGPS manager] startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"performFetchWithCompletionHandler %@", completionHandler);
//    [[NSNotificationCenter defaultCenter] postNotificationName:KUPerformFetchNotification object:nil];
}

@end
