//
//  UIViewController+Common.m
//  myapp
//
//  Created by 安建伟 on 2019/7/23.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

#pragma mark - 获取window根视图

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    while (currentVC.presentedViewController && ![currentVC.presentedViewController isKindOfClass:[YAlertViewController class]]) {
        currentVC = [self getCurrentVCFrom:currentVC.presentedViewController];
    }
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    //    if ([rootVC presentedViewController]) {
    //        // 视图是被presented出来的
    //        rootVC = [rootVC presentedViewController];
    //    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
