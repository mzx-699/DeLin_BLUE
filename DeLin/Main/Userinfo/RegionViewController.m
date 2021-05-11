//
//  RegionViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/29.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "RegionViewController.h"
#import "RegionCell.h"

static float HEIGHT_CELL = 50.f;
NSString *const CellIdentifier_RegionCell = @"RegionCell";

@interface RegionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *regionTable;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) NSMutableArray  *regionChooseArray;

@property (nonatomic, assign) NSIndexPath * lastSelected;//上一次选中的索引

@property (copy, nonatomic) void(^block)(NSString *);

@end

@implementation RegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    _regionTable = [self regionTable];
    _continueBtn = [self continueBtn];
    [self setNavItem];
    
    self.regionChooseArray = [NSMutableArray arrayWithArray:@[LocalString(@"Mainland China"),LocalString(@"England"),LocalString(@"Portugal"),LocalString(@"Italia"),LocalString(@"España"),LocalString(@"Polska"),LocalString(@"Slovenija"),LocalString(@"Danmark"),LocalString(@"Norge"),LocalString(@"Česká republika"),LocalString(@"Suomi"),LocalString(@"Slovensko"),LocalString(@"Magyarország"),LocalString(@"France"),LocalString(@"Deutschland"),LocalString(@"Sverige"),LocalString(@"USA"),LocalString(@"Australia"),LocalString(@"Canada"),LocalString(@"Others")]];
    //默认选择之前选中的地区
    if (![self.addressStr isEqualToString:@""]) {
        NSUInteger arrIndex = [self.regionChooseArray indexOfObject:self.addressStr];
        self.lastSelected = [NSIndexPath indexPathForRow:arrIndex inSection:0];
        [self.regionTable selectRowAtIndexPath:self.lastSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Region");
}

- (UITableView *)regionTable{
    if (!_regionTable) {
        _regionTable = ({
            TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(30.f, getRectNavAndStatusHight + yAutoFit(5), ScreenWidth - yAutoFit(30.f) *2 , ScreenHeight - getRectNavAndStatusHight - yAutoFit(70)) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor grayColor];
            tableView.scrollEnabled = YES;
            [tableView registerClass:[RegionCell class] forCellReuseIdentifier:CellIdentifier_RegionCell];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.tableFooterView = [[UIView alloc] init];
            
            tableView;
        });
    }
    return _regionTable;
}

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Continue to") forState:UIControlStateNormal];
        [_continueBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_continueBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.f]];
        [_continueBtn addTarget:self action:@selector(goToSubmit) forControlEvents:UIControlEventTouchUpInside];
        _continueBtn.enabled = NO;
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
    return self.regionChooseArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_RegionCell];
    if (cell == nil) {
        cell = [[RegionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_RegionCell];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.regionLabel.text = self.regionChooseArray[indexPath.row];
    cell.chooseImage.image = [UIImage imageNamed:@"img_choose"];
    //如果是之前选择的地区被标记
    NSUInteger row = indexPath.row;
    NSUInteger oldRow = self.lastSelected.row;
    
    if (row == oldRow && self.lastSelected!= nil) {
        
        cell.chooseImage.hidden = NO;
    }else{
        cell.chooseImage.hidden = YES;
        
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger newRow = indexPath.row;
    NSInteger oldRow = (self.lastSelected !=nil) ? [self.lastSelected row]:-1;
    //判断当前选择的和上一次选中的是否为同一行
    if (newRow != oldRow) {
        //执行新行显示 旧行取消选择
        RegionCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.chooseImage.hidden = NO;
        
        RegionCell *oldCell = [tableView cellForRowAtIndexPath:self.lastSelected];
        oldCell.chooseImage.hidden = YES;
        self.lastSelected = indexPath;
        
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        _continueBtn.enabled = YES;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

- (void)goToSubmit{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSString *regionStr = [NSString stringWithFormat:@"%@", self.regionChooseArray[_lastSelected.row]];
    if (self.myblcok) {
        self.myblcok(regionStr);
    }
    
}


@end
