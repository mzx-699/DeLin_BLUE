//
//  LogoutViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/9.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "LogoutViewController.h"
#import "WelcomeViewController.h"

@interface LogoutViewController ()

@property (nonatomic, strong) UIView *logoutView;
@property (strong, nonatomic) UIButton *logoutBtn;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) NSString *emailStr;

@end

@implementation LogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6]];
    //获取登录邮箱地址信息
    NSUserDefaults *emailDefaults = [NSUserDefaults standardUserDefaults];
    if ([emailDefaults objectForKey:@"userEmail"]){
        self.emailStr = [emailDefaults objectForKey:@"userEmail"];
    }
    self.logoutView = [self logoutView];
    self.dismissButton = [self dismissButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Lazy Load

- (UIView *)logoutView{
    if (!_logoutView) {
        _logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth,yAutoFit(180))];
        _logoutView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [self.view addSubview:_logoutView];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"img_cancel_balck_Btn"] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(goCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.logoutView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(35.f), yAutoFit(35.f)));
            make.right.equalTo(self.logoutView.mas_right).offset(yAutoFit(-30.f));
            make.top.equalTo(self.logoutView.mas_top).offset(yAutoFit(30.f));
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = [NSString stringWithFormat:@"%@",self.emailStr];
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [_logoutView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(220), yAutoFit(30)));
            make.centerX.equalTo(self.logoutView.mas_centerX);
            make.top.equalTo(self.logoutView.mas_top).offset(yAutoFit(60.f));
        }];
        
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitle:LocalString(@"Logout") forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor colorWithHexString:@"FDA31A"] forState:UIControlStateNormal];
        [_logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_logoutBtn addTarget:self action:@selector(goLogout) forControlEvents:UIControlEventTouchUpInside];
        _logoutBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.logoutView addSubview:_logoutBtn];
        [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(120), yAutoFit(40)));
            make.top.equalTo(tiplabel.mas_bottom).offset(yAutoFit(20));
            make.centerX.equalTo(self.logoutView.mas_centerX);
        }];
        _logoutBtn.layer.borderWidth = 0.5;
        _logoutBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _logoutBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _logoutBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _logoutBtn.layer.shadowRadius = 3;
        _logoutBtn.layer.shadowOpacity = 1;
        _logoutBtn.layer.cornerRadius = 2.5;
        
    }
    return _logoutView;
}

- (UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [_dismissButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_dismissButton atIndex:0];
    }
    return _dismissButton;
}

-(void)goLogout{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"] == YES){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAutoLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }
    
}

- (void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goCancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
