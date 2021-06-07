//
//  addLandroidDeviceViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/17.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "DeviceNetworkViewController.h"
#import "FinishNetworkViewController.h"
#import "ConnectNetworkViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>
#import "UIView+Border.h"
#import "AAWiFiPasswordTF.h"

@interface DeviceNetworkViewController () <UITextFieldDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) UITextField *wifiNameTF;

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) UIButton *continueBtn;
//@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, strong) AAWiFiPasswordTF *passwordModelTF;


@end

@implementation DeviceNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavItem];
    
    _labelBgView = [self labelBgView];
    _wifiNameTF = [self wifiNameTF];
    //_agreementBtn = [self agreementBtn];
    _continueBtn = [self continueBtn];
    [self setUItextField];
    if(@available(iOS 13.0, *)){
        [self getUserLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add Robot");
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(20), ScreenWidth,yAutoFit(150))];
        _labelBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_labelBgView];
        
        UILabel *welcomelabel = [[UILabel alloc] init];
        welcomelabel.text = LocalString(@"Select your home wireless network and enter your password");
        welcomelabel.font = [UIFont systemFontOfSize:18.f];
        welcomelabel.numberOfLines = 0;
        welcomelabel.textColor = [UIColor whiteColor];
        welcomelabel.textAlignment = NSTextAlignmentCenter;
        welcomelabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:welcomelabel];
        [welcomelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320.f) , yAutoFit(100.f)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(self.labelBgView.mas_top).offset(yAutoFit(20.f));
        }];
        
    }
    return _labelBgView;
}

- (UITextField *)wifiNameTF{
    if (!_wifiNameTF) {
        _wifiNameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, yAutoFit(320), yAutoFit(60))];
        _wifiNameTF.backgroundColor = [UIColor clearColor];
        _wifiNameTF.font = [UIFont systemFontOfSize:15.f];
        _wifiNameTF.textColor = [UIColor whiteColor];
        _wifiNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _wifiNameTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _wifiNameTF.delegate = self;
        _wifiNameTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_wifiNameTF addTarget:self action:@selector(textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
        _wifiNameTF.enabled = NO;
        [self.view addSubview:_wifiNameTF];
        [_wifiNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(60)));
            make.top.equalTo(self.labelBgView.mas_bottom).offset(yAutoFit(20));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        //自定义boder的样式
        [_wifiNameTF setBorderWithTop:YES Left:YES Bottom:YES Right:YES BorderColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0] BorderWidth:1.f];
        //获取当前连接的Wi-FiSSID
        _wifiNameTF.text = [self getDeviceSSID];
        //_wifiNameTF.text = [GizManager getCurrentWifi];
    }
    return _wifiNameTF;
}

#pragma mark - Actions

- (void)setUItextField{
    
    CGRect passwordF = CGRectMake(0, 0, yAutoFit(320), yAutoFit(60));
    
    self.passwordModelTF = [[AAWiFiPasswordTF alloc]initWithFrame:passwordF withPlaceholderText:LocalString(@"Password")];
    self.passwordModelTF.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordModelTF.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordModelTF.inputText.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordModelTF.frame = passwordF;
    self.passwordModelTF.inputText.delegate = self;
    [self.view addSubview:self.passwordModelTF];
    
    [self.passwordModelTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
        make.top.equalTo(self.wifiNameTF.mas_bottom).offset(yAutoFit(30));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    
    [self.passwordModelTF.labelView addGestureRecognizer:tapGr];
}

-(void)textFieldTextChange{
    
    NSLog(@"wifi");
}

/*- (UIButton *)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementBtn.tag = aUnselect;
        [_agreementBtn setImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal];
        [_agreementBtn setBackgroundColor:[UIColor clearColor]];
        [_agreementBtn.widthAnchor constraintEqualToConstant:25].active = YES;
        [_agreementBtn.heightAnchor constraintEqualToConstant:25].active = YES;
        _agreementBtn.tag = aUnselect;
        [_agreementBtn addTarget:self action:@selector(checkAgreement) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreementBtn];
        [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(20.f), yAutoFit(20.f)));
            make.left.equalTo(self.view.mas_left).offset(yAutoFit(40.f));
            make.top.equalTo(self.wifiNameTF.mas_bottom).offset(yAutoFit(100));
        }];
        
        UILabel *agreementLabel = [[UILabel alloc] init];
        agreementLabel.text = LocalString(@"No password");
        agreementLabel.font = [UIFont systemFontOfSize:14.f];
        agreementLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        agreementLabel.numberOfLines = 0;
        agreementLabel.textAlignment = NSTextAlignmentLeft;
        agreementLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:agreementLabel];
        [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(80)));
            make.centerY.equalTo(self.agreementBtn.mas_centerY);
            make.left.equalTo(self.agreementBtn.mas_right).offset(yAutoFit(5.f));
        }];
    }
    return _agreementBtn;
}*/

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Continue to") forState:UIControlStateNormal];
        [_continueBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_continueBtn addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
        _continueBtn.enabled = YES;
        [self.view addSubview:_continueBtn];
        [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _continueBtn.layer.borderWidth = 0.5;
        _continueBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _continueBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _continueBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _continueBtn.layer.shadowRadius = 3;
        _continueBtn.layer.shadowOpacity = 1;
        _continueBtn.layer.cornerRadius = 2.5;
    }
    return _continueBtn;
}

#pragma mark - 定位授权代理方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        //获取当前连接的Wi-FiSSID
        _wifiNameTF.text = [self getDeviceSSID];
        //_wifiNameTF.text = [GizManager getCurrentWifi];
    }
}

- (void)getUserLocation{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    //如果用户第一次拒绝了，触发代理重新选择，要用户打开位置权限
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1.0f;
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length <= 0) {
        [self.passwordModelTF passwordTFBeginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 0) {
        [self.passwordModelTF passwordTFEndEditing];
    }
}


#pragma 获取设备当前连接的WIFI的SSID
- (NSString *) getDeviceSSID
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSString *ssid = nil;
    //id info = nil;
    for (NSString *ifnam in ifs)
    {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        if (info && [info count])
//        {
//            break;
//        }
        if(info[@"SSID"])
        {
            ssid = info[@"SSID"];
        }
    }
//    NSDictionary *dctySSID = (NSDictionary *)info;
//    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    return ssid;
    
}

#pragma mark - Actions

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.passwordModelTF.inputText resignFirstResponder];
}

-(void)goContinue{
    
//    GizManager *manager = [GizManager shareInstance];
//    manager.ssid = _wifiNameTF.text;
//    manager.key = self.passwordModelTF.inputText.text;
    
//    if (self.passwordModelTF.inputText.text.length > 0) {
//        ConnectNetworkViewController *VC = [[ConnectNetworkViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }
}

/*-(void)checkAgreement{
    if (_agreementBtn.tag == aUnselect) {
        _agreementBtn.tag = aSelect;
        [_agreementBtn setImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal];
    }else if (_agreementBtn.tag == aSelect) {
        _agreementBtn.tag = aUnselect;
        [_agreementBtn setImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateNormal];
    }
    
}*/

@end
