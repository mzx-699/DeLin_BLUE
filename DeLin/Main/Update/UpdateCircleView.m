//
//  UpdateCircleView.m
//  BlueTooth测试
//
//  Created by apple on 2021/7/28.
//

#import "UpdateCircleView.h"

@implementation UpdateCircleView

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.x + rect.size.width * 0.5) radius:rect.size.width * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:1];
    [self.pathColor set];
    [path fill];

}

- (instancetype)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.pathColor = color;
    }
    return self;
}

@end
