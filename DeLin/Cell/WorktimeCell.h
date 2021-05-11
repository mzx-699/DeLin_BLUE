//
//  WorktimeCell.h
//  MOWOX
//
//  Created by Mac on 2017/12/11.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CallBackBlock)(BOOL);

@interface WorktimeCell : UITableViewCell
@property (strong, nonatomic) UILabel *weekLabel;
@property (strong, nonatomic) UITextField *worksHoursTF;
@property (strong, nonatomic) UITextField *worksMinutesTF;
@property (strong,nonatomic) UISwitch *workTimeSwitch;

@property (nonatomic,strong) CallBackBlock block;

@end
