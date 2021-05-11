//
//  SelectDeviceViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/10.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "SelectDeviceViewController.h"
#import "SelectDeviceCell.h"
#import "NetWorkHomeTipController.h"

static float HEIGHT_CELL = 140.f;

NSString *const CellIdentifier_SelectDeviceCell = @"SelectDeviceCell";

@interface SelectDeviceViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *labelBgView;
@property (strong, nonatomic) UITableView *deviceTable;

@end

@implementation SelectDeviceViewController
{
    NSNumber *deviceType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _labelBgView = [self labelBgView];
    _deviceTable = [self deviceTable];
    [self setNavItem];

}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add equipment");
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight, ScreenWidth,yAutoFit(120))];
        _labelBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_labelBgView];
        
        UILabel *welcomelabel = [[UILabel alloc] init];
        welcomelabel.text = LocalString(@"Select your device");
        welcomelabel.font = [UIFont systemFontOfSize:25.f];
        welcomelabel.textColor = [UIColor whiteColor];
        welcomelabel.textAlignment = NSTextAlignmentCenter;
        welcomelabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:welcomelabel];
        [welcomelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(30)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.centerY.equalTo(self.labelBgView.mas_centerY);
        }];
        
    }
    return _labelBgView;
}

- (UITableView *)deviceTable{
    if (!_deviceTable) {
        _deviceTable = ({
            TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + yAutoFit(120), ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor clearColor];
            tableView.scrollEnabled = YES;
            [tableView registerClass:[SelectDeviceCell class] forCellReuseIdentifier:CellIdentifier_SelectDeviceCell];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.tableFooterView = [[UIView alloc] init];
            
            tableView;
        });
    }
    return _deviceTable;
}

#pragma mark - UITableView delegate&datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_SelectDeviceCell];
    if (cell == nil) {
        cell = [[SelectDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_SelectDeviceCell];
    }
    //重写frame 自定义Cell之间的间距
    [cell setFrame:CGRectMake(0, 0, ScreenWidth, yAutoFit(100))];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"img_deviceInfo_arrow"]];
    switch (indexPath.row) {
        case 0:
        {
            cell.chooseImage.image = [UIImage imageNamed:@"img_selectDeviceRM18_Cell"];
            //cell.rightNameLab.text = LocalString(@"RM18");
        }
            break;
        case 1:
        {
            cell.chooseImage.image = [UIImage imageNamed:@"img_selectDeviceRM24_Cell"];
            //cell.rightNameLab.text = LocalString(@"RM24");
        }
            break;
        case 2:
        {
            //cell.chooseImage.image = [UIImage imageNamed:@"img_selectDevice3_Cell"];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NetWorkHomeTipController *VC = [[NetWorkHomeTipController alloc] init];
    VC.robotCode = [NSNumber numberWithLong:(long)indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}


@end
