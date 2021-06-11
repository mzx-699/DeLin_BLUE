//
//  SetPinCodeViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/25.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "SetPinCodeViewController.h"
#import <objc/runtime.h>

@interface SetPinCodeViewController () <UITextFieldDelegate>

@property (strong,nonatomic) UIView *bgTipView;
@property (nonatomic, strong) UITextField *oldPinCodeTF;
@property (nonatomic, strong) UITextField *pinCodeTF;
@property (nonatomic, strong) UITextField *repeatpinCodeTF;
@property (strong, nonatomic) UIButton *sureBtn;

@end

@implementation SetPinCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    _bgTipView = [self bgTipView];
    _oldPinCodeTF = [self oldPinCodeTF];
    _pinCodeTF = [self pinCodeTF];
    _repeatpinCodeTF = [self repeatpinCodeTF];
    _sureBtn = [self sureBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"");
}

- (UIView *)bgTipView{
    if (!_bgTipView) {
        _bgTipView = [[UIView alloc] init];
        _bgTipView.backgroundColor = [UIColor colorWithHexString:@"000000"];
        [self.view addSubview:_bgTipView];
        [_bgTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(30) + getRectNavAndStatusHight);
        }];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = [UIFont systemFontOfSize:20.f];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = LocalString(@"Set anti-theft password");
        tipLabel.adjustsFontSizeToFitWidth = YES;
        [self.bgTipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(40)));
            make.centerX.mas_equalTo(self.bgTipView.mas_centerX);
            make.centerY.mas_equalTo(self.bgTipView.mas_centerY);
        }];
        
    }
    return _bgTipView;
}

- (UITextField *)oldPinCodeTF{
    if (!_oldPinCodeTF) {
        _oldPinCodeTF = [[UITextField alloc] init];
        _oldPinCodeTF.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        _oldPinCodeTF.font = [UIFont systemFontOfSize:16.f];
        _oldPinCodeTF.textColor = [UIColor whiteColor];
        _oldPinCodeTF.tintColor = [UIColor whiteColor];
        _oldPinCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPinCodeTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _oldPinCodeTF.delegate = self;
        _oldPinCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        _oldPinCodeTF.borderStyle = UITextBorderStyleRoundedRect;
        [_oldPinCodeTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_oldPinCodeTF];
        [_oldPinCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(200));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _oldPinCodeTF.layer.borderWidth = 1.5;
        _oldPinCodeTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _oldPinCodeTF.layer.cornerRadius = 2.5f;
        _oldPinCodeTF.placeholder = LocalString(@"Old pin code");
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_oldPinCodeTF, ivar);
        placeholderLabel.textColor = [UIColor grayColor];
    }
    return _oldPinCodeTF;
}

- (UITextField *)pinCodeTF{
    if (!_pinCodeTF) {
        _pinCodeTF = [[UITextField alloc] init];
        _pinCodeTF.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        _pinCodeTF.font = [UIFont systemFontOfSize:16.f];
        _pinCodeTF.textColor = [UIColor whiteColor];
        _pinCodeTF.tintColor = [UIColor whiteColor];
        _pinCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pinCodeTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _pinCodeTF.delegate = self;
        _pinCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        _pinCodeTF.borderStyle = UITextBorderStyleRoundedRect;
        [_pinCodeTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_pinCodeTF];
        [_pinCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.oldPinCodeTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _pinCodeTF.layer.borderWidth = 1.5;
        _pinCodeTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _pinCodeTF.layer.cornerRadius = 2.5f;
        _pinCodeTF.placeholder = LocalString(@"New pin code");
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_pinCodeTF, ivar);
        placeholderLabel.textColor = [UIColor grayColor];
        
    }
    return _pinCodeTF;
}

- (UITextField *)repeatpinCodeTF{
    if (!_repeatpinCodeTF) {
        _repeatpinCodeTF = [[UITextField alloc] init];
        _repeatpinCodeTF.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        _repeatpinCodeTF.font = [UIFont systemFontOfSize:16.f];
        _repeatpinCodeTF.textColor = [UIColor whiteColor];
        _repeatpinCodeTF.tintColor = [UIColor whiteColor];
        _repeatpinCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _repeatpinCodeTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _repeatpinCodeTF.delegate = self;
        _repeatpinCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        _repeatpinCodeTF.borderStyle = UITextBorderStyleRoundedRect;
        [_repeatpinCodeTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_repeatpinCodeTF];
        [_repeatpinCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.pinCodeTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _repeatpinCodeTF.layer.borderWidth = 1.5;
        _repeatpinCodeTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _repeatpinCodeTF.layer.cornerRadius = 2.5f;
        _repeatpinCodeTF.placeholder = LocalString(@"Repeat new pin code");
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_repeatpinCodeTF, ivar);
        placeholderLabel.textColor = [UIColor grayColor];
    }
    return _repeatpinCodeTF;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:LocalString(@"Save changes") forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.enabled = NO;
        [self.view addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _sureBtn.layer.borderWidth = 0.5;
        _sureBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _sureBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _sureBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _sureBtn.layer.shadowRadius = 3;
        _sureBtn.layer.shadowOpacity = 1;
        _sureBtn.layer.cornerRadius = 2.5;
    }
    return _sureBtn;
}

- (void)textFieldTextChange:(UITextField *)textField{
    if ( self.oldPinCodeTF.text.length > 0 && self.pinCodeTF.text.length > 0 && self.repeatpinCodeTF.text.length >0){
        [_sureBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        _sureBtn.enabled = YES;
    }else{
        [_sureBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:0.6f]];
        _sureBtn.enabled = NO;
    }
    if (self.oldPinCodeTF.text.length >4) {
        self.oldPinCodeTF.text = [self.oldPinCodeTF.text substringWithRange:NSMakeRange(0, 4)];
    }
    if (self.pinCodeTF.text.length >4) {
        self.pinCodeTF.text = [self.pinCodeTF.text substringWithRange:NSMakeRange(0, 4)];
    }
    if (self.repeatpinCodeTF.text.length >4) {
        self.repeatpinCodeTF.text = [self.repeatpinCodeTF.text substringWithRange:NSMakeRange(0, 4)];
    }
}

- (void)sure{
    
    if (self.oldPinCodeTF.text.length != 4 || self.pinCodeTF.text.length != 4 || self.repeatpinCodeTF.text.length != 4) {
        [NSObject showHudTipStr:LocalString(@"Pin needs 4 digits")];
    }else if (![self.pinCodeTF.text isEqualToString:self.repeatpinCodeTF.text])
    {
        [NSObject showHudTipStr:LocalString(@"Two input is inconsistent")];
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *dataContent = [[NSMutableArray alloc] init];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.oldPinCodeTF.text characterAtIndex:0] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.oldPinCodeTF.text characterAtIndex:1] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.oldPinCodeTF.text characterAtIndex:2] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.oldPinCodeTF.text characterAtIndex:3] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.repeatpinCodeTF.text characterAtIndex:0] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.repeatpinCodeTF.text characterAtIndex:1] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.repeatpinCodeTF.text characterAtIndex:2] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.repeatpinCodeTF.text characterAtIndex:3] - 48]];
            
            [SVProgressHUD show];
            UInt8 controlCode = 0x01;
            //可变插入
            [dataContent insertObject:@0x01 atIndex:0];
            [dataContent insertObject:@0x07 atIndex:0];
            [dataContent insertObject:@0x01 atIndex:0];
            [dataContent insertObject:@0x00 atIndex:0];
            
            [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataContent failuer:nil andSuccessBlock:^{
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [SVProgressHUD dismissWithDelay:1.0];
            }];
            //延时 标志位
            [NetWorkManager shareNetWorkManager].timeOutFlag = 1;
            //超时判断
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                //定时器开启
                [[NetWorkManager shareNetWorkManager].atimeOut setFireDate:[NSDate date]];
                
            });
        });
        
        //延时1秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }

}

@end
