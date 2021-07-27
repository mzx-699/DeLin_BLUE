//
//  WorkTimeViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/21.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "WorkTimeViewController.h"
#import "WorktimeCell.h"

NSString *const CellIdentifier_WorkTime = @"CellID_WorkTime";

@interface WorkTimeViewController () <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

///@brife 帧数据控制单例

@property (strong, nonatomic) UITableView *workTimeTable;
@property (strong, nonatomic) UIPickerView *workDatePickview;
@property (strong, nonatomic) UIButton *oKButton;

///@brife 工作时间设置
@property (nonatomic, strong) NSMutableArray  *dayArray;
@property (nonatomic, strong) NSMutableArray  *workingHoursArray;
@property (nonatomic, strong) NSMutableArray  *workingMinuteArray;

@property (nonatomic, strong) NSMutableArray  *selectrowArray; //21个状态 7天*（小时+分钟+状态）
@property (nonatomic) int flag;//0:不发送,1:可以发送

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WorkTimeViewController

{
    NSIndexPath *selectIndexPath;
    UITextField *selectHoursTF;
    UITextField *selectMinutesTF;
    NSTimeInterval timeW;
}

static CGFloat cellHeight = 60.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self inquireWorktimeSetting];
    //初始化数组 要提前
    [self initDataArray];
    [self setNavItem];
    self.workTimeTable = [self workTimeTable];
    self.workDatePickview = [self workDatePickview];
    self.oKButton = [self oKButton];
    
    _flag = 0;//默认不发送数据
    //_timer = [self timer];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveWorkingTimeMonToWendes:) name:@"recieveWorkingTimeMonToWendes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveWorkingTimeThursToSun:) name:@"recieveWorkingTimeThursToSun" object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recieveWorkingTimeMonToWendes" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recieveWorkingTimeThursToSun" object:nil];
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Set the time");
}

- (NSTimer *)timer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(inquireWorktimeSetting) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate date]];
    }
    return _timer;
}

- (void)initDataArray{
    
    self.dayArray = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"Mon", nil),NSLocalizedString(@"Tue", nil),NSLocalizedString(@"Wed", nil),NSLocalizedString(@"Thu", nil),NSLocalizedString(@"Fri", nil),NSLocalizedString(@"Sat", nil),NSLocalizedString(@"Sun", nil)]];
    
    self.workingHoursArray = [[NSMutableArray alloc] init];
    self.workingMinuteArray = [[NSMutableArray alloc] init];
    
    //设置开始时间与工作时间的PickerView
    for (int i = 0; i < 24; i++) {
        [self.workingHoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    for (int i = 0; i < 60; i++) {
        [self.workingMinuteArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    self.selectrowArray = [NSMutableArray array];
    for (int i = 0; i < 21; i++) {
        [_selectrowArray addObject:[NSNumber numberWithInt:0]];
    }
    
}

- (UITableView *)workTimeTable{
    if (!_workTimeTable) {
        _workTimeTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + yAutoFit(80), ScreenWidth, cellHeight * 7) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor clearColor];
            [tableView registerClass:[WorktimeCell class] forCellReuseIdentifier:CellIdentifier_WorkTime];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.scrollEnabled = NO;
            tableView;
        });
    }
    return _workTimeTable;
}

-(UIPickerView *)workDatePickview{
    if (!_workDatePickview) {
        _workDatePickview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216)];
        self.workDatePickview.dataSource = self;
        self.workDatePickview.delegate = self;
        //在当前选择上显示一个透明窗口
        self.workDatePickview.showsSelectionIndicator = YES;
        //初始化，自动转一圈，避免第一次是数组第一个值造成留白
        [self.workDatePickview selectRow:[self.workingHoursArray count] inComponent:0 animated:YES];
        [self.workDatePickview selectRow:[self.workingMinuteArray count] inComponent:1 animated:YES];

    }
    return _workDatePickview;
}

//自定义pick view的字体和颜色
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
        pickerLabel.textColor = [UIColor blackColor];
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
        [_oKButton addTarget:self action:@selector(setMowerTime) forControlEvents:UIControlEventTouchUpInside];
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


#pragma tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 7;
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorktimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_WorkTime];
    if (cell == nil) {
        cell = [[WorktimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_WorkTime];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.userInteractionEnabled = YES;
    cell.weekLabel.text = _dayArray[indexPath.row];
    cell.weekLabel.adjustsFontSizeToFitWidth = YES;
    cell.workTimeSwitch.on = [_selectrowArray[indexPath.row + 14] boolValue];
    
    cell.worksHoursTF.delegate = self;
    cell.worksMinutesTF.delegate = self;
    //将键盘替换成pickView
    cell.worksHoursTF.inputView = _workDatePickview;
    cell.worksMinutesTF.inputView = _workDatePickview;
    if ([_selectrowArray[indexPath.row] intValue] <= 24) {
        cell.worksHoursTF.text = [_workingHoursArray objectAtIndex:[_selectrowArray[indexPath.row] intValue]];
    }
    if ([_selectrowArray[indexPath.row + 7] intValue] <= 60) {
        cell.worksMinutesTF.text = [NSString stringWithFormat:@"%@%@",LocalString(@":"),[_workingMinuteArray objectAtIndex:[_selectrowArray[indexPath.row + 7] intValue]]];
    }
    cell.block = ^(BOOL isOn) {
        
        if (isOn) {
            [self.selectrowArray replaceObjectAtIndex:indexPath.row + 14 withObject:[NSNumber numberWithBool:isOn]];
        }else{
            [self.selectrowArray replaceObjectAtIndex:indexPath.row + 14 withObject:[NSNumber numberWithBool:isOn]];
        }
        
        [self.workTimeTable reloadData];
    };
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIPickerViewDataSource

// 返回多少列

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    
    return 40;
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView  numberOfRowsInComponent:(NSInteger)component
{
    return 16384;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSUInteger max = 16384;
    
    switch (component) {
        case 0:
        {
            NSUInteger base1 = (max / 2) - (max / 2) % _workingHoursArray.count;
            [self.workDatePickview selectRow:[_workDatePickview selectedRowInComponent:component] % _workingHoursArray.count + base1 inComponent:component animated:NO];
            selectHoursTF.text = _workingHoursArray[row % _workingHoursArray.count];
            [_selectrowArray replaceObjectAtIndex:selectIndexPath.row withObject:[NSNumber numberWithLong:row % _workingHoursArray.count]];
        }
            break;
        case 1:
        {
            NSUInteger base2 = (max / 2) - (max / 2) % _workingMinuteArray.count;
            [self.workDatePickview selectRow:[_workDatePickview selectedRowInComponent:component] % _workingMinuteArray.count + base2 inComponent:component animated:NO];
            selectMinutesTF.text = [NSString stringWithFormat:@"%@%@",LocalString(@":"),_workingMinuteArray[row % _workingMinuteArray.count]];
            [_selectrowArray replaceObjectAtIndex:selectIndexPath.row + 7 withObject:[NSNumber numberWithLong:row % _workingMinuteArray.count]];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UIPickerViewDelegate

// 返回的是component列的行显示的内容

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.workingHoursArray[row % _workingHoursArray.count];
            break;
            
        default:
            return self.workingMinuteArray[row % _workingMinuteArray.count];
            break;
    }
    
}

#pragma mark - textFiled delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    selectIndexPath = [self.workTimeTable indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
    selectHoursTF = [self.workTimeTable cellForRowAtIndexPath:selectIndexPath].contentView.subviews[1];
    selectMinutesTF = [self.workTimeTable cellForRowAtIndexPath:selectIndexPath].contentView.subviews[2];
    selectHoursTF.textColor = [UIColor colorWithHexString:@"FF9700"];
    selectMinutesTF.textColor = [UIColor colorWithHexString:@"FF9700"];
    selectHoursTF.tintColor = [UIColor colorWithHexString:@"FF9700"];//传达色彩
    selectMinutesTF.tintColor = [UIColor colorWithHexString:@"FF9700"];
    [_workDatePickview selectRow:[_selectrowArray[selectIndexPath.row] intValue] inComponent:0 animated:YES];
    [_workDatePickview selectRow:[_selectrowArray[selectIndexPath.row + 7] intValue] inComponent:1 animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    selectHoursTF.textColor = [UIColor whiteColor];
    selectMinutesTF.textColor = [UIColor whiteColor];
    [selectHoursTF resignFirstResponder];
    [selectMinutesTF resignFirstResponder];
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"done" object:nil userInfo:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - inquire WorkingtimeSetting

- (void)inquireWorktimeSetting{

    UInt8 controlCode = 0x01;
    NSArray *dataMonToWendes = @[@0x00,@0x01,@0x0a,@0x00];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataMonToWendes failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
    [NSThread sleepForTimeInterval:0.5];
    NSArray *dataThursToSun = @[@0x00,@0x01,@0x0b,@0x00];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataThursToSun failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

- (void)recieveWorkingTimeMonToWendes:(NSNotification *)nsnotification{
    _flag = 1;
    
    //停掉重发机制
    [_timer setFireDate:[NSDate distantFuture]];
    
    NSDictionary *dict = [nsnotification userInfo];
    NSNumber *monHour = 0;
    NSNumber *tueHour = 0;
    NSNumber *wedHour = 0;
    
    NSNumber *monMinute = 0;
    NSNumber *tueMinute = 0;
    NSNumber *wedMinute = 0;
    
    NSNumber *monState = 0;
    NSNumber *tueState = 0;
    NSNumber *wedState = 0;
    
    if (dict[@"monHour"]) {
        monHour = dict[@"monHour"];
    }
    if (dict[@"tueHour"]) {
        tueHour = dict[@"tueHour"];
    }
    if (dict[@"wedHour"]) {
        wedHour = dict[@"wedHour"];
    }
    if (dict[@"monMinute"]) {
        monMinute = dict[@"monMinute"];
    }
    if (dict[@"tueMinute"]) {
        tueMinute = dict[@"tueMinute"];
    }
    if (dict[@"wedMinute"]) {
        wedMinute = dict[@"wedMinute"];
    }
    if (dict[@"monState"]) {
        monState = dict[@"monState"];
    }
    if (dict[@"tueState"]) {
        tueState = dict[@"tueState"];
    }
    if (dict[@"wedState"]) {
        wedState = dict[@"wedState"];
    }
    
    [_selectrowArray replaceObjectAtIndex:0 withObject:monHour];
    [_selectrowArray replaceObjectAtIndex:1 withObject:tueHour];
    [_selectrowArray replaceObjectAtIndex:2 withObject:wedHour];
    
    [_selectrowArray replaceObjectAtIndex:7 withObject:monMinute];
    [_selectrowArray replaceObjectAtIndex:8 withObject:tueMinute];
    [_selectrowArray replaceObjectAtIndex:9 withObject:wedMinute];
    
    [_selectrowArray replaceObjectAtIndex:14 withObject:monState];
    [_selectrowArray replaceObjectAtIndex:15 withObject:tueState];
    [_selectrowArray replaceObjectAtIndex:16 withObject:wedState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.workTimeTable reloadData];
    });
    
}
- (void)recieveWorkingTimeThursToSun:(NSNotification *)nsnotification{
    _flag = 1;
    
    //停掉重发机制
    [_timer setFireDate:[NSDate distantFuture]];
    
    NSDictionary *dict = [nsnotification userInfo];

    NSNumber *thuHour = 0;
    NSNumber *friHour = 0;
    NSNumber *satHour = 0;
    NSNumber *sunHour = 0;
    
    NSNumber *thuMinute = 0;
    NSNumber *friMinute = 0;
    NSNumber *satMinute = 0;
    NSNumber *sunMinute = 0;
    
    NSNumber *thuState = 0;
    NSNumber *friState = 0;
    NSNumber *satState = 0;
    NSNumber *sunState = 0;

    if (dict[@"thuHour"]) {
        thuHour = dict[@"thuHour"];
    }
    if (dict[@"friHour"]) {
        friHour = dict[@"friHour"];
    }
    if (dict[@"satHour"]) {
        satHour = dict[@"satHour"];
    }
    if (dict[@"sunHour"]) {
        sunHour = dict[@"sunHour"];
    }
    if (dict[@"thuMinute"]) {
        thuMinute = dict[@"thuMinute"];
    }
    if (dict[@"friMinute"]) {
        friMinute = dict[@"friMinute"];
    }
    if (dict[@"satMinute"]) {
        satMinute = dict[@"satMinute"];
    }
    if (dict[@"sunMinute"]) {
        sunMinute = dict[@"sunMinute"];
    }
    if (dict[@"thuState"]) {
        thuState = dict[@"thuState"];
    }
    if (dict[@"friState"]) {
        friState = dict[@"friState"];
    }
    if (dict[@"satState"]) {
        satState = dict[@"satState"];
    }
    if (dict[@"sunState"]) {
        sunState = dict[@"sunState"];
    }
    
    [_selectrowArray replaceObjectAtIndex:3 withObject:thuHour];
    [_selectrowArray replaceObjectAtIndex:4 withObject:friHour];
    [_selectrowArray replaceObjectAtIndex:5 withObject:satHour];
    [_selectrowArray replaceObjectAtIndex:6 withObject:sunHour];
    
    [_selectrowArray replaceObjectAtIndex:10 withObject:thuMinute];
    [_selectrowArray replaceObjectAtIndex:11 withObject:friMinute];
    [_selectrowArray replaceObjectAtIndex:12 withObject:satMinute];
    [_selectrowArray replaceObjectAtIndex:13 withObject:sunMinute];
    
    [_selectrowArray replaceObjectAtIndex:17 withObject:thuState];
    [_selectrowArray replaceObjectAtIndex:18 withObject:friState];
    [_selectrowArray replaceObjectAtIndex:19 withObject:satState];
    [_selectrowArray replaceObjectAtIndex:20 withObject:sunState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.workTimeTable reloadData];
    });
    
}

#pragma mark - set mower work time
- (void)setMowerWorkTimeMonToWendes {
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x0a,@0x01];
    NSMutableArray *arr = [NSMutableArray new];
    //0~7 小时 8～14 分钟 15～21
    [arr addObjectsFromArray:[self.selectrowArray subarrayWithRange:NSMakeRange(0, 3)]];
    [arr addObjectsFromArray:[self.selectrowArray subarrayWithRange:NSMakeRange(7, 3)]];
    [arr addObjectsFromArray:[self.selectrowArray subarrayWithRange:NSMakeRange(14, 3)]];
    NSArray *workData = [data arrayByAddingObjectsFromArray:arr];
    NSLog(@"MonToWendes - %@", workData);
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:workData failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

- (void)setMowerWorkTimeThursToSun {
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x0b,@0x01];
    NSMutableArray *arr = [NSMutableArray new];
    //0~6 小时 7～13 分钟 14～20
    [arr addObjectsFromArray:[self.selectrowArray subarrayWithRange:NSMakeRange(3, 4)]];
    [arr addObjectsFromArray:[self.selectrowArray subarrayWithRange:NSMakeRange(10, 4)]];
    [arr addObjectsFromArray:[self.selectrowArray subarrayWithRange:NSMakeRange(17, 4)]];
    NSArray *workData = [data arrayByAddingObjectsFromArray:arr];
    NSLog(@"ThursToSun - %@", workData);
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:workData failuer:nil andSuccessBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}
- (void)setMowerTime{
    NSTimeInterval currentTimeW = [NSDate date].timeIntervalSince1970;
    if (currentTimeW - timeW > 2 ) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [SVProgressHUD show];
            
            [self setMowerWorkTimeMonToWendes];
            [NSThread sleepForTimeInterval:0.5];
            [self setMowerWorkTimeThursToSun];
            
        });
        
        timeW = currentTimeW;
        
        [[NetWorkManager shareNetWorkManager].atimeOut fire];
        //超时判断
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            //定时器开启
            [[NetWorkManager shareNetWorkManager].atimeOut setFireDate:[NSDate distantPast]];
            
        });
        //延时 标志位
        [NetWorkManager shareNetWorkManager].timeOutFlag = 1;
    }
}

//- (void)goMowerTime
//{
//    if (_flag == 1) {
//        [self sentMowerTime];
//    }else{
//        //[NSObject showHudTipStr:LocalString(@"Data transmission failed")];
//        //显示弹出框列表选择
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"Working hours are all 0") preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"NO") style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction* sureAction = [UIAlertAction actionWithTitle:LocalString(@"Yes") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
//            //响应事件
//            self.flag = 1;
//            [self sentMowerTime];
//        }];
//        
//        [alert addAction:cancelAction];
//        [alert addAction:sureAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//    
//}


@end
