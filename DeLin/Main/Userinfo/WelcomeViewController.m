//
//  WelcomeViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/27.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "WelcomeViewController.h"
#import "NewUserIDViewController.h"
#import "UIView+AniamtionManger.h"
#import "LoginViewController.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UIButton *signInBtn;
@property (nonatomic, strong) UIButton *signUpBtn;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    self.view.backgroundColor = [UIColor blackColor];
    _msgCenterView = [self msgCenterView];
    _signInBtn = [self signInBtn];
    _signUpBtn = [self signUpBtn];
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgCenterView];
        //位移动画
        [_msgCenterView positionAnimation];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"img_logo"]];
        [_msgCenterView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(312)));
            make.top.equalTo(self.msgCenterView.mas_top);
            make.centerX.equalTo(self.msgCenterView.mas_centerX);
        }];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , yAutoFit(312)+ yAutoFit(30), ScreenWidth,yAutoFit(180) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_msgCenterView addSubview:labelBgView];
        
        UILabel *welcomelabel = [[UILabel alloc] init];
        welcomelabel.text = LocalString(@"Welcome!");
        welcomelabel.font = [UIFont systemFontOfSize:36.f]; //大小
        welcomelabel.textColor = [UIColor whiteColor]; //颜色
        welcomelabel.textAlignment = NSTextAlignmentCenter; //排列
        welcomelabel.adjustsFontSizeToFitWidth = YES; //是否自适应
        [labelBgView addSubview:welcomelabel];
        //视图约束
        [welcomelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(40)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"From the beginning,applications can help you make the most of your connected devices");
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
        //透明动画
        [labelBgView opacityAniamtion];
    }
    return _msgCenterView;
}

- (UIButton *)signUpBtn{
    if (!_signUpBtn) {
        _signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signUpBtn setTitle:LocalString(@"A new user") forState:UIControlStateNormal];
        [_signUpBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signUpBtn setBackgroundColor:[UIColor colorWithRed:253/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_signUpBtn addTarget:self action:@selector(goSignUp) forControlEvents:UIControlEventTouchUpInside];
        _signUpBtn.enabled = YES;
        [self.view addSubview:_signUpBtn];
        [_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/2, yAutoFit(55)));
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _signUpBtn.layer.borderWidth = 0.5;
        _signUpBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _signUpBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _signUpBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _signUpBtn.layer.shadowRadius = 3;
        _signUpBtn.layer.shadowOpacity = 1;
        _signUpBtn.layer.cornerRadius = 2.5;
    }
    return _signUpBtn;
}

- (UIButton *)signInBtn{
    if (!_signInBtn) {
        _signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signInBtn setTitle:LocalString(@"Login") forState:UIControlStateNormal];
        [_signInBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signInBtn setBackgroundColor:[UIColor colorWithRed:248/255.0 green:180/255.0 blue:18/255.0 alpha:1.f]];
        [_signInBtn addTarget:self action:@selector(goSignIn) forControlEvents:UIControlEventTouchUpInside];
        _signInBtn.enabled = YES;
        [self.view addSubview:_signInBtn];
        [_signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/2, yAutoFit(55)));
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _signInBtn.layer.borderWidth = 0.5;
        _signInBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _signInBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _signInBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _signInBtn.layer.shadowRadius = 3;
        _signInBtn.layer.shadowOpacity = 1;
        _signInBtn.layer.cornerRadius = 2.5;
    }
    return _signInBtn;
}

- (void)goSignUp{
    
    NewUserIDViewController *newVC = [[NewUserIDViewController alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
}

- (void)goSignIn{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
