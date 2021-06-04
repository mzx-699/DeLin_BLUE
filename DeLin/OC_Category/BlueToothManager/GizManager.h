//
//  GizManager.h
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 数据点标识符
#define Data__Attr_Stop @"Stop"
#define Data__Attr_Home @"Home"
#define Data__Attr_workingArea @"workingArea"
#define Data__Attr_Language @"Language"
#define Data__Attr_WorkingTime @"WorkingTime"
#define Data__Attr_CurrentTime @"CurrentTime"
#define Data__Attr_PIN @"PIN"
#define Data__Attr_Power @"Power"
#define Data__Attr_Error @"Error"
#define Data__Attr_RobotState @"RobotState"

// 标识各个数据点的枚举值
typedef enum
{
    Device_Stop,
    Device_Home,
    Device_workingArea,
    Device_Language,
    Device_WorkingTime,
    Device_CurrentTime,
    Device_PIN,
    Device_Power,
    Device_Error,
    Device_RobotState,
}DeviceDataPoint;

@interface GizManager : NSObject <GizWifiDeviceDelegate>
///单例模式
+ (instancetype)shareInstance;

///@brief 获取当前Wi-Fi的ssid
+ (NSString *)getCurrentWifi;

///@brief 机智云登录信息
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) GizWifiDevice *device;
@property (nonatomic, strong) NSString *did;
///@brief 用户个人信息
@property (nonatomic,strong) GizUserInfo *userInfo;
@property (nonatomic, strong) NSString *userName;//用户名称
@property (nonatomic, strong) NSString *userAddress;//用户注册地址
@property (nonatomic, strong) NSString *userRemark;//用户注册免责协议同意

///@brief 配网wifi ssid key
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *key;

// 以下是存储各个数据点值的属性
@property (nonatomic, assign) BOOL key_Stop;
@property (nonatomic, assign) BOOL key_Home;
@property (nonatomic, assign) NSInteger key_workingArea;
@property (nonatomic, assign) NSInteger key_Language;
@property (nonatomic, copy) NSString *key_WorkingTime;
@property (nonatomic, copy) NSString *key_CurrentTime;
@property (nonatomic, copy) NSString *key_PIN;
@property (nonatomic, assign) NSInteger key_Power;
@property (nonatomic, assign) NSInteger key_Error;
@property (nonatomic, assign) NSInteger key_RobotState;

- (void)sendTransparentDataByGizWifiSDK:(NSDictionary *)sendData;
- (void)setGizDevice:(GizWifiDevice *)device;

/**
 *  初始化设备  ，即将设备的值都设为默认值
 */
- (void)initDevice;

/**
 *  写数据点的值到设备
 *
 *  @param dataPoint 标识数据点的枚举值
 *  @param value     数据点值
 */
- (void)writeDataPoint:(DeviceDataPoint)dataPoint value:(id)value;
/**
 *  从数据点集合中获取数据点的值
 *
 *  @param attrStatus 数据点集合
 */
- (void)readDataPointsFromData:(NSDictionary *)attrStatus;



@end

NS_ASSUME_NONNULL_END
