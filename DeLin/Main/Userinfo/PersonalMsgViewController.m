//
//  PersonalMsgViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/3.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "PersonalMsgViewController.h"
#import "AAPersonalFirstNameTF.h"
#import "AAPersonalLastNameTF.h"
#import "SetPasswordController.h"

@interface PersonalMsgViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) UIButton *continueBtn;

@property (nonatomic, strong) AAPersonalFirstNameTF *firstNameTFModel;
@property (nonatomic, strong) AAPersonalLastNameTF *lastNameTFModel;

@end

@implementation PersonalMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    _labelBgView = [self labelBgView];
    _continueBtn = [self continueBtn];
    
    [self setNavItem];
    [self setUItextField];
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"A new user");
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(20), ScreenWidth,yAutoFit(150))];
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
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(25.f)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(self.labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"To create an account,we need your personal information");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(100)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(welcomelabel.mas_bottom).offset(yAutoFit(5.f));
        }];
        
    }
    return _labelBgView;
}

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Continue to") forState:UIControlStateNormal];
        [_continueBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.f]];
        [_continueBtn addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
        _continueBtn.enabled = NO;
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

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.firstNameTFModel.inputFirstNameTF && textField.text.length <= 0) {
        [self.firstNameTFModel firstNameTFBeginEditing];
    }
    if (textField == self.lastNameTFModel.inputLastNameTF && textField.text.length <= 0) {
        [self.lastNameTFModel lastNameTFBeginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.firstNameTFModel.inputFirstNameTF && textField.text.length <= 0) {
        [self.firstNameTFModel firstNameTFEndEditing];
    }
    if (textField == self.lastNameTFModel.inputLastNameTF && textField.text.length <= 0) {
        [self.lastNameTFModel lastNameTFEndEditing];
    }
    
    if (self.firstNameTFModel.inputFirstNameTF.text.length <= 0 || self.lastNameTFModel.inputLastNameTF.text.length <= 0) {
        
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.f]];
        _continueBtn.enabled = NO;
    }else{
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
        _continueBtn.enabled = YES;
    }
}

#pragma mark - Actions

- (void)setUItextField{
    
    CGRect firstNameF = CGRectMake(yAutoFit(15), getRectNavAndStatusHight + yAutoFit(200), yAutoFit(160), yAutoFit(60));
    
    self.firstNameTFModel = [[AAPersonalFirstNameTF alloc]initWithFrame:firstNameF withPlaceholderText:LocalString(@"First name")];
    self.firstNameTFModel.inputFirstNameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.firstNameTFModel.inputFirstNameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstNameTFModel.inputFirstNameTF.keyboardType = UIKeyboardTypeDefault;
    self.firstNameTFModel.frame = firstNameF;
    self.firstNameTFModel.inputFirstNameTF.delegate = self;
    [self.view addSubview:self.firstNameTFModel];
    
    [self.firstNameTFModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(160), yAutoFit(60)));
        make.left.equalTo(self.view.mas_left).offset(yAutoFit(15.f));
        make.top.equalTo(self.labelBgView.mas_bottom);
    }];
    
    CGRect lastNameF = CGRectMake(firstNameF.origin.x, getRectNavAndStatusHight + yAutoFit(200), yAutoFit(160), yAutoFit(60));
    
    self.lastNameTFModel = [[AAPersonalLastNameTF alloc]initWithFrame:lastNameF withPlaceholderText:LocalString(@"Last name")];
    self.lastNameTFModel.inputLastNameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.lastNameTFModel.inputLastNameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastNameTFModel.inputLastNameTF.keyboardType = UIKeyboardTypeDefault;
    self.lastNameTFModel.frame = lastNameF;
    self.lastNameTFModel.inputLastNameTF.delegate = self;
    [self.view addSubview:self.lastNameTFModel];
    [self.lastNameTFModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(160), yAutoFit(60)));
        make.left.equalTo(self.firstNameTFModel.mas_right);
        make.top.equalTo(self.labelBgView.mas_bottom);
    }];
    
    UITapGestureRecognizer *tapGrFirstName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedFirstName:)];
    tapGrFirstName.cancelsTouchesInView = NO;
    
    UITapGestureRecognizer *tapGrLastName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedLastName:)];
    tapGrLastName.cancelsTouchesInView = NO;
    
    [self.firstNameTFModel.labelView addGestureRecognizer:tapGrFirstName];
    [self.lastNameTFModel.labelView addGestureRecognizer:tapGrLastName];
}

-(void)viewTappedFirstName:(UITapGestureRecognizer*)tapGr
{
    [self.firstNameTFModel.inputFirstNameTF resignFirstResponder];
}

-(void)viewTappedLastName:(UITapGestureRecognizer*)tapGr
{
    [self.lastNameTFModel.inputLastNameTF resignFirstResponder];
}


- (void)goContinue{
    SetPasswordController *passwordVC = [[SetPasswordController alloc] init];
    passwordVC.userEmail = self.userEmail;
    [self.navigationController pushViewController:passwordVC animated:YES];
    
    //保存用户名称
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [NSString stringWithFormat:@"%@%@",self.firstNameTFModel.inputFirstNameTF.text,self.lastNameTFModel.inputLastNameTF.text];
    [userDefaults setObject:userName forKey:@"userName"];
    [userDefaults synchronize];
    
}


@end
