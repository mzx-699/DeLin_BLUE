//
//  AAlertViewController.m
//  Coffee
//
//  Created by 安建伟 on 2019/9/16.
//  Copyright © 2019 杭州轨物科技有限公司. All rights reserved.
//

#import "AAlertViewController.h"

@interface AAlertViewController ()

@property (nonatomic, strong) UIView *alertView;

@end

@implementation AAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.frame = CGRectMake(52.5 / _WScale_alert, 172 / _HScale_alert, 270 / _WScale_alert, 203 / _HScale_alert);
        _alertView.center = self.view.center;
        _alertView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _alertView.layer.cornerRadius = 10.f;
        [self.view addSubview:_alertView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(44 / _WScale_alert,20 / _HScale_alert,182 / _WScale_alert,21 / _HScale_alert);
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:71/255.0 blue:51/255.0 alpha:1];
        [_alertView addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.frame = CGRectMake(16 / _WScale_alert,57 / _HScale_alert,238 / _WScale_alert,42 / _HScale_alert);
        _messageLabel.text = @"";
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _messageLabel.textColor = [UIColor colorWithRed:255/255.0 green:71/255.0 blue:51/255.0 alpha:1];
        [_alertView addSubview:_messageLabel];
        
        _centeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centeredBtn.frame = CGRectMake(15 / _WScale_alert,129 / _HScale_alert,240 / _WScale_alert,44 / _HScale_alert);
        [_centeredBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [_centeredBtn setTitle:LocalString(@"") forState:UIControlStateNormal];
        [_centeredBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16]];
        [_centeredBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:71/255.0 blue:51/255.0 alpha:1]];
        [_centeredBtn setButtonStyleWithColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] Width:1 cornerRadius:18.f / _HScale_alert];
        [_centeredBtn addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_centeredBtn];
        
    }
    return _alertView;
}

- (void)doAction{
    if (self.Block) {
        self.Block();
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showView{
    _alertView = [self alertView];
}

@end
