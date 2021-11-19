//
//  BlueToothManager.m
//  BlueTooth测试
//
//  Created by apple on 2021/6/4.
//

#import "BlueToothManager.h"
#import "NetWorkManager.h"

#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"peripheral.data"]
#define kMaxRewriteCount 3

@interface BlueToothManager ()
@property (nonatomic, copy) writeSuccessBlock writeSuccessBlock;
@property (nonatomic, strong) BabyBluetooth *baby;
@property (nonatomic, strong) CBCharacteristic *notifyCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, assign) NSInteger receiveFlag;
@property (nonatomic, strong) NSData *lastData;
@property (nonatomic, assign) NSInteger rewriteCount;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation BlueToothManager
#pragma mark - SecureCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_peripheralNameDict forKey:@"peripheralNameDict"];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _peripheralNameDict = [coder decodeObjectForKey:@"peripheralNameDict"];
    }
    return self;
}
+ (BOOL)supportsSecureCoding {
    return YES;
}
+ (instancetype)sharedBlueToothManger {
    static id instance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baby = [BabyBluetooth shareBabyBluetooth];
        self.receiveFlag = 0;
        self.rewriteCount = 1;
    }
    return self;
}
- (NSMutableDictionary *)peripheralNameDict {
    if (!_peripheralNameDict) {
        _peripheralNameDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return _peripheralNameDict;
}
- (NSMutableArray *)peripheralArray{
    if (!_peripheralArray) {
        _peripheralArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _peripheralArray;
}
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
#pragma mark - 开始扫描
- (void)beginScanf {
    self.baby.scanForPeripherals().begin();
}
- (void)connectBLE: (CBPeripheral *)pp {
    [self.baby cancelScan];
    [self.baby cancelAllPeripheralsConnection];
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    [SVProgressHUD dismissWithDelay:1];
    self.baby.having(pp).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}
#pragma mark - 写
- (void)writeWithData:(NSData *)data andSuccessBlock:(writeSuccessBlock)writeSuccessBlock {
    self.receiveFlag = 0;
    self.rewriteCount = 1;
    NSLog(@"%@", data);
    [self.connectPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    self.writeSuccessBlock = writeSuccessBlock;
    //重发机制
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self rewriteWithData:data];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}
- (void)rewriteWithData:(NSData *)data {
    NSLog(@"rewriteWithData");
    if (self.rewriteCount <= kMaxRewriteCount && self.receiveFlag == 0) {
        [self.connectPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"重发 %@", data);
        NSLog(@"重发第%zd次",self.rewriteCount);
        self.rewriteCount += 1;
    }
    if (self.rewriteCount > kMaxRewriteCount) {
        NSLog(@"已经重发了三次");
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.receiveFlag == 1) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}
#pragma mark - 蓝牙配置
-(void)babyDelegate {
    
    NSLog(@"开始蓝牙配置");
    __weak typeof(self) weakSelf = self;
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (@available(iOS 10.0, *)) {
            if (central.state == CBManagerStatePoweredOn) {
                [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
                [SVProgressHUD dismissWithDelay:1];
            }
        } else {
            // Fallback on earlier versions
        }
        NSLog(@"%@", central);
    }];
    
    //设置扫描到设备的委托
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        if (![weakSelf.peripheralArray containsObject:peripheral]) {;
            [weakSelf.peripheralArray addObject:peripheral];
            
            NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
//            NSString *name = advertisementData[@"kCBAdvDataLocalName"];
            NSLog(@"%@", advertisementData);
            NSLog(@"%@", data);
            NSLog(@"%@", [weakSelf convertHexStrToData:@"0cdf190000000000"]);
            NSLog(@"%@", peripheral);
            if (![[NSFileManager defaultManager] fileExistsAtPath:kFilePath]) {
                [[NSFileManager defaultManager] createFileAtPath:kFilePath contents:nil attributes:nil];
            }
            NSLog(@"%@", kFilePath);
            NSError *error;
            //涉及到的类
            NSSet *set = [NSSet setWithObjects:[NSMutableDictionary class], [NSUUID class], nil];
            if (@available(iOS 11.0, *)) {
                weakSelf.peripheralNameDict = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:[NSData dataWithContentsOfFile:kFilePath] error:&error];
            } else {
                // unarchivedObjectOfClasses:fromData:error:
                weakSelf.peripheralNameDict = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
            }
            NSLog(@"%@", weakSelf.peripheralNameDict);
            if(error)
            {
                NSLog(@"%@", error);
            }

            if(weakSelf.peripheralNameDict[peripheral.identifier] == nil) {
                weakSelf.peripheralNameDict[peripheral.identifier] = peripheral.name;
                if (@available(iOS 11.0, *)) {
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.peripheralNameDict requiringSecureCoding:NO error:nil];

                    [data writeToFile:kFilePath atomically:YES];
                    
                } else {
                    [NSKeyedArchiver archiveRootObject:weakSelf.peripheralNameDict toFile:kFilePath];
                }
            }
            NSLog(@"%@", weakSelf.peripheralNameDict);
            //0x0cc6209000000000
            if ([weakSelf.delegate respondsToSelector:@selector(reloadData)]) {
                [weakSelf.delegate reloadData];
            }
            
        }
        
        NSLog(@"%@", weakSelf.peripheralArray);
        
    }];
    
   //连接成功
    [self.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:@"连接成功"];
        [SVProgressHUD dismissWithDelay:1];
        weakSelf.connectPeripheral = peripheral;
        
    }];
    
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    
    
    //获取读写
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"service name: %@", service);
        NSLog(@"service uuidstring name: %@", service.UUID.UUIDString);
        NSLog(@"%@", service.characteristics);
        if([service.UUID.UUIDString isEqualToString:@"FFF0"]) {
            for (CBCharacteristic * tempChara in service.characteristics) {
                NSLog(@"%@", tempChara);
                if ([tempChara.UUID.UUIDString isEqualToString:@"FFF1"]) {
                    weakSelf.notifyCharacteristic = tempChara;
                    NSLog(@"self.notifyCharacteristic : %@", weakSelf.notifyCharacteristic);
                    
                    [weakSelf.baby notify:peripheral characteristic:weakSelf.notifyCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                        weakSelf.receiveFlag = 1;
                        NSLog(@"notify %@", characteristics.value);
                        NSLog(@"notify Str %@", [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding]);
                        [weakSelf checkOutFrame:characteristics.value];
                    }];
                }
                else if ([tempChara.UUID.UUIDString isEqualToString:@"FFF2"]) {
                    weakSelf.writeCharacteristic = tempChara;
                    if ([weakSelf.delegate respondsToSelector:@selector(updatePinGoContinue)]) {
                        [weakSelf.delegate updatePinGoContinue];
                    }
                    
                    NSLog(@"self.writeCharacteristic : %@", weakSelf.writeCharacteristic);

                }
            }
        }
    }];
    
    //设置查找设备的过滤器
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
//        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
//            return YES;
//        }
//        return NO;
//        NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
//        NSString *name = advertisementData[@"kCBAdvDataLocalName"];
////        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
//        if ([name isEqualToString:@"RM18-600"] && [data isEqualToData:[weakSelf convertHexStrToData:@"0cdf190000000000"]]) {
//            return YES;
//        }
//        if (peripheralName.length > 0) {
//            return YES;
//        }
        if ([peripheralName hasPrefix:@"RM24"] || [peripheralName hasPrefix:@"RM18"]) {
            return YES;
        }
//        if (peripheralName.length >0) {
//            return YES;
//        }
        return NO;
    }];

    [self.baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
//        [SVProgressHUD dismiss];
        if (weakSelf.writeSuccessBlock) {
            weakSelf.writeSuccessBlock();
        }
//        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
//        [SVProgressHUD dismissWithDelay:1.0];
    }];
    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
       
    [self.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    //设置babyOptions
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
    */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
    CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
    CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    //连接设备->
    [self.baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                                  connectPeripheralWithOptions:connectOptions
                                scanForPeripheralsWithServices:nil
                                          discoverWithServices:nil
                                   discoverWithCharacteristics:nil];
    

}

- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
@end
