//
//  ViewController.m
//  PoiDemo
//
//  Created by Kai Liu on 2018/5/21.
//  Copyright © 2018年 Kai Liu. All rights reserved.
//

#import "ViewController.h"

#import "U3dLocationManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenViewClick:(id)sender
{
    __block  BOOL isOnece = YES;
    [U3dLocationManager getU3dLocationWithSuccess:^(double lat, double lng){
        isOnece = NO;
        //只打印一次经纬度
        NSLog(@"lat lng (%f, %f)", lat, lng);
        
        // 转换度分秒
        NSString *latStr = [self stringWithCoordinateString:lat];
        NSString *lngStr = [self stringWithCoordinateString:lng];
        
        // 显示label
        self.locationLabel.text = [NSString stringWithFormat:@"纬度 经度 (%@, %@)", latStr, lngStr];
        
        if (!isOnece) {
            [U3dLocationManager stop];
        }
    } Failure:^(NSError *error){
        isOnece = NO;
        NSLog(@"error = %@", error);
        if (!isOnece) {
            [U3dLocationManager stop];
        }
    }];
}

- (IBAction)directionClick:(id)sender
{
    __block  BOOL isOnece = YES;
    [U3dLocationManager getU3dDirection:^(double direction) {
        isOnece = NO;
        //只打印一次角度
        NSLog(@"角度 %f", direction);
        
        // 显示label
        self.directionLabel.text = [NSString stringWithFormat:@"角度 %f", direction];
        
        if (!isOnece) {
            [U3dLocationManager stop];
        }
    }];
}

//经纬度转换度分秒
/** 经纬度转换成度分秒格式 */
- (NSString *)stringWithCoordinateString:(double )coordinate
{
    NSString *coordinateString = [NSString stringWithFormat:@"%f", coordinate];
    /** 将经度或纬度整数部分提取出来 */
    int latNumber = [coordinateString intValue];
    
    /** 取出小数点后面两位(为转化成'分'做准备) */
    NSArray *array = [coordinateString componentsSeparatedByString:@"."];
    /** 小数点后面部分 */
    NSString *lastCompnetString = [array lastObject];
    
    /** 拼接字字符串(将字符串转化为0.xxxx形式) */
    NSString *str1 = [NSString stringWithFormat:@"0.%@", lastCompnetString];
    
    /** 将字符串转换成float类型以便计算 */
    float minuteNum = [str1 floatValue];
    
    /** 将小数点后数字转化为'分'(minuteNum * 60) */
    float minuteNum1 = minuteNum * 60;
    
    /** 将转化后的float类型转化为字符串类型 */
    NSString *latStr = [NSString stringWithFormat:@"%f", minuteNum1];
    
    /** 取整数部分即为纬度或经度'分' */
    int latMinute = [latStr intValue];
    
    /** 将经度或纬度字符串合并为(xx°xx')形式 */
    NSString *string = [NSString stringWithFormat:@"%d°%d'", latNumber, latMinute];
    
    return string;
}
@end
