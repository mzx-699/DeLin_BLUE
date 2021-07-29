//
//  UpdateSuccessViewController.m
//  DeLin
//
//  Created by apple on 2021/7/29.
//  Copyright © 2021 com.thingcom. All rights reserved.
//

#import "UpdateSuccessViewController.h"
#import "MainViewController.h"
@interface UpdateSuccessViewController ()
@property (nonatomic, strong) UIButton *successButton;
@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *successLabel;
@end

@implementation UpdateSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Update";
    [self setupUI];
}
- (void)setupUI {
    
    [self.view addSubview:self.successButton];
    [self.view addSubview:self.successImageView];
    [self.view addSubview:self.successLabel];
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.8);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.3);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.3);
    }];
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.successImageView.mas_centerX);
        make.top.equalTo(self.successImageView.mas_bottom).offset(30);
        make.width.equalTo(self.view.mas_width);
    }];
    [self.successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (UILabel *)successLabel{
    if (!_successLabel) {
        _successLabel = [UILabel new];
        _successLabel.text = @"Update successful!";
        _successLabel.font = [UIFont systemFontOfSize:20];
        _successLabel.textColor = [UIColor whiteColor];
        _successLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _successLabel;
}
- (UIImageView *)successImageView{
    if (!_successImageView) {
        _successImageView = [UIImageView new];
        _successImageView.image = [UIImage imageNamed:@"updateSuccess"];
        
    }
    return _successImageView;
}
- (UIButton *)successButton{
    if (!_successButton) {
        _successButton = [UIButton new];
        [_successButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0]];
        [_successButton setTitle:@"Start to experience" forState:UIControlStateNormal];
        _successButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _successButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _successButton.titleLabel.numberOfLines = 0;
        _successButton.titleLabel.textColor = [UIColor whiteColor];
        [_successButton addTarget:self action:@selector(successButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _successButton;
}
- (void)successButtonClick {
    NSLog(@"successButtonClick");
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *vc = vcs[vcs.count - 3];
    [self.navigationController popToViewController:vc animated:YES];
}
@end
