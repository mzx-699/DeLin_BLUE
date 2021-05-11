//
//  PersonSettingViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/9.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "PersonSettingViewController.h"
#import "PersonSettingCell.h"
#import "SetPinCodeViewController.h"
#import "SetLanguageViewController.h"
#import "LogoutViewController.h"
#import "HelpSupportViewController.h"

NSString *const CellIdentifier_PersonSetting = @"CellID_PersonSetting";
static CGFloat const Cell_Height = 50.f;

@interface PersonSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *houseTable;
//@property (strong, nonatomic) UIButton *cancelBtn;

@end

@implementation PersonSettingViewController

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
    
    self.houseTable = [self houseTable];
    //self.cancelBtn = [self cancelBtn];
    
    [self setNavItem];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Lazy Load

- (void)setNavItem{
    
    self.navigationItem.title = LocalString(@"");
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setImage:[UIImage imageNamed:@"img_person_Btn"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goPerson) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

//- (UIButton *)cancelBtn{
//    if (!_cancelBtn) {
//        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cancelBtn setImage:[UIImage imageNamed:@"img_cancel_Btn"] forState:UIControlStateNormal];
//        [_cancelBtn setBackgroundColor:[UIColor clearColor]];
//        [_cancelBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_cancelBtn];
//        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(30.f), yAutoFit(30.f)));
//            make.left.equalTo(self.view.mas_left).offset(yAutoFit(40.f));
//            make.top.equalTo(self.view.mas_top).offset(yAutoFit(30.f));
//        }];
//    }
//    return _cancelBtn;
//}

-(UITableView *)houseTable{
    if (!_houseTable) {
        _houseTable = ({
            TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(yAutoFit(30.f), yAutoFit(150.f) , ScreenWidth - yAutoFit(30.f) *2,Cell_Height * 5)];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor grayColor];
            tableView.scrollEnabled = NO;
            [tableView registerClass:[PersonSettingCell class] forCellReuseIdentifier:CellIdentifier_PersonSetting];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            UIView *footView = [[UIView alloc] init];
            footView.backgroundColor = [UIColor clearColor];
            tableView.tableFooterView = footView;
            
            tableView;
        });
    }
    return _houseTable;
}

#pragma mark - UITableView delegate&datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_PersonSetting];
    if (cell == nil) {
        cell = [[PersonSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_PersonSetting];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    switch (indexPath.row) {
        case 0:
            cell.leftLabel.text = LocalString(@"Help and support");
            break;
        case 1:
            cell.leftLabel.text = LocalString(@"Language selection");
            break;
//        case 2:
//            cell.leftLabel.text = LocalString(@"About the DE app application");
//            break;
            
        default:
            
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            HelpSupportViewController *helpVC = [[HelpSupportViewController alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 1:
        {
            SetLanguageViewController *languageVC = [[SetLanguageViewController alloc] init];
            [self.navigationController pushViewController:languageVC animated:YES];
        }
            
            break;
            
        default:
            
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark - Actions


- (void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goPerson{
    
    LogoutViewController *LogoutVC = [[LogoutViewController alloc] init];
    LogoutVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    LogoutVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:LogoutVC animated:YES completion:nil];
    
}

@end
