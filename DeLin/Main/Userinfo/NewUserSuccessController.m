//
//  NewUserSucessController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/3.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "NewUserSuccessController.h"
#import "DeviceInfoViewController.h"
#import "SelectDeviceViewController.h"

@interface NewUserSuccessController ()

@property (nonatomic, strong) UIView *msgCenterView;
//@property (nonatomic, strong) UIButton *AddLaterBtn;
@property (nonatomic, strong) UIButton *AddEquipmentBtn;

@end

@implementation NewUserSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    _msgCenterView = [self msgCenterView];
    _AddEquipmentBtn = [self AddEquipmentBtn];
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
        successlabel.text = LocalString(@"Your account has been created successfully");
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
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Now, let's connect your device");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(80)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(successlabel.mas_bottom).offset(yAutoFit(10.f));
        }];
        
//        _AddLaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_AddLaterBtn setTitle:LocalString(@"Add your device later") forState:UIControlStateNormal];
//        [_AddLaterBtn setTitleColor:[UIColor colorWithHexString:@"FDA31A"] forState:UIControlStateNormal];
//        [_AddLaterBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
//        [_AddLaterBtn addTarget:self action:@selector(AddLater) forControlEvents:UIControlEventTouchUpInside];
//        _AddLaterBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [self.msgCenterView addSubview:_AddLaterBtn];
//        [_AddLaterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(150), yAutoFit(30)));
//            make.top.equalTo(tiplabel.mas_bottom).offset(yAutoFit(40));
//            make.centerX.equalTo(self.view.mas_centerX);
//        }];

    }
    return _msgCenterView;
}


- (UIButton *)AddEquipmentBtn{
    if (!_AddEquipmentBtn) {
        _AddEquipmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_AddEquipmentBtn setTitle:LocalString(@"Ok") forState:UIControlStateNormal];
        [_AddEquipmentBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_AddEquipmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_AddEquipmentBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_AddEquipmentBtn addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
        _AddEquipmentBtn.enabled = YES;
        [self.view addSubview:_AddEquipmentBtn];
        [_AddEquipmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _AddEquipmentBtn.layer.borderWidth = 0.5;
        _AddEquipmentBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _AddEquipmentBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _AddEquipmentBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _AddEquipmentBtn.layer.shadowRadius = 3;
        _AddEquipmentBtn.layer.shadowOpacity = 1;
        _AddEquipmentBtn.layer.cornerRadius = 2.5;
    }
    return _AddEquipmentBtn;
}

- (void)goContinue{
    
    DeviceInfoViewController *InfoVC = [[DeviceInfoViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:InfoVC];
    //iOS 13 的 presentViewController 默认有视差效果，模态出来的界面现在默认都下滑返回。一些页面必须要点确认才能消失的，需要适配。如果项目中页面高度全部是屏幕尺寸，那么多出来的导航高度会出现问题。
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

//- (void)AddLater{
//
//    DeviceInfoViewController *InfoVC = [[DeviceInfoViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:InfoVC];
//    //iOS 13 的 presentViewController 默认有视差效果，模态出来的界面现在默认都下滑返回。一些页面必须要点确认才能消失的，需要适配。如果项目中页面高度全部是屏幕尺寸，那么多出来的导航高度会出现问题。
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:nav animated:YES completion:nil];
//
//}
@end
