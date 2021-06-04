//
//  BlueToothManager.m
//  BlueTooth测试
//
//  Created by apple on 2021/6/4.
//

#import "BlueToothManager.h"

@interface BlueToothManager ()
@property (nonatomic, strong) BabyBluetooth *baby;
@property (nonatomic, strong) CBCharacteristic *notifyCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@end
@implementation BlueToothManager
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
    }
    return self;
}
- (NSMutableArray *)peripheralArray{
    if (!_peripheralArray) {
        _peripheralArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _peripheralArray;
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
- (void)writeWithData:(NSData *)data {
    [self.connectPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
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
        
        if (![weakSelf.peripheralArray containsObject:peripheral]) {
            [weakSelf.peripheralArray addObject:peripheral];
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
                if ([tempChara.UUID.UUIDString isEqualToString:@"FFF1"]) {
                    weakSelf.notifyCharacteristic = tempChara;
                    NSLog(@"self.notifyCharacteristic : %@", weakSelf.notifyCharacteristic);
                    
                    [weakSelf.baby notify:peripheral characteristic:weakSelf.notifyCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                        NSLog(@"notify %@", characteristics.value);
                        NSLog(@"notify Str %@", [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding]);
                    }];
                }
                else if ([tempChara.UUID.UUIDString isEqualToString:@"FFF2"]) {
                    weakSelf.writeCharacteristic = tempChara;
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
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
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
@end
