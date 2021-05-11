//
//  LeftDrawerViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/2.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "UIViewController+MMDrawerController.h"
#import "LeftDrawerCell.h"
#import "SetPinCodeViewController.h"
#import "SetLanguageViewController.h"

NSString *const CellIdentifier_leftDrawer_icon = @"leftDrawerCell_icon";
NSString *const CellIdentifier_leftDrawer = @"leftDrawerCell";

static float HEIGHT_CELL = 50.f;

@interface LeftDrawerViewController ()
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation LeftDrawerViewController
{
    NSString *email;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LocalString(@"用户信息");

    [self getUserInformation];
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        UIColor *tableViewBackgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
        [tableView setBackgroundColor:tableViewBackgroundColor];
        
        [tableView registerClass:[LeftDrawerCell class] forCellReuseIdentifier:CellIdentifier_leftDrawer];
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        //tableView.scrollEnabled = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        tableView;
    });
    
//    UIImageView *iconImg = [[UIImageView alloc] init];
//    [iconImg setImage:[UIImage imageNamed:@"img_mine_bg"]];
//    [self.view addSubview:iconImg];
//    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(yAutoFit(85),yAutoFit(40)));
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(self.view.mas_top).offset(yAutoFit(getRectNavAndStatusHight + yAutoFit(50)));
//    }];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn.layer setMasksToBounds:YES];
    [logoutBtn.layer setBorderWidth:1.0];
    [logoutBtn.layer setCornerRadius:15.0];
    [logoutBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [logoutBtn setTitle:LocalString(@"退出登录") forState:UIControlStateNormal];
    logoutBtn.backgroundColor = [UIColor colorWithHexString:@"FF9700"];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(yAutoFit(120),yAutoFit(40)));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _myTableView.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInformation{
    
    
}

#pragma mark - Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 5;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_leftDrawer_icon];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_leftDrawer_icon];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.imageView.image = [UIImage imageNamed:@"robot_icon_imag"];
        
        return cell;
    }else{
        
        LeftDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_leftDrawer];
        if (cell == nil) {
            cell = [[LeftDrawerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_leftDrawer];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.listImage.image = [UIImage imageNamed:@"userName_icon_imag"];
                cell.listLabel.text = LocalString(@"UserName");
            }
                break;
                
            case 1:
            {
                cell.listImage.image = [UIImage imageNamed:@"setting_icon_imag"];
                cell.listLabel.text = LocalString(@"Setting");
            }
                break;
                
            case 2:
            {
                cell.listImage.image = [UIImage imageNamed:@"manual_icon_imag"];
                cell.listLabel.text = LocalString(@"Manual instruction");
            }
                break;
                
            case 3:
            {
                cell.listImage.image = [UIImage imageNamed:@"pinCode_icon_imag"];
                cell.listLabel.text = LocalString(@"Pin code");
            }
                break;
                
            case 4:
            {
                cell.listImage.image = [UIImage imageNamed:@"language_icon_imag"];
                cell.listLabel.text = LocalString(@"Choose language");
            }
                break;
                
            default:
                break;
        }
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                NSLog(@"UserName");
            }
                break;
                
            case 1:
            {
                NSLog(@"Setting");
            }
                break;
                
            case 2:
            {
                NSLog(@"ManualInstruction");
            }
                break;
                
            case 3:
            {
                SetPinCodeViewController *setPinVC = [[SetPinCodeViewController alloc] init];
                //拿到我们的MainViewController，让它去push
                UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                [nav pushViewController:setPinVC animated:NO];
                //当我们push成功之后，关闭我们的抽屉
                [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                }];
            }
                break;
                
            case 4:
            {
                SetLanguageViewController *setLanguageVC = [[SetLanguageViewController alloc] init];
                //拿到我们的MainViewController，让它去push
                UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                [nav pushViewController:setLanguageVC animated:NO];
                //当我们push成功之后，关闭我们的抽屉
                [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                }];
            }
                break;
                
            default:
                break;
        }
    }
}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    MMSideDrawerSectionHeaderView * headerView;
//    headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 56.0)];
//    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
//    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

//section头部间距

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

#pragma mark - action
- (void)logout{
    [self.mm_drawerController dismissViewControllerAnimated:YES completion:nil];
}

@end
