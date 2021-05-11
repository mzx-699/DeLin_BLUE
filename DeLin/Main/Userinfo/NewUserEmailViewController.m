//
//  NewUserEmailViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/2.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "NewUserEmailViewController.h"
#import "AAEmailTextField.h"
#import "PersonalMsgViewController.h"

@interface NewUserEmailViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) UIButton *continueBtn;

@property (nonatomic,strong) AAEmailTextField *accountModel;

@end

@implementation NewUserEmailViewController

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
        tiplabel.text = LocalString(@"Please use your email address to create an account");
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
    if (textField.text.length <= 0) {
        [self.accountModel emailTFBeginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.accountModel.inputText && textField.text.length <= 0) {
        [self.accountModel emailTFEndEditing];
        
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.f]];
        _continueBtn.enabled = NO;
    }else{
        
        if ([NSString validateEmail:self.accountModel.inputText.text]) {
            [_continueBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
            _continueBtn.enabled = YES;
        }
    }
}

#pragma mark - Actions

- (void)setUItextField{

    CGRect accountF = CGRectMake(yAutoFit(15), getRectNavAndStatusHight + yAutoFit(170), yAutoFit(320), yAutoFit(60));
    
    self.accountModel = [[AAEmailTextField alloc]initWithFrame:accountF withPlaceholderText:LocalString(@"Email address")];
    self.accountModel.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.accountModel.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.accountModel.inputText.keyboardType = UIKeyboardTypeEmailAddress;
    self.accountModel.frame = accountF;
    self.accountModel.inputText.delegate = self;
    [self.view addSubview:self.accountModel];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    
    [self.accountModel.labelView addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.accountModel.inputText resignFirstResponder];
}

- (void)goContinue{
    PersonalMsgViewController *msgVC = [[PersonalMsgViewController alloc] init];
    msgVC.userEmail = self.accountModel.inputText.text;
    [self.navigationController pushViewController:msgVC animated:YES];
    
}

@end
