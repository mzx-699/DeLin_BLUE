//
//  NetWorkManager.h
//  DeLin
//
//  Created by 安建伟 on 2019/12/21.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    getMainDeviceMsg,
    getHome,
    getStop,
    setCurrentTime,
    getWorkTimeMonToWendes,
    getWorkArea,
    inputPINCode,
    reSetPINCode,
    getStart,
    getWorkTimeThursToSun,
    otherMsgType
}MsgType68;

typedef enum{
    readReplyFrame,
    writeReplyFrame,
    otherFrameType
}FrameType68;

///@brief 接收到的温度帧数量和查询温度帧数量
static int recvCount = 0;
static int sendCount = 0;

///@brief 每个函数重发的次数
static int resendCount = 0;
///@brief 是否获取计时器状态，用来防止多次查询
static BOOL isGetTimerStatus = NO;

///@brief 读取数据数量版本
static NSInteger tempCountVer = 1000;

@interface NetWorkManager : NSObject

@property (nonatomic, strong) dispatch_queue_t queue;
///@brief 线程信号量使用
@property (strong, nonatomic) dispatch_semaphore_t sendSignal;
///@brief 接收数据
@property (nonatomic, strong) NSMutableArray *recivedData68;

///@brief 消息类型
@property (nonatomic, assign) NSTimer *atimeOut;
@property (nonatomic, assign) uint8_t timeOutFlag;

///@brief 消息类型
@property (nonatomic, assign) MsgType68 msg68Type;
///@brief 帧类型
@property (nonatomic, assign) FrameType68 frame68Type;

///@brief 帧计数器
@property (nonatomic, assign) UInt8 frameCount;

- (void)handle68Message:(NSArray *)data;

///@brief 单例模式
+ (instancetype)shareNetWorkManager;
///@brief 销毁单例
+ (void)destroyInstance;

///@brief Frame68帧发送方法
- (void)sendData68With:(UInt8)controlCode data:(NSArray *)data failuer:(nullable void(^)(void))failure andSuccessBlock:(writeSuccessBlock)writeSuccessBlock;

@end

NS_ASSUME_NONNULL_END
