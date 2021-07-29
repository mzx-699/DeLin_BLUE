//
//  UpdateCircleView.h
//  BlueTooth测试
//
//  Created by apple on 2021/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateCircleView : UIView
@property (nonatomic, strong) UIColor *pathColor;
- (instancetype)initWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
