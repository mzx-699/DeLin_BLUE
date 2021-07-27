//
//  AppDelegate.m
//  DeLin
//
//  Created by 安建伟 on 2019/10/22.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "WelcomeViewController.h"
#import "IQKeyboardManager.h"
#import "DeviceInfoViewController.h"
#import "WorkTimeViewController.h"
#import "InputPINViewController.h"
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //错误日志上报
    //[Bugly startWithAppId:@"d01e9040cb"];
    
    [self customizeInterface];
    [self keyBoardManager];
    

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    DeviceInfoViewController *deviceInfoVC = [[DeviceInfoViewController alloc] init];
//    WorkTimeViewController *vc = [WorkTimeViewController new];
    //判断是否是第一次启动
    //好像如果读取bool值没有该key的时候默认为NO，没有nil的情况了
    self.navController = [[UINavigationController alloc] initWithRootViewController:deviceInfoVC];
//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"] == NO) {
//        NSLog(@"第一次启动");
//        _navController = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
//    }else if([[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"] == YES){
//        NSLog(@"非第一次启动");
//
//        _navController = [[UINavigationController alloc] initWithRootViewController:deviceInfoVC];
//    }
    self.window.rootViewController = _navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)customizeInterface {
    _navigationBarAppearance = [UINavigationBar appearance];
    //navigationBarAppearance.barTintColor = [UIColor clearColor];
    [_navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    _navigationBarAppearance.barStyle = UIBarStyleBlack;
    //设置导航栏背景图片为一个空的image，这样就透明了
    [_navigationBarAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉返回按钮上的文字 //将title 文字的颜色改为透明
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}forState:UIControlStateNormal];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:17.f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [_navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    //去掉透明后导航栏下边的黑边
    [_navigationBarAppearance setShadowImage:[[UIImage alloc] init]];
    [_navigationBarAppearance clearsContextBeforeDrawing];
    

     
}

- (void)keyBoardManager{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.toolbarDoneBarButtonItemText = LocalString(@"Done");
    manager.shouldResignOnTouchOutside = YES;//键盘弹出时，点击背景，键盘收回
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
}

@end
