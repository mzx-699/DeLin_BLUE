//
//  finishViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/17.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "FinishNetworkViewController.h"
#import "AAProgressCircleView.h"
#import "FinishNetWorkSuccessController.h"

@interface FinishNetworkViewController ()

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) AAProgressCircleView *networkProgressView;

@end

@implementation FinishNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavItem];
    self.labelBgView = [self labelBgView];
    self.networkProgressView = [self networkProgressView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    GizManager *manager = [GizManager shareInstance];
//    NSLog(@"ssid---%@",manager.ssid);
//    NSLog(@"key---%@",manager.key);
//    //开始配网状态
//    //ap配网模式
//    [[GizWifiSDK sharedInstance] setDeviceOnboardingDeploy:manager.ssid key:manager.key configMode:GizWifiSoftAP softAPSSIDPrefix:@"Robot_2_Mow" timeout:60 wifiGAgentType:nil bind:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Device to connect");
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [rightButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [rightButton setImage:[UIImage imageNamed:@"img_cancel_Btn"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(finishBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;

}

- (AAProgressCircleView *)networkProgressView{
    if (!_networkProgressView) {
        //圆形进度图
        _networkProgressView = [[AAProgressCircleView alloc]init];
        [_networkProgressView didCircleProgressAction];
        [self.view addSubview:_networkProgressView];
        
        [_networkProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(217.f), yAutoFit(300)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(100.f));
        }];
        
    }
    return _networkProgressView;
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(400), ScreenWidth,yAutoFit(180))];
        _labelBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_labelBgView];
        
        UILabel *connectingLabel = [[UILabel alloc] init];
        connectingLabel.text = LocalString(@"Device connection");
        connectingLabel.font = [UIFont systemFontOfSize:25.f];
        connectingLabel.textColor = [UIColor whiteColor];
        connectingLabel.textAlignment = NSTextAlignmentCenter;
        connectingLabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:connectingLabel];
        [connectingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(30)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(self.labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Keep your router,phone,and mower as close to each other as possible.");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];;
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(100)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(connectingLabel.mas_bottom).offset(yAutoFit(10.f));
        }];
        
    }
    return _labelBgView;
}

#pragma mark - Actions

-(void)finish{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)finishBackAction{
    //返回上一级页面 取消配网功能
    UIViewController *viewCtl =self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:viewCtl animated:YES];
}

@end
