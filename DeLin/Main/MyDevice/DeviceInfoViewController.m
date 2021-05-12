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

NSString *const CellIdentifier_DeviceList = @"CellID_DeviceList";
static float HEIGHT_CELL = 100.f;

@interface DeviceInfoViewController () <UITableViewDelegate,UITableViewDataSource, GizWifiSDKDelegate>

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UIView *deviceBgView;
@property (nonatomic, strong) UITableView *deviceTable;
@property (nonatomic, strong) NSArray *deviceArray;
@property (nonatomic, strong) UIButton *AddEquipmentBtn;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    _msgCenterView = [self msgCenterView];
    _deviceBgView = [self deviceBgView];
//    _AddEquipmentBtn = [self AddEquipmentBtn];
    _deviceBgView.hidden = YES;
    [self setNavItem];
    //开启自动登录
//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"] == NO) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    GizManager *manager = [GizManager shareInstance];
    [GizWifiSDK sharedInstance].delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userUid = [userDefaults valueForKey:@"uid"];
    NSString *userToken = [userDefaults valueForKey:@"token"];
    
    [[GizWifiSDK sharedInstance] getBoundDevices:userUid token:userToken];
    //退出设备 需要取消所有 设备订阅
    [manager.device setSubscribe:GizAppproductSecret subscribed:NO]; //解除订阅
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Lazy load
- (void)setNavItem{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [leftButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [leftButton setImage:[UIImage imageNamed:@"img_setting_Btn"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 30, 30);
//    [rightButton.widthAnchor constraintEqualToConstant:30].active = YES;
//    [rightButton.heightAnchor constraintEqualToConstant:30].active = YES;
//    [rightButton setImage:[UIImage imageNamed:@"img_person_Btn"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(goPerson) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(70), ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgCenterView];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"img_deviceInfo"]];
        [_msgCenterView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(350)));
            make.top.equalTo(self.msgCenterView.mas_top).offset(yAutoFit(40));
            make.right.equalTo(self.msgCenterView.mas_right).offset(yAutoFit(-5.f));
        }];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , yAutoFit(40) + yAutoFit(370), ScreenWidth,yAutoFit(200) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_msgCenterView addSubview:labelBgView];
        
        UILabel *msglabel = [[UILabel alloc] init];
        msglabel.text = LocalString(@"control,Arrange the schedule,monitor");
        msglabel.font = [UIFont systemFontOfSize:15.f];
        msglabel.textColor = [UIColor whiteColor];
        msglabel.textAlignment = NSTextAlignmentCenter;
        msglabel.adjustsFontSizeToFitWidth = YES;
        msglabel.numberOfLines = 0;
        [labelBgView addSubview:msglabel];
        [msglabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(50)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Through APP take advantage of your equipment");
        tiplabel.font = [UIFont systemFontOfSize:13.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(80)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(msglabel.mas_bottom);
        }];
        
    }
    return _msgCenterView;
}

- (UIButton *)AddEquipmentBtn{
    if (!_AddEquipmentBtn) {
        _AddEquipmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_AddEquipmentBtn setTitle:LocalString(@"Add equipment") forState:UIControlStateNormal];
        [_AddEquipmentBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_AddEquipmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_AddEquipmentBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_AddEquipmentBtn addTarget:self action:@selector(addEquipment) forControlEvents:UIControlEventTouchUpInside];
        _AddEquipmentBtn.enabled = YES;
        [self.view addSubview:_AddEquipmentBtn];
        [_AddEquipmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _AddEquipmentBtn.layer.borderWidth = 0.5;
        _AddEquipmentBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _AddEquipmentBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _AddEquipmentBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _AddEquipmentBtn.layer.shadowRadius = 3;
        _AddEquipmentBtn.layer.shadowOpacity = 1;
        _AddEquipmentBtn.layer.cornerRadius = 2.5;
    }
    return _AddEquipmentBtn;
}

- (UIView *)deviceBgView{
    if (!_deviceBgView) {
        _deviceBgView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(70), ScreenWidth,ScreenHeight - yAutoFit(130))];
        _deviceBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_deviceBgView];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(50), ScreenWidth,yAutoFit(60) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_deviceBgView addSubview:labelBgView];
        
        UILabel *msglabel = [[UILabel alloc] init];
        msglabel.text = LocalString(@"My devices");
        msglabel.font = [UIFont systemFontOfSize:25.f];
        msglabel.textColor = [UIColor whiteColor];
        msglabel.textAlignment = NSTextAlignmentCenter;
        msglabel.adjustsFontSizeToFitWidth = YES;
        msglabel.numberOfLines = 0;
        [labelBgView addSubview:msglabel];
        [msglabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(50)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(labelBgView.mas_top);
        }];
        
        if (!_deviceTable) {
            _deviceTable = ({
                TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + yAutoFit(120), ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
                tableView.backgroundColor = [UIColor clearColor];
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView.scrollEnabled = YES;
                tableView.separatorColor = [UIColor clearColor];
                [tableView registerClass:[DeviceListCell class] forCellReuseIdentifier:CellIdentifier_DeviceList];
                [self.deviceBgView addSubview:tableView];
                
                [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ScreenWidth,ScreenHeight - yAutoFit(190) - yAutoFit(45)));
                    make.centerX.mas_equalTo(self.view.mas_centerX);
                    make.top.equalTo(labelBgView.mas_bottom);
                }];
                
                tableView.estimatedRowHeight = 0;
                tableView.estimatedSectionHeaderHeight = 0;
                tableView.estimatedSectionFooterHeight = 0;
                
                tableView.tableFooterView = [[UIView alloc] init];
                
                tableView;
            });
        }
    }
    return _deviceBgView;
}

#pragma mark - uitableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceList];
    if (cell == nil) {
        cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_DeviceList];
    }
    GizWifiDevice *device = _deviceArray[indexPath.row];
    
    switch ([device.remark intValue]) {
        case 0:
            cell.deviceImage.image = [UIImage imageNamed:@"img_selectDeviceRM18_Cell"];
            break;
        case 1:
            cell.deviceImage.image = [UIImage imageNamed:@"img_selectDeviceRM24_Cell"];
        break;
            
        default:
            cell.deviceImage.image = [UIImage imageNamed:@"img_selectDeviceRM18_Cell"];
            break;
    }
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"img_deviceInfo_arrow"]];
    
    cell.deviceListLabel.text = device.alias;
    if ([device.alias isEqualToString:@""]) {
        cell.deviceListLabel.text = LocalString(@"Robot_2_Mow");
    }
    
    UILongPressGestureRecognizer *longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deviceCellLongPress:)];

    longPressGesture.minimumPressDuration=1.f;//设置长按 时间
    [self.deviceTable addGestureRecognizer:longPressGesture];
    
    return cell;
}
//左滑删除 设备绑定
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LocalString(@"Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        GizWifiDevice *device = self.deviceArray[indexPath.row];
        //提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"Are you sure to delete?")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"action = %@",action);
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userUid = [userDefaults valueForKey:@"uid"];
            NSString *userToken = [userDefaults valueForKey:@"token"];
            [[GizWifiSDK sharedInstance] unbindDevice:userUid token:userToken did:device.did];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"action = %@",action);
        }];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    //    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    //        NSLog(@"点击了编辑");
    //    }];
    //    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GizWifiDevice *device = _deviceArray[indexPath.row];
    [[GizManager shareInstance] setGizDevice:device];
    
    InputPINViewController *inputPINVC = [[InputPINViewController alloc] init];
    [self.navigationController pushViewController:inputPINVC animated:YES];
    
}

#pragma mark - Giz delegate

// 设备解绑实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUnbindDevice:(NSError *)result did:(NSString *)did {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 解绑成功
        NSLog(@"解绑成功");
        //移除设备 清除记住密码
        NSUserDefaults *pinCode = [NSUserDefaults standardUserDefaults];
        [pinCode removeObjectForKey:@"pinCode"];
        [pinCode synchronize];
    } else {
        // 解绑失败
        NSLog(@"解绑失败");
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didDiscovered:(NSError *)result deviceList:(NSArray<GizWifiDevice *> *)deviceList{
    // 提示错误原因
    if(result.code != GIZ_SDK_SUCCESS) {
        NSLog(@"result--- %@", result.localizedDescription);
    }
    
    [self refreshTableView:deviceList];
}

// 实现回调
- (void)device:(GizWifiDevice *)device didSetCustomInfo:(NSError *)result {
    if(result.code == GIZ_SDK_SUCCESS) {
        //修改成功
        NSLog(@"修改成功");
    } else {
        // 修改失败
        NSLog(@"修改失败");
    }
    
}

#pragma mark - Actions
- (void)refreshTableView:(NSArray *)listArray{
    NSLog(@"设备数量%lu",(unsigned long)listArray.count);
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    for (GizWifiDevice *device in listArray) {
        if (device.isBind) {
            NSLog(@"绑定设备别名%@",device.alias);
        }
        if (device.netStatus == GizDeviceOnline && device.isBind) {
            [deviceArray addObject:device];
        }
    }
    if (deviceArray.count >0 ) {
        _deviceBgView.hidden = NO;
        _msgCenterView.hidden = YES;
    }else{
        _deviceBgView.hidden = YES;
        _msgCenterView.hidden = NO;
    }
    self.deviceArray = deviceArray;
    [self.deviceTable reloadData];
}

- (void)deviceCellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        //获取此时长按的Cell位置
        CGPoint location = [longRecognizer locationInView:self.deviceTable];
        NSIndexPath *indexPath = [self.deviceTable indexPathForRowAtPoint:location];
        GizWifiDevice *device = _deviceArray[indexPath.row];
        
        YTFAlertController *alert = [[YTFAlertController alloc] init];
        alert.lBlock = ^{
        };
        alert.rBlock = ^(NSString * _Nullable text) {
            //修改设备 别名
            [device setCustomInfo:NULL alias:text];
            
        };
        alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:alert animated:NO completion:^{
            alert.titleLabel.text = LocalString(@"Change name");
            
            if ([device.alias isEqualToString:@""]) {
                alert.textField.text = LocalString(@"Robot_2_Mow");
            }else{
                alert.textField.text = device.alias;
            }
            [alert.leftBtn setTitle:LocalString(@"Cancel") forState:UIControlStateNormal];
            [alert.rightBtn setTitle:LocalString(@"Ok") forState:UIControlStateNormal];
        }];
        
    }
}

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
