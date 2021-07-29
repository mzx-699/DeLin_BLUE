//
//  UpdateView.m
//  BlueTooth测试
//
//  Created by apple on 2021/7/28.
//

#import "UpdateView.h"
#import "UpdateCircleView.h"
@implementation UpdateView


//Only override drawRect: if you perform custom drawing.
//An empty implementation adversely affects performance during animation.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    UpdateCircleView *updateViewBottom = [[UpdateCircleView alloc] initWithColor:[UIColor colorWithRed:83/255.0 green:236/255.0 blue:0/255.0 alpha:0.2]];
    updateViewBottom.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    
    UpdateCircleView *updateViewMiddle = [[UpdateCircleView alloc] initWithColor:[UIColor colorWithRed:83/255.0 green:236/255.0 blue:0/255.0 alpha:0.4]];
    updateViewMiddle.frame = CGRectMake(0, 0, self.frame.size.width - 30, self.frame.size.width - 30);
    
    UpdateCircleView *updateViewTop = [[UpdateCircleView alloc] initWithColor:[UIColor colorWithRed:83/255.0 green:236/255.0 blue:0/255.0 alpha:0.8]];
    updateViewTop.frame = CGRectMake(0, 0, self.frame.size.width - 60, self.frame.size.width - 60);
    
    updateViewTop.center = updateViewBottom.center;
    updateViewMiddle.center = updateViewBottom.center;
    
    updateViewBottom.backgroundColor = [UIColor clearColor];
    updateViewMiddle.backgroundColor = [UIColor clearColor];
    updateViewTop.backgroundColor = [UIColor clearColor];
    
    [self addSubview:updateViewBottom];
    [self addSubview:updateViewMiddle];
    [self addSubview:updateViewTop];
    
    CAKeyframeAnimation *animTop = [CAKeyframeAnimation new];
    animTop.keyPath = @"opacity";
    animTop.duration = 4;
    animTop.repeatCount = INT_MAX;
    animTop.fillMode = kCAFillModeForwards;
    animTop.removedOnCompletion = NO;
    animTop.values = @[@(0.8), @(0.5), @(0.1), @(0.5),@(0.8)];
    animTop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [updateViewTop.layer addAnimation:animTop forKey:nil];
    
    CAKeyframeAnimation *animMiddle = [CAKeyframeAnimation new];
    animMiddle.keyPath = @"opacity";
    animMiddle.duration = 8;
    animMiddle.repeatCount = INT_MAX;
    animMiddle.fillMode = kCAFillModeForwards;
    animMiddle.removedOnCompletion = NO;
    animMiddle.values = @[@(0.4), @(0.6) ,@(0.2), @(0.6), @(0.4)];
    animMiddle.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [updateViewMiddle.layer addAnimation:animMiddle forKey:nil];
    
    CAKeyframeAnimation *animBottom = [CAKeyframeAnimation new];
    animBottom.keyPath = @"opacity";
    animBottom.duration = 4;
    animBottom.repeatCount = INT_MAX;
    animBottom.fillMode = kCAFillModeForwards;
    animBottom.removedOnCompletion = NO;
    animBottom.values = @[@(0.2), @(0.6), @(1), @(0.6), @(0.2)];
    animBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [updateViewBottom.layer addAnimation:animBottom forKey:nil];
}

@end
