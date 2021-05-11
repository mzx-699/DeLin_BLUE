//
//  BatteryIconCircleView.m
//  DeLin
//
//  Created by 杭州轨物科技有限公司 on 2020/3/27.
//  Copyright © 2020年 com.thingcom. All rights reserved.
//

#import "BatteryIconCircleView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

#define lineWH 217

@implementation BatteryIconCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.progressWidth = 3.0;
    self.bottomCircleColor = [UIColor greenColor];
    self.topCircleColor = [UIColor redColor];
    
    [self addSubview:self.bgView];
    self.centerLabel = [self centerLabel];
}

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
    }
    return _bgView;
}

- (UILabel *)centerLabel{
    if (_centerLabel == nil) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.textColor = [UIColor whiteColor];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.adjustsFontSizeToFitWidth = YES;
        _centerLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:35];
        _centerLabel.text = @"0%";
        [self addSubview:self.centerLabel];
        
        if (yDevice_Is_iPhoneXR_iPhone11 || yDevice_Is_iPhoneXS_MAX_iPhone11ProMax || yDevice_Is_iPhoneX_iPhone11Pro) {
            
            self.bgView.frame = CGRectMake(0, 0, yAutoFit(lineWH + 45), yAutoFit(lineWH + 40));
            
        }else{
            self.bgView.frame = CGRectMake(0, 0, yAutoFit(lineWH), yAutoFit(lineWH));
        }
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(100.f), yAutoFit(40.f)));
            make.centerX.equalTo(self.bgView.mas_centerX);
            make.centerY.equalTo(self.bgView.mas_centerY);
        }];
    }
    return _centerLabel;
}

- (void)drawRect:(CGRect)rect{
    
    //方法一
    /*
     CGContextRef ctx =  UIGraphicsGetCurrentContext();
     //底部的圆
     CGContextAddArc(ctx, WIDTH/2.0, WIDTH/2.0, (WIDTH-self.progressWidth*2.0)/2.0, 0, M_PI*2.0, 0);
     [self.bottomCircleColor setStroke];
     CGContextSetLineWidth(ctx, self.progressWidth);
     CGContextStrokePath(ctx);
     
     
     //顶部的动圆
     CGFloat endAngle = -M_PI_2 + self.progress*(M_PI * 2);
     
     // x\y : 圆心
     // radius : 半径
     // startAngle : 开始角度
     // endAngle : 结束角度
     // clockwise : 圆弧的伸展方向(0:顺时针, 1:逆时针)
     CGContextAddArc(ctx, WIDTH/2.0, WIDTH/2.0, (WIDTH-self.progressWidth*2.0)/2.0, -M_PI_2, endAngle, 0);
     
     [self.topCircleColor setStroke];
     
     CGContextSetLineWidth(ctx, self.progressWidth);
     
     CGContextStrokePath(ctx);
     */
    
    //方法二
    //底部的圆
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WIDTH/2.0, WIDTH/2.0) radius:(WIDTH-self.progressWidth*2.0)/2.0 startAngle:0 endAngle:M_PI*2.0 clockwise:0];
    //设置线的宽度
    CGContextSetLineWidth(ctx, self.progressWidth);
    //线条的颜色
    [self.bottomCircleColor setStroke];
    //将路径添加到上下文
    CGContextAddPath(ctx, bottomPath.CGPath);
    //渲染路径
    CGContextStrokePath(ctx);
    
    //顶部的圆
    CGFloat endAngle = M_PI+ self.progress*(M_PI * 2);
    UIBezierPath *topPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WIDTH/2.0, WIDTH/2.0) radius:(WIDTH-self.progressWidth*2.0)/2.0 startAngle:M_PI_2 *2.0 endAngle:endAngle clockwise:0];
    //设置线的宽度
    CGContextSetLineWidth(ctx, self.progressWidth);
    //线条的颜色
    [self.topCircleColor setStroke];
    //将路径添加到上下文
    CGContextAddPath(ctx, topPath.CGPath);
    //渲染路径
    CGContextStrokePath(ctx);
    
}

-  (void)setProgress:(float)progress{
    
    if (_progress != progress) {
        _progress = progress;
        
        if (progress > 1.0 || progress < 0) {
            return;
        }
        self.centerLabel.text = [NSString stringWithFormat:@"%.f%%",progress*100];
        
        [self setNeedsDisplay];
        
    }
}


@end

