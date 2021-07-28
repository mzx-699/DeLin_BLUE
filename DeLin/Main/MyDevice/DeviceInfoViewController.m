//
//  DeviceInfoViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/7.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "LogoutViewController.h"
#import "PersonSettingViewController.h"
#import "SelectDeviceViewController.h"
#import "DeviceListCell.h"
#import "InputPINViewController.h"
#import "YTFAlertController.h"
#import "BlueToothManager.h"
#import "WorkTimeViewController.h"
#import "MainViewController.h"

#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"peripheral.data"]

NSString *const CellIdentifier_DeviceList = @"CellID_DeviceList";
static float HEIGHT_CELL = 100.f;

@interface DeviceInfoViewController () <UITableViewDelegate,UITableViewDataSource, BlueToothManagerDelegate>
@property (nonatomic, strong) BlueToothManager *blueToothManager;

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UIImageView *areaImageView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UILabel *msgTipLabel;

@property (nonatomic, strong) UIView *deviceBgView;
@property (nonatomic, strong) TouchTableView *deviceTableView;
@property (nonatomic, strong) UILabel *deviceLabel;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    [self setupUI];
    self.deviceBgView.hidden = YES;
    
    self.blueToothManager = [BlueToothManager sharedBlueToothManger];
    self.blueToothManager.delegate = self;
    [self.blueToothManager babyDelegate];
    [self.blueToothManager beginScanf];

}

#pragma mark - 设置UI
- (void)setupUI {
    [self setNavItem];
    
    [self.view addSubview:self.msgCenterView];
    [self.msgCenterView addSubview:self.areaImageView];
    [self.msgCenterView addSubview:self.msgLabel];
    [self.msgCenterView addSubview:self.msgTipLabel];
    [self.areaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(350)));
        make.top.equalTo(self.msgCenterView.mas_top).offset(yAutoFit(40));
        make.right.equalTo(self.msgCenterView.mas_right).offset(yAutoFit(-5.f));
    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(50)));
        make.centerX.equalTo(self.msgCenterView.mas_centerX);
        make.top.equalTo(self.areaImageView.mas_bottom);
    }];
    [self.msgTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(80)));
        make.centerX.equalTo(self.msgCenterView.mas_centerX);
        make.top.equalTo(self.msgLabel.mas_bottom);
    }];
    
    [self.view addSubview:self.deviceBgView];
    [self.deviceBgView addSubview:self.deviceLabel];
    [self.deviceBgView addSubview:self.deviceTableView];
    [self.deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(50)));
        make.centerX.equalTo(self.deviceBgView.mas_centerX);
        make.top.equalTo(self.deviceBgView.mas_top);
    }];
    [self.deviceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth,ScreenHeight - yAutoFit(190) - yAutoFit(45)));
        make.centerX.mas_equalTo(self.deviceBgView.mas_centerX);
        make.top.equalTo(self.deviceLabel.mas_bottom);
    }];
}

- (void)setNavItem{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [leftButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [leftButton setImage:[UIImage imageNamed:@"img_setting_Btn"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
#pragma mark - 设备懒加载
- (UIView *)deviceBgView{
    if (!_deviceBgView) {
        _deviceBgView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(70), ScreenWidth,ScreenHeight - yAutoFit(130))];
        _deviceBgView.backgroundColor = [UIColor clearColor];
    }
    return _deviceBgView;
}

- (UILabel *)deviceLabel {
    if (!_deviceLabel) {
        _deviceLabel = [[UILabel alloc] init];
        _deviceLabel.text = LocalString(@"My devices");
        _deviceLabel.font = [UIFont systemFontOfSize:25.f];
        _deviceLabel.textColor = [UIColor whiteColor];
        _deviceLabel.textAlignment = NSTextAlignmentCenter;
        _deviceLabel.adjustsFontSizeToFitWidth = YES;
        _deviceLabel.numberOfLines = 0;
        
    }
    return _deviceLabel;
}
- (UITableView *)deviceTableView {
    if (!_deviceTableView) {
        _deviceTableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + yAutoFit(120), ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _deviceTableView.backgroundColor = [UIColor clearColor];
        _deviceTableView.dataSource = self;
        _deviceTableView.delegate = self;
        _deviceTableView.scrollEnabled = YES;
        _deviceTableView.separatorColor = [UIColor clearColor];
            [_deviceTableView registerClass:[DeviceListCell class] forCellReuseIdentifier:CellIdentifier_DeviceList];

        _deviceTableView.estimatedRowHeight = 0;
        _deviceTableView.estimatedSectionHeaderHeight = 0;
        _deviceTableView.estimatedSectionFooterHeight = 0;
    }
    return _deviceTableView;
}
#pragma mark - 初始显示
- (UIImageView *)areaImageView {
    if (!_areaImageView) {
        _areaImageView = [[UIImageView alloc] init];
        [_areaImageView setImage:[UIImage imageNamed:@"img_deviceInfo"]];
    }
    return _areaImageView;
}
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.text = LocalString(@"control,Arrange the schedule,monitor");
        _msgLabel.font = [UIFont systemFontOfSize:15.f];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.adjustsFontSizeToFitWidth = YES;
        _msgLabel.numberOfLines = 0;
        
    }
    return _msgLabel;
}
- (UILabel *)msgTipLabel {
    if (!_msgTipLabel) {
        _msgTipLabel = [[UILabel alloc] init];
        _msgTipLabel.text = LocalString(@"Through APP take advantage of your equipment");
        _msgTipLabel.font = [UIFont systemFontOfSize:13.f];
        _msgTipLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        _msgTipLabel.numberOfLines = 0;
        _msgTipLabel.textAlignment = NSTextAlignmentCenter;
        _msgTipLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _msgTipLabel;
}
- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(70), ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        
    }
    return _msgCenterView;
}



#pragma mark - uitableview
- (void)reloadData {
    self.msgCenterView.hidden = YES;
    self.deviceBgView.hidden = NO;
    [self.deviceTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.blueToothManager.peripheralArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceList];
    if (cell == nil) {
        cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_DeviceList];
    }
    
    if (self.blueToothManager.peripheralArray.count > 0) {
        CBPeripheral *peripheral = self.blueToothManager.peripheralArray[indexPath.row];
        cell.deviceListLabel.text = self.blueToothManager.peripheralNameDict[peripheral.identifier];
        cell.deviceImage.image = [UIImage imageNamed:@"img_selectDeviceRM18_Cell"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"img_deviceInfo_arrow"]];
    }
//    cell.deviceListLabel.text = device.alias;
//    if ([device.alias isEqualToString:@""]) {
//        cell.deviceListLabel.text = LocalString(@"Robot_2_Mow");
//    }
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deviceCellLongPress:)];

    longPressGesture.minimumPressDuration=1.f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];

    return cell;
}
- (void)deviceCellLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"deviceCellLongPress");
        CGPoint ponit=[sender locationInView:self.deviceTableView];
        NSIndexPath* path=[self.deviceTableView indexPathForRowAtPoint:ponit];
        NSLog(@"row:%ld",(long)path.row);
        DeviceListCell *cell = [self.deviceTableView cellForRowAtIndexPath:path];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please input new name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            CBPeripheral *peripheral = self.blueToothManager.peripheralArray[path.row];
            self.blueToothManager.peripheralNameDict[peripheral.identifier] = alertController.textFields[0].text;
//            NSString *name = alertController.textFields[0].text;
            NSLog(@"name ----- %@", alertController.textFields[0].text);
            if (@available(iOS 11.0, *)) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.blueToothManager.peripheralNameDict requiringSecureCoding:NO error:nil];

                [data writeToFile:kFilePath atomically:YES];
                
            } else {
                [NSKeyedArchiver archiveRootObject:self.blueToothManager.peripheralNameDict toFile:kFilePath];
            }
            
            [self.deviceTableView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"New name";
                    textField.text = cell.deviceListLabel.text;
        }];
        [alertController addAction:done];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
//        currRow = path.row;
    }
}
//左滑删除 设备绑定
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LocalString(@"Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"点击了删除");
//        GizWifiDevice *device = self.deviceArray[indexPath.row];
//        //提示框
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"Are you sure to delete?")preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            NSLog(@"action = %@",action);
//
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            NSString *userUid = [userDefaults valueForKey:@"uid"];
//            NSString *userToken = [userDefaults valueForKey:@"token"];
//            [[GizWifiSDK sharedInstance] unbindDevice:userUid token:userToken did:device.did];
//
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            NSLog(@"action = %@",action);
//        }];
//        [alert addAction:okAction];
//        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }];
//    //    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//    //        NSLog(@"点击了编辑");
//    //    }];
//    //    editAction.backgroundColor = [UIColor grayColor];
//    return @[deleteAction];
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    editingStyle = UITableViewCellEditingStyleDelete;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.blueToothManager connectBLE:self.blueToothManager.peripheralArray[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    InputPINViewController *inputPINVC = [[InputPINViewController alloc] init];
    [self.navigationController pushViewController:inputPINVC animated:YES];
    //TODO - test
//    WorkTimeViewController *vc = [WorkTimeViewController new];
//    MainViewController *vc = [MainViewController new];
//        [self.navigationController pushViewController:vc animated:YES];

    
}


#pragma mark - Actions
//- (void)refreshTableView:(NSArray *)listArray{
//    NSLog(@"设备数量%lu",(unsigned long)listArray.count);
//    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
//    for (GizWifiDevice *device in listArray) {
//        if (device.isBind) {
//            NSLog(@"绑定设备别名%@",device.alias);
//        }
//        if (device.netStatus == GizDeviceOnline && device.isBind) {
//            [deviceArray addObject:device];
//        }
//    }
//    if (deviceArray.count >0 ) {
//        _deviceBgView.hidden = NO;
//        _msgCenterView.hidden = YES;
//    }else{
//        _deviceBgView.hidden = YES;
//        _msgCenterView.hidden = NO;
//    }
//    self.deviceArray = deviceArray;
//    [self.deviceTable reloadData];
//}

//- (void)deviceCellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
//    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
//        //成为第一响应者，需重写该方法
//        [self becomeFirstResponder];
//
//        //获取此时长按的Cell位置
//        CGPoint location = [longRecognizer locationInView:self.deviceTable];
//        NSIndexPath *indexPath = [self.deviceTable indexPathForRowAtPoint:location];
//        GizWifiDevice *device = _deviceArray[indexPath.row];
//
//        YTFAlertController *alert = [[YTFAlertController alloc] init];
//        alert.lBlock = ^{
//        };
//        alert.rBlock = ^(NSString * _Nullable text) {
//            //修改设备 别名
//            [device setCustomInfo:NULL alias:text];
//
//        };
//        alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [self presentViewController:alert animated:NO completion:^{
//            alert.titleLabel.text = LocalString(@"Change name");
//
//            if ([device.alias isEqualToString:@""]) {
//                alert.textField.text = LocalString(@"Robot_2_Mow");
//            }else{
//                alert.textField.text = device.alias;
//            }
//            [alert.leftBtn setTitle:LocalString(@"Cancel") forState:UIControlStateNormal];
//            [alert.rightBtn setTitle:LocalString(@"Ok") forState:UIControlStateNormal];
//        }];
//
//    }
//}

-(void)goSetting{
    
    PersonSettingViewController *PersonSettingVC = [[PersonSettingViewController alloc] init];
    [self.navigationController pushViewController:PersonSettingVC animated:YES];
}

- (void)goPerson{
    
    LogoutViewController *LogoutVC = [[LogoutViewController alloc] init];
    LogoutVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    LogoutVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:LogoutVC animated:YES completion:nil];
    
    //虚拟设备绑定 测试用
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *userUid = [userDefaults valueForKey:@"uid"];
//    NSString *userToken = [userDefaults valueForKey:@"token"];
//    
//    [[GizWifiSDK sharedInstance] bindDeviceWithUid:userUid token:userToken did:@"KxJu4xkPugQAoyoghZm7Yn" passCode:@"123456" remark:nil];
    
}

-(void)addEquipment{
    SelectDeviceViewController *VC = [[SelectDeviceViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
