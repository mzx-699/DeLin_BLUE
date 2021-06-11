//
//  WorkAreaViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/21.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "WorkAreaViewController.h"
#import "BlueToothManager.h"
@interface WorkAreaViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

///@brife 帧数据控制单例

@property (strong, nonatomic) UIPickerView *workAreaPicker;
@property (strong, nonatomic) UIButton *oKButton;

@property (nonatomic, strong) NSMutableArray  *workAreaArray;

@end

@implementation WorkAreaViewController
{
    NSTimeInterval timeA;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.workAreaPicker = [self workAreaPicker];
    self.oKButton = [self oKButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self inquireworkAera];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveWorkArea:) name:@"recieveWorkArea" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recieveWorkArea" object:nil];
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Set the area");
}

-(UIPickerView *)workAreaPicker{
    if (!_workAreaPicker) {
        _workAreaPicker = [[UIPickerView alloc] init];
        _workAreaPicker.backgroundColor = [UIColor clearColor];
        self.workAreaArray = [[NSMutableArray alloc] init];
        
        //1平方米 = 0.000247英亩 10 000平方米 = 1公顷 = 2.4710538 英亩(acres)
        for (int i = 50; i < self.area+50 ; i = i+50) {
            [self.workAreaArray addObject:[NSString stringWithFormat:@"%d%@%.3f%@",i,@"m²/",i*0.000247,@"acre"]];
        }
        
        self.workAreaPicker.dataSource = self;
        self.workAreaPicker.delegate = self;
        //在当前选择上显示一个透明窗口
        self.workAreaPicker.showsSelectionIndicator = YES;
        //初始化，自动转一圈，避免第一次是数组第一个值造成留白
        [self.workAreaPicker selectRow:[self.workAreaArray count] inComponent:0 animated:YES];
        [self.view addSubview:_workAreaPicker];
        
        [_workAreaPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth,yAutoFit(500)));
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(30.f));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _workAreaPicker;
}

//自定义pick view的字体和颜色
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
        pickerLabel.textColor = [UIColor whiteColor];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (UIButton *)oKButton{
    if (!_oKButton) {
        _oKButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oKButton setTitle:LocalString(@"SET DONE") forState:UIControlStateNormal];
        [_oKButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_oKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oKButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_oKButton addTarget:self action:@selector(setWorkAera) forControlEvents:UIControlEventTouchUpInside];
        _oKButton.enabled = YES;
        [self.view addSubview:_oKButton];
        [_oKButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(55)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _oKButton.layer.borderWidth = 0.5;
        _oKButton.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _oKButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _oKButton.layer.shadowOffset = CGSizeMake(0,2.5);
        _oKButton.layer.shadowRadius = 3;
        _oKButton.layer.shadowOpacity = 1;
        _oKButton.layer.cornerRadius = 2.5;
    }
    return _oKButton;
}


#pragma mark - inquire Mower workAera

- (void)inquireworkAera{

    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x05,@0x00];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];


}


#pragma mark - notification

- (void)recieveWorkArea:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    NSNumber *workArea = dict[@"workArea"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //工作区域数组 对应的pickindex 相差50
        [self.workAreaPicker selectRow:[workArea intValue]/50 inComponent:0 animated:YES];
    });
    
}

#pragma mark - Action
- (void)setWorkAera
{
    NSInteger row = [self.workAreaPicker selectedRowInComponent:0];
    
    NSNumber *area1 = [NSNumber numberWithUnsignedInteger:[self.workAreaArray[row % _workAreaArray.count] integerValue]/256];
    NSNumber *area2 = [NSNumber numberWithUnsignedInteger:[self.workAreaArray[row % _workAreaArray.count] integerValue]%256];
    
    NSTimeInterval currentTimeA = [NSDate date].timeIntervalSince1970;
    if (currentTimeA - timeA > 1 ) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [SVProgressHUD show];
            UInt8 controlCode = 0x01;
            NSArray *data = @[@0x00,@0x01,@0x05,@0x01,area1,area2];
            [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil andSuccessBlock:^{
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [SVProgressHUD dismissWithDelay:1.0];
            }];
            
        });
        timeA = currentTimeA;
        //延时 标志位
        [NetWorkManager shareNetWorkManager].timeOutFlag = 1;
        
        //超时判断
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            //定时器开启
            [[NetWorkManager shareNetWorkManager].atimeOut setFireDate:[NSDate date]];
            
        });
    }
    

}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    
    return 40;
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView  numberOfRowsInComponent:(NSInteger)component
{
    return 16384;
}

// 返回的是component列的行显示的内容

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%@",self.workAreaArray[row % _workAreaArray.count]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSUInteger max = 16384;
    
    NSUInteger base0 = (max / 2) - (max / 2) % _workAreaArray.count;
    [self.workAreaPicker selectRow:[_workAreaPicker selectedRowInComponent:component] % _workAreaArray.count + base0 inComponent:component animated:NO];

}

@end
