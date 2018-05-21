//
//  U3dLocationManager.m
//  PoiDemo
//
//  Created by Kai Liu on 2018/5/21.
//  Copyright © 2018年 Kai Liu. All rights reserved.
//

#import "U3dLocationManager.h"

#import <UIKit/UIKit.h>

@implementation U3dLocationManager

+ (U3dLocationManager *) sharedGpsManager
{
    static U3dLocationManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[U3dLocationManager alloc] init];
    });
    return shared;
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // 打开定位 然后得到数据
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        //控制定位精度,越高耗电量越
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 兼容iOS8.0版本
        /* Info.plist里面加上2项
         NSLocationAlwaysUsageDescription Boolean YES
         NSLocationWhenInUseUsageDescription Boolean YES
         */
        
        // 请求授权 requestWhenInUseAuthorization用在>=iOS8.0上
        // respondsToSelector: 前面manager是否有后面requestWhenInUseAuthorization方法
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
    
    }
    return self;
    
}

- (void) getU3dLocationWithSuccess:(U3dLocationSuccess)success Failure:(U3dLocationFailed)failure
{
    successCallBack = [success copy];
    failedCallBack = [failure copy];
    // 停止上一次的
    [manager stopUpdatingLocation];
    // 开始新的数据定位
    [manager startUpdatingLocation];
    
}

+ (void) getU3dLocationWithSuccess:(U3dLocationSuccess)success Failure:(U3dLocationFailed)failure
{
    [[U3dLocationManager sharedGpsManager] getU3dLocationWithSuccess:success Failure:failure];
    
}

- (void) getU3dDirection:(U3dLocationDirection)direction
{
    // 停止上一次的
    [manager stopUpdatingHeading];
    // 开始新的数据定位
    [manager startUpdatingHeading];
    directionCallBack = [direction copy];
}

+ (void) getU3dDirection:(U3dLocationDirection)direction
{
    
    [[U3dLocationManager sharedGpsManager] getU3dDirection:direction];
}

- (void) stop {
    [manager stopUpdatingLocation];
    [manager stopUpdatingHeading];
}

+ (void) stop {
    [[U3dLocationManager sharedGpsManager] stop];
}

// 每隔一段时间就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    for (CLLocation *loc in locations) {
        CLLocationCoordinate2D l = loc.coordinate;
        double lat = l.latitude;
        double lnt = l.longitude;
        
        successCallBack ? successCallBack(lat, lnt) : nil;
    }
    
}

// 定位方向
- (void)locationManager:(CLLocationManager *)manager  didUpdateHeading:(CLHeading *)newHeading
{
    //如果当前设备的朝向信息不可用，直接返回
    if (newHeading.headingAccuracy<0) return;
    
    //获取设备的朝向角度
    CLLocationDirection direction = newHeading.magneticHeading;
    directionCallBack ? directionCallBack(direction) : nil;
    
}

//失败代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    failedCallBack ? failedCallBack(error) : nil;
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

@end
