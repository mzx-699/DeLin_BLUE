//
//  SetLanguageViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/25.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "SetLanguageViewController.h"
#import "YULanguageManager.h"
#import "DeviceInfoViewController.h"

@interface SetLanguageViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *languagePicker;
@property (strong, nonatomic) UIButton *oKButton;

@property (nonatomic, strong) NSMutableArray  *languageChooseArray;

@end

@implementation SetLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.languagePicker = [self languagePicker];
    self.oKButton = [self oKButton];
    
    [self initLanguageUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Set the language");
}

-(UIPickerView *)languagePicker{
    if (!_languagePicker) {
        _languagePicker = [[UIPickerView alloc] init];
        _languagePicker.backgroundColor = [UIColor clearColor];
        //原版本app语言选择
        /*self.languageChooseArray = [NSMutableArray arrayWithArray:@[LocalString(@"English"),LocalString(@"Danish"),LocalString(@"Dutch"),LocalString(@"Finnish"),LocalString(@"French"),LocalString(@"German"),LocalString(@"Italian"),LocalString(@"Norwegian"),LocalString(@"Russian"),LocalString(@"Portuguese"),LocalString(@"Spanish")]];*/
        //excel表格要求语言
        self.languageChooseArray = [NSMutableArray arrayWithArray:@[LocalString(@"English"),LocalString(@"Portuguese"),LocalString(@"Italian"),LocalString(@"Spanish"),LocalString(@"Polish"),LocalString(@"Slovenian"),LocalString(@"Danish"),LocalString(@"Noewegian"),LocalString(@"Czech"),LocalString(@"Finnish"),LocalString(@"Slovak"),LocalString(@"Hungarian"),LocalString(@"French"),LocalString(@"German"),LocalString(@"Swedish"),LocalString(@"Russian")]];
        
        self.languagePicker.dataSource = self;
        self.languagePicker.delegate = self;
        //在当前选择上显示一个透明窗口
        self.languagePicker.showsSelectionIndicator = YES;
        //初始化，自动转一圈，避免第一次是数组第一个值造成留白
        [self.languagePicker selectRow:[self.languageChooseArray count] inComponent:0 animated:YES];
        [self.view addSubview:_languagePicker];
        
        [_languagePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth,yAutoFit(400)));
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(30.f));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _languagePicker;
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
        [_oKButton setTitle:LocalString(@"Choose your language") forState:UIControlStateNormal];
        [_oKButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_oKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oKButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_oKButton addTarget:self action:@selector(setLanguageChoose) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Action

- (void)initLanguageUI{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [userDefaults valueForKey:@"language"];
    if (language!=nil) {
        NSInteger index = [self.languageChooseArray indexOfObject:language];
        //保持循环显示UI
        NSUInteger max = 16384;
        NSUInteger base0 = (max / 2) - (max / 2) % _languageChooseArray.count;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.languagePicker selectRow:index % self.languageChooseArray.count + base0  inComponent:0 animated:YES];
        });
    }
}

- (void)setLanguageChoose
{
    NSInteger row = [self.languagePicker selectedRowInComponent:0];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.languageChooseArray[row % _languageChooseArray.count] forKey:@"language"];
    [userDefaults synchronize];
    switch (row % _languageChooseArray.count) {
        //English
        case 0:
            [YULanguageManager setUserLanguage:@"en"];
            break;
        //Danish
        //Portuguese
        case 1:
            [YULanguageManager setUserLanguage:@"pt"];
            break;
        //Dutch
        //Italian
        case 2:
            [YULanguageManager setUserLanguage:@"it"];
            break;
        //French
        //Spanish
        case 3:
            [YULanguageManager setUserLanguage:@"es-ES"];
            break;
        //German
        //Polish
        case 4:
            [YULanguageManager setUserLanguage:@"pl"];
            break;
        //Italian
        //Slovenian
        case 5:
            [YULanguageManager setUserLanguage:@"sl"];
            break;
        //Norwegian
        //Danish
        case 6:
            [YULanguageManager setUserLanguage:@"da"];
            break;
        //Russian
        //Noewegian
        case 7:
            [YULanguageManager setUserLanguage:@"nn"];
            break;
        //Portuguese
        //Czech
        case 8:
            [YULanguageManager setUserLanguage:@"cs"];
            break;
        //Spanish
        //Finnish
        case 9:
            [YULanguageManager setUserLanguage:@"fi"];
            break;
        //Slovak
        case 10:
        [YULanguageManager setUserLanguage:@"sk"];
        break;
        //Hungarian
        case 11:
        [YULanguageManager setUserLanguage:@"hu"];
        break;
        //French
        case 12:
        [YULanguageManager setUserLanguage:@"fr"];
        break;
        //German
        case 13:
        [YULanguageManager setUserLanguage:@"de"];
        break;
        //Swedish
        case 14:
        [YULanguageManager setUserLanguage:@"sv-SE"];
        case 15:
        [YULanguageManager setUserLanguage:@"ru"];
        break;
        default:
            break;
    }
    //延时1秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
//    //解决奇怪的动画bug。
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        DeviceInfoViewController *deviceInfoVC = [[DeviceInfoViewController alloc] init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = deviceInfoVC;
//
//
//    });
    
    //解决奇怪的动画bug。
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        DeviceInfoViewController *deviceInfoVC = [[DeviceInfoViewController alloc] init];
        appDelegate.navController = [[UINavigationController alloc] initWithRootViewController:deviceInfoVC];
        appDelegate.window.rootViewController= appDelegate.navController;

    });
    
    
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
    
    return [NSString stringWithFormat:@"%@",self.languageChooseArray[row % _languageChooseArray.count]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSUInteger max = 16384;
    
    NSUInteger base0 = (max / 2) - (max / 2) % _languageChooseArray.count;
    [self.languagePicker selectRow:[_languagePicker selectedRowInComponent:component] % _languageChooseArray.count + base0 inComponent:component animated:NO];
    
}

@end
