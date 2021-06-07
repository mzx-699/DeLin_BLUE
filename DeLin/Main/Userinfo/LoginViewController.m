//
//  LoginViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/10/22.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AAEmailTextField.h"
#import "LoginPasswordController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) AAEmailTextField *emailModelTF;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginViewController
{
    NSString *emailStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    _labelBgView = [self labelBgView];
    [self setNavItem];
    [self setUItextField];
    _loginBtn = [self loginBtn];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
        tiplabel.text = LocalString(@"Please enter your email address");
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

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:LocalString(@"Continue to") forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.f]];
        [_loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
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
    if (textField == self.emailModelTF.inputText && textField.text.length <= 0) {
        [self.emailModelTF emailTFBeginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.emailModelTF.inputText && textField.text.length <= 0) {
        [self.emailModelTF emailTFEndEditing];
        
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.f]];
        _loginBtn.enabled = NO;
    }else{
        if ([NSString validateEmail:self.emailModelTF.inputText.text]) {
            [_loginBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
            _loginBtn.enabled = YES;
        }
    }
}

#pragma mark - Actions

- (void)setUItextField{
    
    CGRect emailF = CGRectMake(yAutoFit(15), getRectNavAndStatusHight + yAutoFit(200), yAutoFit(320), yAutoFit(60));
    
    self.emailModelTF = [[AAEmailTextField alloc]initWithFrame:emailF withPlaceholderText:LocalString(@"Email address")];
    self.emailModelTF.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailModelTF.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailModelTF.inputText.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailModelTF.frame = emailF;
    self.emailModelTF.inputText.delegate = self;
    [self.view addSubview:self.emailModelTF];
    
    UITapGestureRecognizer *tapGrEmail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedEmail:)];
    tapGrEmail.cancelsTouchesInView = NO;
    
    [self.emailModelTF.labelView addGestureRecognizer:tapGrEmail];
}

-(void)viewTappedEmail:(UITapGestureRecognizer*)tapGr
{
    [self.emailModelTF.inputText resignFirstResponder];
}

#pragma mark - Actions
- (void)goLogin{
    
    LoginPasswordController *loginVC = [[LoginPasswordController alloc] init];
    loginVC.emailStr = self.emailModelTF.inputText.text;
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

@end
