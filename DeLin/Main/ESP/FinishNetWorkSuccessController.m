//
//  FinishNetWorkSuccessController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/18.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "FinishNetWorkSuccessController.h"

@interface FinishNetWorkSuccessController ()

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation FinishNetWorkSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    [self setNavItem];
    _msgCenterView = [self msgCenterView];
    _startBtn = [self startBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Device to connect");
    
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgCenterView];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"img_success"]];
        [_msgCenterView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(100), yAutoFit(100)));
            make.top.equalTo(self.msgCenterView.mas_top).offset(getRectNavAndStatusHight + yAutoFit(70));
            make.centerX.equalTo(self.msgCenterView.mas_centerX);
        }];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(170) +  yAutoFit(20), ScreenWidth,yAutoFit(200) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_msgCenterView addSubview:labelBgView];
        
        UILabel *successlabel = [[UILabel alloc] init];
        successlabel.text = LocalString(@"Connection successful!");
        successlabel.font = [UIFont systemFontOfSize:25.f];
        successlabel.textColor = [UIColor whiteColor];
        successlabel.textAlignment = NSTextAlignmentCenter;
        successlabel.adjustsFontSizeToFitWidth = YES;
        successlabel.numberOfLines = 0;
        [labelBgView addSubview:successlabel];
        [successlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(100)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(labelBgView.mas_top);
        }];
        
    }
    return _msgCenterView;
}


- (UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setTitle:LocalString(@"Start to experience") forState:UIControlStateNormal];
        [_startBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_startBtn addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.enabled = YES;
        [self.view addSubview:_startBtn];
        [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _startBtn.layer.borderWidth = 0.5;
        _startBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _startBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _startBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _startBtn.layer.shadowRadius = 3;
        _startBtn.layer.shadowOpacity = 1;
        _startBtn.layer.cornerRadius = 2.5;
    }
    return _startBtn;
}

- (void)goContinue{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


@end
