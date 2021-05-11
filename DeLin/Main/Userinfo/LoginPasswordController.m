//
//  LoginPasswordController.m
//  DeLin
//
//  Created by 杭州轨物科技有限公司 on 2020/3/11.
//  Copyright © 2020年 com.thingcom. All rights reserved.
//

#import "LoginPasswordController.h"
#import "AAPasswordTF.h"
#import "DeviceInfoViewController.h"
#import "ForgetpasswordViewController.h"

@interface LoginPasswordController ()<UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) AAPasswordTF *passwordModelTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *forgetPWBtn;

@end

@implementation LoginPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    _labelBgView = [self labelBgView];
    [self setNavItem];
    [self setUItextField];
    _loginBtn = [self loginBtn];
    _forgetPWBtn = [self forgetPWBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Login");
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(20), ScreenWidth,yAutoFit(180))];
        _labelBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_labelBgView];
        
        UILabel *welcomelabel = [[UILabel alloc] init];
        welcomelabel.text = LocalString(@"Your personal information");
        welcomelabel.font = [UIFont systemFontOfSize:25.f];
        welcomelabel.textColor = [UIColor whiteColor];
        welcomelabel.textAlignment = NSTextAlignmentCenter;
        welcomelabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:welcomelabel];
        [welcomelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(30)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(self.labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Please enter your email password");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];;
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(100)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(welcomelabel.mas_bottom).offset(yAutoFit(10.f));
        }];
        
    }
    return _labelBgView;
}

- (UIButton *)forgetPWBtn{
    if (!_forgetPWBtn) {
        _forgetPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPWBtn setTitle:LocalString(@"Forgot password") forState:UIControlStateNormal];
        [_forgetPWBtn setTitleColor:[UIColor colorWithHexString:@"FDA31A"] forState:UIControlStateNormal];
        [_forgetPWBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_forgetPWBtn addTarget:self action:@selector(forgetPW) forControlEvents:UIControlEventTouchUpInside];
        //_forgetPWBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_forgetPWBtn];
        [_forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(150), yAutoFit(20)));
            make.top.equalTo(self.labelBgView.mas_bottom).offset(yAutoFit(200));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _forgetPWBtn;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:LocalString(@"Continue to") forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
        [_loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = YES;
        [self.view addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _loginBtn.layer.borderWidth = 0.5;
        _loginBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _loginBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _loginBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _loginBtn.layer.shadowRadius = 3;
        _loginBtn.layer.shadowOpacity = 1;
        _loginBtn.layer.cornerRadius = 2.5;
    }
    return _loginBtn;
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passwordModelTF.inputText && textField.text.length <= 0) {
        [self.passwordModelTF passwordTFBeginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passwordModelTF.inputText && textField.text.length <= 0) {
        [self.passwordModelTF passwordTFEndEditing];
    }
}

#pragma mark - Actions

- (void)setUItextField{
    
    CGRect emailF = CGRectMake(yAutoFit(15), getRectNavAndStatusHight + yAutoFit(200), yAutoFit(320), yAutoFit(60));
    
    self.passwordModelTF = [[AAPasswordTF alloc]initWithFrame:emailF withPlaceholderText:LocalString(@"Password")];
    self.passwordModelTF.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordModelTF.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordModelTF.inputText.keyboardType = UIKeyboardTypeEmailAddress;
    self.passwordModelTF.frame = emailF;
    self.passwordModelTF.inputText.delegate = self;
    [self.view addSubview:self.passwordModelTF];
    
    UITapGestureRecognizer *tapGrPassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedPassword:)];
    tapGrPassword.cancelsTouchesInView = NO;
    
    [self.passwordModelTF.labelView addGestureRecognizer:tapGrPassword];
}

-(void)viewTappedPassword:(UITapGestureRecognizer*)tapGr
{
    [self.passwordModelTF.inputText resignFirstResponder];
}

#pragma mark - GizWifiSDK delegate
// 实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    if(result.code == GIZ_SDK_SUCCESS) {
        //登录成功
        NSLog(@"登录成功,%@", result);
        
        [GizManager shareInstance].uid = uid;
        [GizManager shareInstance].token = token;
        
        //保存用户信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[GizManager shareInstance].uid forKey:@"uid"];
        [userDefaults setObject:[GizManager shareInstance].token forKey:@"token"];
        [userDefaults setObject:self.emailStr forKey:@"userEmail"];
        [userDefaults synchronize];
        //获取用户信息
        [[GizWifiSDK sharedInstance] getUserInfo:token];
        
        DeviceInfoViewController *InfoVC = [[DeviceInfoViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:InfoVC];
        //iOS 13 的 presentViewController 默认有视差效果，模态出来的界面现在默认都下滑返回。一些页面必须要点确认才能消失的，需要适配。如果项目中页面高度全部是屏幕尺寸，那么多出来的导航高度会出现问题。
        nav.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:nav animated:YES completion:nil];
        
    } else {
        // 登录失败
        NSLog(@"登录失败,%@", result);
        if (result.code == 9020) {
            [NSObject showHudTipStr:LocalString(@"username or password error!")];
        }else{
            [NSObject showHudTipStr:LocalString(@"fail")];
        }  
        
    }
    
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didGetUserInfo:(NSError *)result userInfo:(GizUserInfo *)userInfo{
    
    if(result.code == GIZ_SDK_SUCCESS) {
        NSLog(@"didGetUserInfo%@",userInfo);
    }
    
}

#pragma mark - Actions
- (void)goLogin{
    
    [[GizWifiSDK sharedInstance] userLogin:self.emailStr password:self.passwordModelTF.inputText.text];
    
}

- (void)forgetPW{
    
    ForgetpasswordViewController *ForgetVC = [[ForgetpasswordViewController alloc] init];
    ForgetVC.emailResetStr = self.emailStr;
    ForgetVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ForgetVC animated:YES completion:nil];
    
}

@end
