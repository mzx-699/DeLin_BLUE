//
//  connectViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/17.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "ConnectNetworkViewController.h"
#import "FinishNetworkViewController.h"
#import "DeviceNetworkViewController.h"

@interface ConnectNetworkViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *headerBgView;
@property (nonatomic, strong) UIButton *continueBtn;

@end

@implementation ConnectNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavItem];
    _headerBgView = [self headerBgView];
    _continueBtn = [self continueBtn];
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add equipment");
}

- (UIView *)headerBgView{
    if (!_headerBgView) {
        _headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth,ScreenHeight - yAutoFit(45))];
        _headerBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_headerBgView];
        
        UILabel *homelabel = [[UILabel alloc] init];
        homelabel.text = LocalString(@"Connect to the hot spot of the robot");
        homelabel.font = [UIFont systemFontOfSize:25.f];
        homelabel.textColor = [UIColor whiteColor];
        homelabel.numberOfLines = 0;
        homelabel.textAlignment = NSTextAlignmentCenter;
        homelabel.adjustsFontSizeToFitWidth = YES;
        [self.headerBgView addSubview:homelabel];
        [homelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320) , yAutoFit(50.f)));
            make.centerX.equalTo(self.headerBgView.mas_centerX);
            make.top.equalTo(self.headerBgView.mas_top).offset(yAutoFit(30));
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"You need to open the wireless network Settings on the device,connect to the hotspot,and then return to the application.");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [self.headerBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(100)));
            make.centerX.equalTo(self.headerBgView.mas_centerX);
            make.top.equalTo(homelabel.mas_bottom).offset(yAutoFit(5.f));
        }];
        
        UIImageView *tipImg = [[UIImageView alloc] init];
        [tipImg setImage:[UIImage imageNamed:@"img_netWork_hometip"]];
        [self.headerBgView addSubview:tipImg];
        [tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(270)));
            make.top.equalTo(tiplabel.mas_bottom).offset(yAutoFit(40));
            make.centerX.equalTo(self.headerBgView.mas_centerX);
        }];
        
    }
    return _headerBgView;
}

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Ok,got it") forState:UIControlStateNormal];
        [_continueBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_continueBtn addTarget:self action:@selector(ConnectWifi) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Actions

-(void)ConnectWifi{
    NSString *wifiName = @"Robot_2_Mow";
    if ([[GizManager getCurrentWifi] hasPrefix:wifiName]) {
        FinishNetworkViewController *VC = [[FinishNetworkViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self showAlert];
    }
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Jump prompt") message:LocalString(@"Connect hotspot “Robot_2_Mow” in settings") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
