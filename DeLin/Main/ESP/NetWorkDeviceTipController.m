//
//  NetWorkDeviceTipController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/10.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "NetWorkDeviceTipController.h"
#import "DeviceNetworkViewController.h"

@interface NetWorkDeviceTipController ()

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UIButton *continueBtn;

@end

@implementation NetWorkDeviceTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _msgCenterView = [self msgCenterView];
    _continueBtn = [self continueBtn];
    [self setNavItem];
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add equipment");
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,getRectNavAndStatusHight, ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgCenterView];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"img_netWork_heder"]];
        [_msgCenterView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(250), yAutoFit(250)));
            make.top.equalTo(self.msgCenterView.mas_top);
            make.centerX.equalTo(self.msgCenterView.mas_centerX);
        }];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , yAutoFit(312)+ yAutoFit(30), ScreenWidth,yAutoFit(180) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_msgCenterView addSubview:labelBgView];
        
        UILabel *welcomelabel = [[UILabel alloc] init];
        welcomelabel.text = LocalString(@"Press the robot repeater button");
        welcomelabel.font = [UIFont systemFontOfSize:25.f];
        welcomelabel.textColor = [UIColor whiteColor];
        welcomelabel.textAlignment = NSTextAlignmentCenter;
        welcomelabel.adjustsFontSizeToFitWidth = YES;
        [labelBgView addSubview:welcomelabel];
        [welcomelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(40)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"When the robot's wireless network indicator flashes,the robot is ready to connect.");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(120)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(welcomelabel.mas_bottom).offset(yAutoFit(10.f));
        }];

    }
    return _msgCenterView;
}

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Ok,got it") forState:UIControlStateNormal];
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


#pragma mark - Actions

- (void)goContinue{
    
    DeviceNetworkViewController *deviceVC = [[DeviceNetworkViewController alloc] init];
    [self.navigationController pushViewController:deviceVC animated:YES];
    
}

@end
