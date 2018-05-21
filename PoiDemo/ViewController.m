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
        
        // 显示label
        self.locationLabel.text = [NSString stringWithFormat:@"纬度 经度 (%f, %f)", lat, lng];
        
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
@end
