//
//  BaseViewController.m
//  steamRoom
//
//  Created by 安建伟 on 2019/7/1.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //背景色
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    //title字体颜色
//    self.title = LocalString(@"ROBOT MOWER");
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}];
//    //导航栏背景颜色
//    [self.navigationController.navigationBar navBarBackGroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] image:nil isOpaque:YES];
//    //背景高度];
//    [self.navigationController.navigationBar navBarMyLayerHeight:getRectNavAndStatusHight isOpaque:YES];
  
}

@end
