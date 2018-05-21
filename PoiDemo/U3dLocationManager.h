//
//  U3dLocationManager.h
//  PoiDemo
//
//  Created by Kai Liu on 2018/5/21.
//  Copyright © 2018年 Kai Liu. All rights reserved.
//  u3d获取手机经纬度及方向角度

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

typedef void(^U3dLocationSuccess) (double lat, double lng);
typedef void(^U3dLocationFailed) (NSError *error);
typedef void(^U3dLocationDirection) (double direction);

@interface U3dLocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *manager;
    U3dLocationSuccess successCallBack;
    U3dLocationFailed failedCallBack;
    U3dLocationDirection directionCallBack;
}

+ (U3dLocationManager *) sharedGpsManager;
+ (void) getU3dLocationWithSuccess:(U3dLocationSuccess)success Failure:(U3dLocationFailed)failure;
+ (void) getU3dDirection:(U3dLocationDirection)direction;
+ (void) stop;


@end
