//
//  NewUserIDViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/27.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "NewUserIDViewController.h"
#import "NewUserIDCell.h"
#import "RegionViewController.h"
#import "NewUserEmailViewController.h"

NSString *const CellIdentifier_NewUserIDCell = @"NewUserIDCell";
static float HEIGHT_CELL = 50.f;

@interface NewUserIDViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *addressTable;
@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) UIButton *continueBtn;

@end

@implementation NewUserIDViewController
{
    NSString *regionStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    _labelBgView = [self labelBgView];
    _addressTable = [self addressTable];
    _continueBtn = [self continueBtn];
    if (!self->regionStr) {
        self->regionStr = [NSString stringWithFormat:LocalString(@"Mainland China")];
    }
    //读取上次的 地区
    NSUserDefaults *regionDefaults = [NSUserDefaults standardUserDefaults];
    if ([regionDefaults objectForKey:@"region"]){
        self->regionStr = [regionDefaults objectForKey:@"region"];
    }
    
    [self setNavItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"A new user");
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(20), ScreenWidth,yAutoFit(180))];
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
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(30)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(self.labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"To create an account,we need your personal information");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];;
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(100)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(welcomelabel.mas_bottom).offset(yAutoFit(10.f));
        }];

    }
    return _labelBgView;
}

- (UITableView *)addressTable{
    if (!_addressTable) {
        _addressTable = ({
            TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0.f, getRectNavAndStatusHight + yAutoFit(200), ScreenWidth, HEIGHT_CELL)]; //坐标
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor grayColor]; //分割线
            tableView.scrollEnabled = NO;
            [tableView registerClass:[NewUserIDCell class] forCellReuseIdentifier:CellIdentifier_NewUserIDCell];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;//行高估计值
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.tableFooterView = [[UIView alloc] init];
            
            tableView;
        });
    }
    return _addressTable;
}

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Continue to") forState:UIControlStateNormal];
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

#pragma mark - UITableView delegate&datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewUserIDCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_NewUserIDCell];
    if (cell == nil) {
        cell = [[NewUserIDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_NewUserIDCell];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"img_deviceInfo_arrow"]];
    cell.leftLabel.text = LocalString(@"Region");
    cell.rightLabel.text = self->regionStr;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RegionViewController *regionVC = [[RegionViewController alloc] init];
    regionVC.myblcok = ^(NSString *str) {
        self->regionStr = str;
        [self.addressTable reloadData];
        //保存地区
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self->regionStr forKey:@"region"];
        [userDefaults synchronize];
    };
    regionVC.addressStr = self->regionStr;
    [self.navigationController pushViewController:regionVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

#pragma mark - Actions
- (void)goContinue{
    NewUserEmailViewController *emailVC = [[NewUserEmailViewController alloc] init];
    [self.navigationController pushViewController:emailVC animated:YES];
    
    //保存用户地址
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self->regionStr forKey:@"userAddress"];
    [userDefaults synchronize];
    
}

@end
