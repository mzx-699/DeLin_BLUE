//
//  GizManager.m
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "GizManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>

static GizManager *_gizManager = nil;

@implementation GizManager

+ (instancetype)shareInstance{
    if (_gizManager == nil) {
        _gizManager = [[self alloc] init];
    }
    return _gizManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        if (_gizManager == nil) {
            _gizManager = [super allocWithZone:zone];
        }
    });
    
    return _gizManager;
}

#pragma mark - set
- (void)setGizDevice:(GizWifiDevice *)device{
    if (self.device) {
        self.device.delegate = nil;
    }
    self.device = device;
    self.device.delegate = self;
    if (self.device.isSubscribed) {
        return;
    }
    [self.device setSubscribe:NULL subscribed:YES];
}

#pragma mark - Giz Control
- (void)sendTransparentDataByGizWifiSDK:(NSDictionary *)sendData{
    if (!self.device) {
        return;
    }
    NSLog(@"发送透传数据---%@",sendData);
    [self.device write:sendData withSN:100];
}

/**
 *  写数据点的值到设备
 *
 *  @param dataPoint 标识数据点的枚举值
 *  @param value     数据点值
 */
- (void)writeDataPoint:(DeviceDataPoint)dataPoint value:(id)value
{
    NSDictionary *data = nil;
    switch (dataPoint) {
        case Device_Stop:
        {
            self.key_Stop = [value boolValue];
            data = @{Data__Attr_Stop: value};
            break;
        }
        case Device_Home:
        {
            self.key_Home = [value boolValue];
            data = @{Data__Attr_Home: value};
            break;
        }
        case Device_workingArea:
        {
            self.key_workingArea = [value integerValue];
            data = @{Data__Attr_workingArea: value};
            break;
        }
        case Device_Language:
        {
            self.key_Language = [value integerValue];
            data = @{Data__Attr_Language: value};
            break;
        }
        case Device_WorkingTime:
        {
            self.key_WorkingTime = value;
            data = @{Data__Attr_WorkingTime: [self.key_WorkingTime hexToBytes]};
            break;
        }
        case Device_CurrentTime:
        {
            self.key_CurrentTime = value;
            data = @{Data__Attr_CurrentTime: [self.key_CurrentTime hexToBytes]};
            break;
        }
        case Device_PIN:
        {
            self.key_PIN = value;
            data = @{Data__Attr_PIN: [self.key_PIN hexToBytes]};
            break;
        }
        default:
            NSLog(@"Error: write invalid datapoint, skip.");
            return;
    }
    NSLog(@"数据点发送Write data: %@", data);
    [self.device write:data withSN:0];
}

#pragma mark - read Action
/**
 *  从数据点集合中获取数据点的值
 *
 *  @param dataMap 数据点集合
 */
- (void)readDataPointsFromData:(NSDictionary *)dataMap
{
    // 读取普通数据点的值
    NSDictionary *data = [dataMap valueForKey:@"data"];
    [self readDataPoint:Device_Stop data:data];
    [self readDataPoint:Device_Home data:data];
    [self readDataPoint:Device_workingArea data:data];
    [self readDataPoint:Device_Language data:data];
    [self readDataPoint:Device_WorkingTime data:data];
    [self readDataPoint:Device_CurrentTime data:data];
    [self readDataPoint:Device_PIN data:data];
    [self readDataPoint:Device_Power data:data];
    [self readDataPoint:Device_Error data:data];
    [self readDataPoint:Device_RobotState data:data];
    
}


/**
 *  获取普通数据点的各个数据点值
 *
 *  @param data 普通数据点集合
 */
- (void)readDataPoint:(DeviceDataPoint)dataPoint data:(NSDictionary *)data
{
    if(![data isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return;
    }
    switch (dataPoint) {
        case Device_Stop:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_Stop];
            self.key_Stop = dataPointStr.boolValue;
            break;
        }
        case Device_Home:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_Home];
            self.key_Home = dataPointStr.boolValue;
            break;
        }
        case Device_workingArea:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_workingArea];
            self.key_workingArea = dataPointStr.integerValue;
            break;
        }
        case Device_Language:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_Language];
            self.key_Language = dataPointStr.integerValue;
            break;
        }
        case Device_WorkingTime:
        {
            NSData *dataPointStr = [data valueForKey:Data__Attr_WorkingTime];
            self.key_WorkingTime = [NSString hexStrByData:dataPointStr];
            break;
        }
        case Device_CurrentTime:
        {
            NSData *dataPointStr = [data valueForKey:Data__Attr_CurrentTime];
            self.key_CurrentTime = [NSString hexStrByData:dataPointStr];
            break;
        }
        case Device_PIN:
        {
            NSData *dataPointStr = [data valueForKey:Data__Attr_PIN];
            self.key_PIN = [NSString hexStrByData:dataPointStr];
            break;
        }
        case Device_Power:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_Power];
            self.key_Power = dataPointStr.integerValue;
            break;
        }
        case Device_Error:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_Error];
            self.key_Error = dataPointStr.integerValue;
            break;
        }
        case Device_RobotState:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_RobotState];
            self.key_RobotState = dataPointStr.integerValue;
            break;
        }
        default:
            NSLog(@"Error: read invalid datapoint, skip.");
            break;
    }
}

/**
 *  初始化设备  ，即将设备的值都设为默认值
 */
- (void)initDevice
{
    // 重新设置设备
    self.key_Stop = NO;
    self.key_Home = NO;
    self.key_workingArea = 0;
    self.key_Language = 0;
    self.key_WorkingTime = @"";
    self.key_CurrentTime = @"";
    self.key_PIN = @"";
    self.key_Power = 0;
    self.key_Error = 0;
    self.key_RobotState = 0;
}

#pragma mark - Giz delegate
- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed{
    NSLog(@"subscribeResult---- %@",result);
}

- (void)device:(GizWifiDevice *)device didReceiveAttrStatus:(NSError *)result attrStatus:(NSDictionary *)attrStatus adapterAttrStatus:(NSDictionary *)adapterAttrStatus withSN:(NSNumber *)sn{
    if (result.code == GIZ_SDK_SUCCESS) {
        
        NSDictionary *dataPoints = [attrStatus valueForKey:@"data"];
        
        //接收透传数据 进行解析
        NSData *data = [attrStatus objectForKey:@"binary"];
        [self checkOutFrame:data];
        
        NSLog(@"查询上报的信息。。。数据点:%@ 透传:%@",dataPoints,data);
        if(dataPoints != nil && [dataPoints count] != 0)
        {
            // 读取所有数据点值
            [[GizManager shareInstance] readDataPointsFromData:attrStatus];
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"sendCustomEventNotification" object:nil userInfo:data];
        
    }else{
        NSLog(@"result---- %@",result);
        if (result.code ==GIZ_SDK_REQUEST_TIMEOUT) {
            [NSObject showHudTipStr2:LocalString(@"time out")];
        }
    }
}

//将NSdata数据转化为数组再解析
- (void)checkOutFrame:(NSData *)data{
    
    //把读到的数据复制一份
    NSData *recvBuffer = [NSData dataWithData:data];
    NSUInteger recvLen = [recvBuffer length];
    NSLog(@"收到一条帧： %@",data);
    UInt8 *recv = (UInt8 *)[recvBuffer bytes];
    if (recvLen > 1000) {
        return;
    }
    //把接收到的数据存放在recvData数组中
    NSMutableArray *recvData = [[NSMutableArray alloc] init];
    NSUInteger j = 0;
    while (j < recvLen) {
        [recvData addObject:[NSNumber numberWithUnsignedChar:recv[j]]];
        j++;
    }
    [[NetWorkManager shareNetWorkManager] handle68Message:recvData];
    
}

#pragma 获取设备当前连接的WIFI的SSID
+ (NSString *)getCurrentWifi{
    
    NSString * wifiName = @"";
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        wifiName = @"";
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    //CFRelease(wifiInterfaces);
    return wifiName;
}

@end
