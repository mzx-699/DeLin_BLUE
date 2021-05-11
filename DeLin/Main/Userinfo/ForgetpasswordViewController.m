//
//  ForgetpasswordViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/18.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "ForgetpasswordViewController.h"

@interface ForgetpasswordViewController () <UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UIView *msgSuccessView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *reSendEmailBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *okBtn;

@end

@implementation ForgetpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    _titleLabel = [self titleLabel];
    _cancelBtn = [self cancelBtn];
    _msgCenterView = [self msgCenterView];
    _msgSuccessView = [self msgSuccessView];
    _confirmBtn = [self confirmBtn];
    _okBtn = [self okBtn];
    //默认隐藏
    _msgSuccessView.hidden = YES;
    _okBtn.hidden = YES;
    
}
/**
 当该view被push出现时就会调用这个函数
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = LocalString(@"Forgot password");
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(20));
        }];
        
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"img_cancel_Btn"] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor clearColor]];
        [_cancelBtn.widthAnchor constraintEqualToConstant:30].active = YES;
        [_cancelBtn.heightAnchor constraintEqualToConstant:30].active = YES;
        [_cancelBtn addTarget:self action:@selector(goCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(30.f), yAutoFit(30.f)));
            make.right.equalTo(self.view.mas_right).offset(yAutoFit(-40.f));
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
    }
    return _cancelBtn;
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(70), ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgCenterView];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"img_resetEmail"]];
        [_msgCenterView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(100), yAutoFit(100)));
            make.top.equalTo(self.msgCenterView.mas_top).offset(getRectNavAndStatusHight + yAutoFit(70));
            make.centerX.equalTo(self.msgCenterView.mas_centerX);
        }];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(170) +  yAutoFit(20), ScreenWidth,yAutoFit(200) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_msgCenterView addSubview:labelBgView];
        
        UILabel *msglabel = [[UILabel alloc] init];
        msglabel.text = LocalString(@"Resetting the password is easy");
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
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = [NSString stringWithFormat:@"%@\n%@",LocalString(@"We will send you the steps to reset your password.First,please confirm your email address:"),self.emailResetStr];
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(120)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(msglabel.mas_bottom).offset(yAutoFit(10.f));
        }];
        
    }
    return _msgCenterView;
}

- (UIView *)msgSuccessView{
    if (!_msgSuccessView) {
        _msgSuccessView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(70), ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgSuccessView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgSuccessView];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"img_sendEmail"]];
        [_msgSuccessView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(120), yAutoFit(80)));
            make.top.equalTo(self.msgSuccessView.mas_top).offset(getRectNavAndStatusHight + yAutoFit(70));
            make.centerX.equalTo(self.msgSuccessView.mas_centerX);
        }];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(170) +  yAutoFit(20), ScreenWidth,yAutoFit(200) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_msgSuccessView addSubview:labelBgView];
        
        UILabel *msglabel = [[UILabel alloc] init];
        msglabel.text = LocalString(@"We have sent you an E-mail");
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
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Please follow the steps listed in the email to reset your password");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(120)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(msglabel.mas_bottom).offset(yAutoFit(10.f));
        }];
        
        _reSendEmailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reSendEmailBtn setTitle:LocalString(@"I didn't get the mail") forState:UIControlStateNormal];
        [_reSendEmailBtn setTitleColor:[UIColor colorWithHexString:@"FDA31A"] forState:UIControlStateNormal];
        [_reSendEmailBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_reSendEmailBtn addTarget:self action:@selector(goConfirm) forControlEvents:UIControlEventTouchUpInside];
        _reSendEmailBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.msgSuccessView addSubview:_reSendEmailBtn];
        [_reSendEmailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(150), yAutoFit(30)));
            make.top.equalTo(tiplabel.mas_bottom).offset(yAutoFit(40));
            make.centerX.equalTo(self.msgSuccessView.mas_centerX);
        }];
        
    }
    return _msgSuccessView;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:LocalString(@"Confirm") forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_confirmBtn addTarget:self action:@selector(goConfirm) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.enabled = YES;
        [self.view addSubview:_confirmBtn];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _confirmBtn.layer.borderWidth = 0.5;
        _confirmBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _confirmBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _confirmBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _confirmBtn.layer.shadowRadius = 3;
        _confirmBtn.layer.shadowOpacity = 1;
        _confirmBtn.layer.cornerRadius = 2.5;
    }
    return _confirmBtn;
}

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:LocalString(@"Ok") forState:UIControlStateNormal];
        [_okBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_okBtn addTarget:self action:@selector(goOk) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.enabled = YES;
        [self.view addSubview:_okBtn];
        [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _okBtn.layer.borderWidth = 0.5;
        _okBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _okBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _okBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _okBtn.layer.shadowRadius = 3;
        _okBtn.layer.shadowOpacity = 1;
        _okBtn.layer.cornerRadius = 2.5;
    }
    return _okBtn;
}

#pragma mark - Giz回调

// 实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didChangeUserPassword:(NSError *)result {
    if(result.code == GIZ_SDK_SUCCESS) {
        //重置密码邮件发送成功，提示用户查收
        NSLog(@"重置密码邮件发送成功");
        [SVProgressHUD dismiss];
        _msgCenterView.hidden = YES;
        _confirmBtn.hidden = YES;
        _okBtn.hidden = NO;
        _msgSuccessView.hidden = NO;
    } else {
        //重置密码邮件发送失败，弹出错误信息
        [SVProgressHUD dismiss];
        [NSObject showHudTipStr:LocalString(@"fail")];
    }
}

-(void)goConfirm{
    [SVProgressHUD show];
    [[GizWifiSDK sharedInstance] resetPassword:self.emailResetStr verifyCode:nil newPassword:nil accountType:GizUserEmail];
    
}

- (void)goOk{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goCancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
