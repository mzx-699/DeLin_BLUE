//
//  netWorkManagerManager.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/21.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "NetWorkManager.h"
#import <netdb.h>

///@brife 可判断的数据帧类型数量
#define LEN 9

static dispatch_once_t oneToken;

static NetWorkManager *_netWorkManager = nil;
static dispatch_once_t oneToken;


//用来判断手机与设备是否有信息交互的心跳，有交互后重新清零，心跳达到60就发送心跳帧
static int noUserInteractionHeartbeat = 0;

@implementation NetWorkManager
{
    UInt8 _frameCount; //帧计数器
    
    NSTimeInterval btimeFrame;//接收时间
    
    dispatch_queue_t _queue;//设备通信线程
    
    dispatch_semaphore_t _sendSignal;//设备通信锁
    
    dispatch_source_t _noUserInteractionHeartbeatTimer;//心跳时钟
    
    //测试用代码
    dispatch_source_t _testSendTimer;//测试时钟
}

+ (instancetype)shareNetWorkManager{
    if (_netWorkManager == nil) {
        _netWorkManager = [[self alloc] init];
    }
    return _netWorkManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    dispatch_once(&oneToken, ^{
        if (_netWorkManager == nil) {
            _netWorkManager = [super allocWithZone:zone];
        }
    });
    return _netWorkManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _queue = dispatch_queue_create("com.thingcom.queue", DISPATCH_QUEUE_SERIAL);
        if (!_recivedData68) {
            _recivedData68 = [[NSMutableArray alloc] init];
        }
        _frameCount = 0;
        _timeOutFlag = 0;
        
        _atimeOut = [NSTimer scheduledTimerWithTimeInterval:5000 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
        [_atimeOut setFireDate:[NSDate distantFuture]];
    }
    return self;
}

+ (void)destroyInstance{
    _netWorkManager = nil;
    oneToken = 0l;
}

- (void)dealloc{
    [_atimeOut setFireDate:[NSDate distantFuture]];
    [_atimeOut invalidate];
    _atimeOut = nil;
}
//超时提醒
- (void)timeOut{
    if (_timeOutFlag == 1) {
        _timeOutFlag = 0;
        [SVProgressHUD dismiss];
        [NSObject showHudTipStr2:LocalString(@"time out")];
        [_atimeOut setFireDate:[NSDate distantFuture]];
    }
    
    
}
#pragma mark - 帧的发送

//帧的发送
- (void)send:(NSMutableArray *)msg withTag:(NSUInteger)tag
{
//    if ([GizManager shareInstance].device.netStatus == GizDeviceControlled)
//    {
//        NSUInteger len = msg.count;
//        UInt8 sendBuffer[len];
//        for (int i = 0; i < len; i++)
//        {
//            sendBuffer[i] = [[msg objectAtIndex:i] unsignedCharValue];
//        }
//
//        NSData *sendData = [NSData dataWithBytes:sendBuffer length:len];
//        NSLog(@"发送一条帧： %@",sendData);
//        _frameCount++;
//        //透传至机智云
//        NSDictionary *transparentData = @{@"binary":sendData};
//        [[GizManager shareInstance] sendTransparentDataByGizWifiSDK:transparentData];
//    }
//    else
//    {
//        NSLog(@"wifi未连接");
//    }
    NSUInteger len = msg.count;
    UInt8 sendBuffer[len];
    for (int i = 0; i < len; i++)
    {
        sendBuffer[i] = [[msg objectAtIndex:i] unsignedCharValue];
    }
    
    NSData *sendData = [NSData dataWithBytes:sendBuffer length:len];
    NSLog(@"发送一条帧： %@",sendData);
    _frameCount++;
    //透传至机智云
    NSDictionary *transparentData = @{@"binary":sendData};
    [[GizManager shareInstance] sendTransparentDataByGizWifiSDK:transparentData];
}

/*
 *发送帧组成模版
 */
- (void)sendData68With:(UInt8)controlCode data:(NSArray *)data failuer:(nullable void(^)(void))failure{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(self->_queue, ^{
            
            noUserInteractionHeartbeat = 0;//心跳清零
            
            NSMutableArray *data68 = [[NSMutableArray alloc] init];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x68]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:controlCode]];
            
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            
            [data68 addObject:[NSNumber numberWithInt:self->_frameCount]];
            [data68 addObject:[NSNumber numberWithInteger:data.count]];
            [data68 addObjectsFromArray:data];
            [data68 addObject:[NSNumber numberWithUnsignedChar:[NSObject getCS:data68]]];
            [data68 addObject:[NSNumber numberWithUnsignedChar:0x16]];
            
            [self send:data68 withTag:100];//机智云发送
            
        });
    });
}


#pragma mark - Frame68 接收处理

- (void)handle68Message:(NSArray *)data
{
    //68帧格式判断
    if (![self frameIsRight:data])
    {
        //68帧数据错误
        return;
    }
    if (_recivedData68)
    {
        [_recivedData68 removeAllObjects];
        [_recivedData68 addObjectsFromArray:data];
        self.msg68Type = [self checkOutMsgType:data];
        self.frame68Type = [self checkOutFrameType:data];
        /*
         getMainDeviceMsg.... 0x00 获取主界面基本信息
         getHome.... 0x01 设置Home
         getStop,.... 0x02 设置Stop
         setCurrentTime,.... 0x03 设置机器当前时间
         getWorkTime,.... 0x04 设置割草机工作时间
         getWorkArea,.... 0x05 设置割草机工作面积
         inputPINCode,.... 0x06 APP输入割草机PIN码
         reSetPINCode,.... 0x07 修改割草机PIN码
         getStart,.... 0x08 读取割草机语言
         otherMsgType.... 0x09 获取主界面基本信息
         */
        switch (self.frame68Type) {
            case readReplyFrame:
            {
                /*[_recivedData68[12].... 电量
                 [_recivedData68[13].... 机器状态
                 [_recivedData68[14].... 故障信息
                 [_recivedData68[15]，[_recivedData68[16].... 下一次割草时间
                 [_recivedData68[17] [_recivedData68[18].... 割草面积
                 */
                if (self.msg68Type == getMainDeviceMsg) {
                    
                    resendCount = 0;
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
                    NSNumber *robotPower = _recivedData68[12];
                    NSNumber *robotState = _recivedData68[13];
                    NSNumber *robotError = _recivedData68[14];
                    NSNumber *nextWorkHour = [NSNumber numberWithInt:[_recivedData68[15] intValue]];
                    NSNumber *nextWorkMinute = [NSNumber numberWithInt:[_recivedData68[16] intValue]];
                    
                    NSNumber *nextWorkarea = [NSNumber numberWithInt:[_recivedData68[17] intValue] * 256 + [_recivedData68[18] intValue]];
                    NSNumber *rainAlert = _recivedData68[19];
                    NSNumber *deviceType = _recivedData68[20];
                    NSNumber *robotF_Error = _recivedData68[21];
                    
                    [dataDic setObject:robotPower forKey:@"robotPower"];
                    [dataDic setObject:robotState forKey:@"robotState"];
                    [dataDic setObject:robotError forKey:@"robotError"];
                    [dataDic setObject:nextWorkHour forKey:@"nextWorkHour"];
                    [dataDic setObject:nextWorkMinute forKey:@"nextWorkMinute"];
                    [dataDic setObject:nextWorkarea forKey:@"nextWorkarea"];
                    [dataDic setObject:rainAlert forKey:@"rainAlert"];
                    [dataDic setObject:deviceType forKey:@"deviceType"];
                    [dataDic setObject:robotF_Error forKey:@"robotF_Error"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getMainDeviceMsg" object:nil userInfo:dataDic];
                    
                }else if (self.msg68Type == getWorkTime){
                    
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                    NSNumber *monHour = _recivedData68[12];
                    NSNumber *tueHour = _recivedData68[13];
                    NSNumber *wedHour = _recivedData68[14];
                    NSNumber *thuHour = _recivedData68[15];
                    NSNumber *friHour = _recivedData68[16];
                    NSNumber *satHour = _recivedData68[17];
                    NSNumber *sunHour = _recivedData68[18];
                    NSNumber *monMinute = _recivedData68[19];
                    NSNumber *tueMinute = _recivedData68[20];
                    NSNumber *wedMinute = _recivedData68[21];
                    NSNumber *thuMinute = _recivedData68[22];
                    NSNumber *friMinute = _recivedData68[23];
                    NSNumber *satMinute = _recivedData68[24];
                    NSNumber *sunMinute = _recivedData68[25];
                    NSNumber *monState = _recivedData68[26];
                    NSNumber *tueState = _recivedData68[27];
                    NSNumber *wedState = _recivedData68[28];
                    NSNumber *thuState = _recivedData68[29];
                    NSNumber *friState = _recivedData68[30];
                    NSNumber *satState = _recivedData68[31];
                    NSNumber *sunState = _recivedData68[32];
                    [dataDic setObject:monHour forKey:@"monHour"];
                    [dataDic setObject:tueHour forKey:@"tueHour"];
                    [dataDic setObject:wedHour forKey:@"wedHour"];
                    [dataDic setObject:thuHour forKey:@"thuHour"];
                    [dataDic setObject:friHour forKey:@"friHour"];
                    [dataDic setObject:satHour forKey:@"satHour"];
                    [dataDic setObject:sunHour forKey:@"sunHour"];
                    [dataDic setObject:monMinute forKey:@"monMinute"];
                    [dataDic setObject:tueMinute forKey:@"tueMinute"];
                    [dataDic setObject:wedMinute forKey:@"wedMinute"];
                    [dataDic setObject:thuMinute forKey:@"thuMinute"];
                    [dataDic setObject:friMinute forKey:@"friMinute"];
                    [dataDic setObject:satMinute forKey:@"satMinute"];
                    [dataDic setObject:sunMinute forKey:@"sunMinute"];
                    [dataDic setObject:monState forKey:@"monState"];
                    [dataDic setObject:tueState forKey:@"tueState"];
                    [dataDic setObject:wedState forKey:@"wedState"];
                    [dataDic setObject:thuState forKey:@"thuState"];
                    [dataDic setObject:friState forKey:@"friState"];
                    [dataDic setObject:satState forKey:@"satState"];
                    [dataDic setObject:sunState forKey:@"sunState"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recieveWorkingTime" object:nil userInfo:dataDic];
                    
                }else if (self.msg68Type == getWorkArea){
                    
                    NSNumber *workArea = [NSNumber numberWithInt:[_recivedData68[12] intValue] * 256 + [_recivedData68[13] intValue]];
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                    [dataDic setObject:workArea forKey:@"workArea"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recieveWorkArea" object:nil userInfo:dataDic];
                    
                }
                
            }
                break;
            case writeReplyFrame:
            {
                //移除通知
                [SVProgressHUD dismiss];
                [_atimeOut setFireDate:[NSDate distantFuture]];
                
                if (self.msg68Type == getHome){
                    resendCount = 0;
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"success")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getHome" object:nil userInfo:nil];
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                }else if (self.msg68Type == getStop){
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"success")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getStop" object:nil userInfo:nil];
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                }else if (self.msg68Type == setCurrentTime){
                    resendCount = 0;
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        //[NSObject showHudTipStr:LocalString(@"success")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCurrentTime" object:nil userInfo:nil];
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                }else if (self.msg68Type == getWorkTime){
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"success")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getWorkTime" object:nil userInfo:nil];
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                }else if (self.msg68Type == getWorkArea){
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"success")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setWorkArea" object:nil userInfo:nil];
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                    
                }else if (self.msg68Type == inputPINCode){
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"inputPINCode" object:nil userInfo:nil];
                    }
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                }else if (self.msg68Type == reSetPINCode){
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"success")];
                    }
                    if ([_recivedData68[12] unsignedIntegerValue] == 2) {
                        [NSObject showHudTipStr:LocalString(@"Error password")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetPINCode" object:nil userInfo:nil];
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                }else if (self.msg68Type == getStart){
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 0) {
                        [NSObject showHudTipStr:LocalString(@"fail")];
                    }
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"success")];
                    }
                    //标准位 置0
                    _timeOutFlag = 0;
                    [_atimeOut setFireDate:[NSDate distantFuture]];
                    
                }
                
            }
                break;
                
            default:
                break;
                
        }
        
        
    }
    
}

-(BOOL)frameIsRight:(NSArray *)data
{
    if (data != nil && ![data isKindOfClass:[NSNull class]] && data.count >= 3) {
        
        NSUInteger count = data.count;
        UInt8 front1 = [data[0] unsignedCharValue];
        UInt8 front2 = [data[1] unsignedCharValue];
        UInt8 end3 = [data[count-1] unsignedCharValue];
        
        if (front1 != 0x68 || front2 != 0x81 || end3 != 0x16) {
            NSLog(@"帧头帧尾错误");
            return NO;
        }
        
        //判断cs位
//        UInt8 csTemp = 0x00;
//        for (int i = 0; i < count - 2; i++)
//        {
//            csTemp += [data[i] unsignedCharValue];
//        }
//        if (csTemp != [data[count-2] unsignedCharValue])
//        {
//            NSLog(@"校验错误");
//            return NO;
//        }
    }else{
        return NO;
    }
    
    return YES;
}

//判断是什么信息
- (MsgType68)checkOutMsgType:(NSArray *)data{
    unsigned char dataType;
    
    unsigned char type[LEN] = {
        0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x09
    };
    /*
     getMainDeviceMsg.... 0x00 获取主界面基本信息
     getHome.... 0x01 设置Home
     getStop,.... 0x02 设置Stop
     setCurrentTime,.... 0x03 设置机器当前时间
     getWorkTime,.... 0x04 设置割草机工作时间
     getWorkArea,.... 0x05 设置割草机工作面积
     inputPINCode,.... 0x06 APP输入割草机PIN码
     reSetPINCode,.... 0x07 修改割草机PIN码
     getStart,.... 0x09 启动割草机
     otherMsgType....
     */
    dataType = [data[10] unsignedIntegerValue];
    //NSLog(@"%d",dataType);
    
    MsgType68 returnVal = otherMsgType;
    
    for (int i = 0; i < LEN; i++) {
        if (dataType == type[i]) {
            switch (i) {
                case 0:
                    returnVal = getMainDeviceMsg;
                    break;
                    
                case 1:
                    returnVal = getHome;
                    break;
                    
                case 2:
                    returnVal = getStop;
                    break;
                    
                case 3:
                    returnVal = setCurrentTime;
                    break;
                    
                case 4:
                    returnVal = getWorkTime;
                    break;
                    
                case 5:
                    returnVal = getWorkArea;
                    break;
                    
                case 6:
                    returnVal = inputPINCode;
                    break;
                    
                case 7:
                    returnVal = reSetPINCode;
                    break;
                    
                case 8:
                    returnVal = getStart;
                    break;
                    
                default:
                    returnVal = otherMsgType;
                    break;
            }
        }
    }
    return returnVal;
}

//判断是命令帧还是回复帧
- (FrameType68)checkOutFrameType:(NSArray *)data{
    unsigned char dataType;
    
    unsigned char type[2] = {
        0x00,0x01
    };
    //命令标识
    dataType = [data[11] unsignedIntegerValue];
    //NSLog(@"%d",dataType);
    
    FrameType68 returnVal = otherFrameType;
    
    for (int i = 0; i < 2; i++) {
        if (dataType == type[i]) {
            switch (i) {
                case 0:
                    returnVal = readReplyFrame;
                    break;
                    
                case 1:
                    returnVal = writeReplyFrame;
                    break;
                    
                default:
                    returnVal = otherFrameType;
                    break;
            }
        }
    }
    return returnVal;
}


@end
