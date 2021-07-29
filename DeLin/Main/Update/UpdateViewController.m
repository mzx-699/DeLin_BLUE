//
//  UpdateViewController.m
//  DeLin
//
//  Created by apple on 2021/7/29.
//  Copyright © 2021 com.thingcom. All rights reserved.
//

#import "UpdateViewController.h"
#import "BlueToothManager.h"
#import "NetWorkManager.h"
#import "UpdateView.h"
#import "UpdateSuccessViewController.h"
@interface UpdateViewController ()

@property (nonatomic, assign) NSUInteger totalFrameCount;
@property (nonatomic, strong) UILabel *processLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSNumber *updateObject;
@property (nonatomic, strong) NSNumber *updateModel;
@property (nonatomic, strong) NSArray *updateFileArr;
@property (nonatomic, strong) NSString *updateFileName;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Update";
    [self setupUI];
    [NetWorkManager shareNetWorkManager].updateFrameCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFirstUpdateFrame) name:@"sendFirstUpdateFrame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOtherUpdateFrame) name:@"sendOtherUpdateFrame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendUpdateEndFrame) name:@"sendUpdateEndFrame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSuccess) name:@"updateSuccess" object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self mainBtnClick];
    });
}

#pragma mark - 测试更新
//- (void)test {
//    if ([NetWorkManager shareNetWorkManager].updateFrameCount == 0) {
//        [self sendFirstUpdateFrame];
//        NSLog(@"[NetWorkManager shareNetWorkManager].updateFrameCount ----- %zd", [NetWorkManager shareNetWorkManager].updateFrameCount);
//        [NetWorkManager shareNetWorkManager].updateFrameCount = [NetWorkManager shareNetWorkManager].updateFrameCount + 1;
//
//    } else if ([NetWorkManager shareNetWorkManager].updateFrameCount == self.totalFrameCount) {
//        [self sendUpdateEndFrame];
//        NSLog(@"----- sendUpdateEndFrame ------");
//    } else {
//        [self sendOtherUpdateFrame];
//        NSLog(@"[NetWorkManager shareNetWorkManager].updateFrameCount ----- %zd", [NetWorkManager shareNetWorkManager].updateFrameCount);
//        if ([NetWorkManager shareNetWorkManager].updateFrameCount == 2) {
//            [NetWorkManager shareNetWorkManager].updateFrameCount = 656;
//        }
////        NSLog(@"[NetWorkManager shareNetWorkManager].updateFrameCount ----- %zd", [NetWorkManager shareNetWorkManager].updateFrameCount);
//        [NetWorkManager shareNetWorkManager].updateFrameCount = [NetWorkManager shareNetWorkManager].updateFrameCount + 1;
//
//
//    }
//}
- (NSArray *)convertBinFileToNSArrayWithFileName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableData *mData = [NSMutableData dataWithData:data];
    NSLog(@"%@", mData);
    
    NSUInteger Len = [mData length];
    UInt8 *recv = (UInt8 *)[data bytes];
    
    //把接收到的数据存放在recvData数组中
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    NSUInteger j = 0;
    while (j < Len) {
        [dataArr addObject:[NSNumber numberWithUnsignedChar:recv[j]]];
        j++;
    }
    return dataArr;
    
}
#pragma mark - UI
- (void)setupUI {
    UpdateView *updateView = [[UpdateView alloc] initWithFrame:CGRectMake(100, 100, ScreenWidth * 0.6, ScreenWidth * 0.6)];
    updateView.center = CGPointMake(self.view.center.x, self.view.center.y * 0.6);
    [self.view addSubview:updateView];
    self.processLabel.frame = CGRectMake(0, 0, updateView.frame.size.width - 60, updateView.frame.size.width - 60);
    self.processLabel.center = updateView.center;
    [self.view addSubview:self.processLabel];
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    UIButton *mainBtn = [UIButton new];
    [mainBtn setTitle:@"主控" forState:UIControlStateNormal];
    [mainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mainBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [mainBtn addTarget:self action:@selector(mainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    mainBtn.frame = CGRectMake(100, 500, 100, 100);
//    [self.view addSubview:mainBtn];
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0]];
        [_cancelButton setTitle:@"Cancel the Update" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelButton.titleLabel.numberOfLines = 0;
        _cancelButton.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (void)cancelButtonClick {
    NSLog(@"cancelButtonClick");
    //返回上一个界面
    [self.navigationController popViewControllerAnimated:YES];
}
- (UILabel *)processLabel{
    if (!_processLabel) {
        _processLabel = [UILabel new];
        _processLabel.font = [UIFont systemFontOfSize:40];
        _processLabel.textColor = [UIColor whiteColor];
        _processLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _processLabel;
}
//- (UILabel *)totalFrameCountLabel{
//    if (!_totalFrameCountLabel) {
//        _totalFrameCountLabel = [UILabel new];
//        _totalFrameCountLabel.font = [UIFont systemFontOfSize:20];
//        _totalFrameCountLabel.textColor = [UIColor blackColor];
//        _totalFrameCountLabel.layer.borderWidth = 5;
//        _totalFrameCountLabel.layer.borderColor = [UIColor blackColor].CGColor;
//        _totalFrameCountLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _totalFrameCountLabel;
//}
//- (void)setupUI {
//    UIButton *mainBtn = [UIButton new];
//    [mainBtn setTitle:@"主控" forState:UIControlStateNormal];
//    [mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [mainBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//    [mainBtn addTarget:self action:@selector(mainBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    mainBtn.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:mainBtn];
//
//    UIButton *asideBtn = [UIButton new];
//    [asideBtn setTitle:@"边界线板" forState:UIControlStateNormal];
//    [asideBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [asideBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//    [asideBtn addTarget:self action:@selector(asideBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    asideBtn.frame = CGRectMake(100, 250, 100, 100);
//    [self.view addSubview:asideBtn];
//
//    UIButton *arithBtn = [UIButton new];
//    [arithBtn setTitle:@"算法板" forState:UIControlStateNormal];
//    [arithBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [arithBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//    [arithBtn addTarget:self action:@selector(arithBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    arithBtn.frame = CGRectMake(100, 400, 100, 100);
//    [self.view addSubview:arithBtn];
//
//    [self.view addSubview:self.frameCountLabel];
//    [self.view addSubview:self.totalFrameCountLabel];
//    self.frameCountLabel.frame = CGRectMake(250, 100, 150, 50);
//    self.totalFrameCountLabel.frame = CGRectMake(250, 250, 150, 50);
//}
#pragma mark - 起始帧
- (void)mainBtnClick {
    NSLog(@"mainBtnClick");
    self.updateFileName = @"TEST.BIN";
    self.updateFileArr = [self convertBinFileToNSArrayWithFileName:self.updateFileName];
    
    UInt8 controlCode = 0x01;
    NSArray *arr = @[@0x00,@0x01,@0x70,@0x01];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:arr];
    //更新对象
    [dataArr addObject:@0x01];
    self.updateObject = @0x01;
    //设备型号
    [dataArr addObject:@0x13];
    self.updateModel = @0x13;
    //版本号
    [dataArr addObjectsFromArray:@[@0x00, @0x92]];
    
    NSArray *fileSizeArr = [self getFileHexArrWithHexString:[self getFileHexStringWithFileName:self.updateFileName]];
    unsigned long fileSizeHexOne = strtoul([fileSizeArr[0] UTF8String],0,16);
    unsigned long fileSizeHexTwo = strtoul([fileSizeArr[1] UTF8String],0,16);
    unsigned long fileSizeHexThree = strtoul([fileSizeArr[2] UTF8String],0,16);
    unsigned long fileSizeHexFour = strtoul([fileSizeArr[3] UTF8String],0,16);
    
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexOne]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexTwo]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexThree]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexFour]];
    
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataArr failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
    [NetWorkManager shareNetWorkManager].updateFrameCount = 0;
    //    //更新测试
    //    NSRunLoop *runloop = [[NSRunLoop alloc] init];
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        [self test];
    //    }];
    //    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)asideBtnClick {
    self.updateFileName = @"TEST.BIN";
    self.updateFileArr = [self convertBinFileToNSArrayWithFileName:self.updateFileName];
    UInt8 controlCode = 0x01;
    NSArray *arr = @[@0x00,@0x01,@0x70,@0x01];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:arr];
    [dataArr addObject:@0x02];
    self.updateObject = @0x02;
    [dataArr addObject:@0x12];
    self.updateModel = @0x13;
    [dataArr addObjectsFromArray:@[@0x00, @0x92]];
    
    NSArray *fileSizeArr = [self getFileHexArrWithHexString:[self getFileHexStringWithFileName:self.updateFileName]];
    unsigned long fileSizeHexOne = strtoul([fileSizeArr[0] UTF8String],0,16);
    unsigned long fileSizeHexTwo = strtoul([fileSizeArr[1] UTF8String],0,16);
    unsigned long fileSizeHexThree = strtoul([fileSizeArr[2] UTF8String],0,16);
    unsigned long fileSizeHexFour = strtoul([fileSizeArr[3] UTF8String],0,16);
    
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexOne]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexTwo]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexThree]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexFour]];
    
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataArr failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
    [NetWorkManager shareNetWorkManager].updateFrameCount = 0;
    
    
}
- (void)arithBtnClick {
    self.updateFileName = @"TEST.BIN";
    self.updateFileArr = [self convertBinFileToNSArrayWithFileName:self.updateFileName];
    
    UInt8 controlCode = 0x01;
    NSArray *arr = @[@0x00,@0x01,@0x70,@0x01];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:arr];
    [dataArr addObject:@0x03];
    self.updateObject = @0x03;
    [dataArr addObject:@0x12];
    self.updateModel = @0x12;
    [dataArr addObjectsFromArray:@[@0x11, @0x12]];
    
    NSArray *fileSizeArr = [self getFileHexArrWithHexString:[self getFileHexStringWithFileName:self.updateFileName]];
    unsigned long fileSizeHexOne = strtoul([fileSizeArr[0] UTF8String],0,16);
    unsigned long fileSizeHexTwo = strtoul([fileSizeArr[1] UTF8String],0,16);
    unsigned long fileSizeHexThree = strtoul([fileSizeArr[2] UTF8String],0,16);
    unsigned long fileSizeHexFour = strtoul([fileSizeArr[3] UTF8String],0,16);
    
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexOne]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexTwo]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexThree]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexFour]];
    
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataArr failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
    [NetWorkManager shareNetWorkManager].updateFrameCount = 0;
    
}
#pragma mark - 数据帧
- (void)sendFirstUpdateFrame {
    self.totalFrameCount = self.updateFileArr.count / 14;
    NSUInteger endFrameLength = self.updateFileArr.count % 14;
    NSArray *arr = [NSArray new];
    if(endFrameLength > 0) {
        self.totalFrameCount = self.totalFrameCount + 1;
    }
    NSLog(@"%zd", self.totalFrameCount);
    
    NSLog(@"%zd", endFrameLength);
    
    //第一帧
    UInt8 controlCode = 0x10;
    arr = [self.updateFileArr subarrayWithRange:NSMakeRange([NetWorkManager shareNetWorkManager].updateFrameCount * 14, 14)];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:arr failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
    
    self.processLabel.text = [NSString stringWithFormat:@"%.2f %%", ((CGFloat)([NetWorkManager shareNetWorkManager].updateFrameCount + 1) / self.totalFrameCount) * 100];
    
    //    NSLog(@"%@", arr);
    
}
- (void)sendOtherUpdateFrame {
    
    if ([NetWorkManager shareNetWorkManager].updateFrameCount == self.totalFrameCount - 1) {
        [self sendEndUpdateFrame];
        return;
    }
    NSArray *arr = [NSArray new];
    //中间
    UInt8 controlCode = 0x20;
    arr = [self.updateFileArr subarrayWithRange:NSMakeRange([NetWorkManager shareNetWorkManager].updateFrameCount * 14, 14)];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:arr failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
    
    
    //    NSLog(@"%@", arr);
    self.processLabel.text = [NSString stringWithFormat:@"%.2f %%", ((CGFloat)([NetWorkManager shareNetWorkManager].updateFrameCount + 1) / self.totalFrameCount) * 100];
    
}
- (void)sendEndUpdateFrame {
    
    NSUInteger endFrameLength = self.updateFileArr.count % 14;
    NSArray *arr = [NSArray new];
    
    NSLog(@"%zd", endFrameLength);
    
    if (endFrameLength != 0) {
        //最后一帧，且有多出来
        UInt8 controlCode = 0x30;
        arr = [self.updateFileArr subarrayWithRange:NSMakeRange([NetWorkManager shareNetWorkManager].updateFrameCount * 14, endFrameLength)];
        [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:arr failuer:nil andSuccessBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    } else if (endFrameLength == 0) {
        //最后一帧，且没多出来
        UInt8 controlCode = 0x30;
        arr = [self.updateFileArr subarrayWithRange:NSMakeRange([NetWorkManager shareNetWorkManager].updateFrameCount * 14, 14)];
        [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:arr failuer:nil andSuccessBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    }
    
    //    NSLog(@"%@", arr);
    self.processLabel.text = [NSString stringWithFormat:@"%.2f %%", ((CGFloat)([NetWorkManager shareNetWorkManager].updateFrameCount + 1) / self.totalFrameCount) * 100];
    
}
- (NSArray *) getFileHexArrWithHexString:(NSString *)fileSizeStr {
    int count = (int)(16 - fileSizeStr.length) * 0.5;
    for (int i = 0; i < count; i++) {
        fileSizeStr = [NSString stringWithFormat:@"0\n%@", fileSizeStr];
    }
    NSMutableString *mFileSizeStr = [NSMutableString stringWithString:fileSizeStr];
    __block NSString *hex = @"";
    __block NSMutableArray *mFileSizeHexArr = [NSMutableArray arrayWithCapacity:4];
    __block int hexI = 0;
    [mFileSizeStr enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        hex = [hex stringByAppendingString:line];
        if (hex.length == 2) {
            mFileSizeHexArr[hexI] = hex;
            hex = @"";
            hexI = hexI + 1;
        }
    }];
    return mFileSizeHexArr.copy;
}
- (NSString *) getFileHexStringWithFileName:(NSString *)name
{
    NSArray *dataArr = [self convertBinFileToNSArrayWithFileName:name];
    //    NSLog(@"%@", [self getHexByDecimal:dataArr.count]);
    return [self getHexByDecimal:dataArr.count];
//    return [self getHexByDecimal:98];
}

/**
 十进制转换十六进制
  
 @param decimal 十进制数
 @return 十六进制数
 */
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A\n"; break;
            case 11:
                letter =@"B\n"; break;
            case 12:
                letter =@"C\n"; break;
            case 13:
                letter =@"D\n"; break;
            case 14:
                letter =@"E\n"; break;
            case 15:
                letter =@"F\n"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld\n", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}
#pragma mark - 更新结束帧
- (void)sendUpdateEndFrame {
    [NetWorkManager shareNetWorkManager].updateFlag = 0;
    
    UInt8 controlCode = 0x01;
    NSArray *arr = @[@0x00,@0x01,@0x71,@0x01];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:arr];
    //更新对象
    [dataArr addObject:self.updateObject];
    [dataArr addObject:self.updateModel];
    [dataArr addObjectsFromArray:@[@0x11, @0x12]];
    
    
    NSArray *fileSizeArr = [self getFileHexArrWithHexString:[self getFileHexStringWithFileName:self.updateFileName]];
    unsigned long fileSizeHexOne = strtoul([fileSizeArr[0] UTF8String],0,16);
    unsigned long fileSizeHexTwo = strtoul([fileSizeArr[1] UTF8String],0,16);
    unsigned long fileSizeHexThree = strtoul([fileSizeArr[2] UTF8String],0,16);
    unsigned long fileSizeHexFour = strtoul([fileSizeArr[3] UTF8String],0,16);
    
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexOne]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexTwo]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexThree]];
    [dataArr addObject:[NSNumber numberWithUnsignedLong:fileSizeHexFour]];
    
    NSLog(@"%@", dataArr);
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataArr failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}
- (void)updateSuccess {
    NSLog(@"-----updateSuccess-------");
    [SVProgressHUD showSuccessWithStatus:@"更新成功"];
    
    UpdateSuccessViewController *vc = [UpdateSuccessViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendFirstUpdateFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendOtherUpdateFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendUpdateEndFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSuccess" object:nil];
    
}


@end
