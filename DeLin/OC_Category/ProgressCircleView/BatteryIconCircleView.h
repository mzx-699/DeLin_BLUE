//
//  BatteryIconCircleView.h
//  DeLin
//
//  Created by 杭州轨物科技有限公司 on 2020/3/27.
//  Copyright © 2020年 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BatteryIconCircleView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) float progress; /**< 进度条进度 0-1*/

@property(nonatomic,assign)float progressWidth;

@property(nonatomic,strong)UIColor *bottomCircleColor;

@property(nonatomic,strong)UIColor *topCircleColor;

@property(nonatomic,strong)UILabel *centerLabel;

@end

NS_ASSUME_NONNULL_END
