//
//  BlueToothManager.h
//  BlueTooth测试
//
//  Created by apple on 2021/6/4.
//

#import <Foundation/Foundation.h>
#import <BabyBluetooth/BabyBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <SVProgressHUD.h>

typedef void (^writeSuccessBlock)(void);
NS_ASSUME_NONNULL_BEGIN
@protocol BlueToothManagerDelegate <NSObject>
@optional
- (void)reloadData;
- (void)updatePinGoContinue;
@end

@interface BlueToothManager : NSObject <NSSecureCoding>
@property (nonatomic, strong) CBPeripheral *connectPeripheral;
@property (nonatomic, strong) NSMutableArray *peripheralArray;
@property (nonatomic, strong) NSMutableDictionary *peripheralNameDict;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id<BlueToothManagerDelegate> delegate;
+ (instancetype)sharedBlueToothManger;
- (void)babyDelegate;
- (void)beginScanf;
- (void)writeWithData:(NSData *)data andSuccessBlock:(writeSuccessBlock)writeSuccessBlock;
- (void)connectBLE: (CBPeripheral *)pp;
@end

NS_ASSUME_NONNULL_END
