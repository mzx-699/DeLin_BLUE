//
//  AAlertViewController.h
//  Coffee
//
//  Created by 安建伟 on 2019/9/16.
//  Copyright © 2019 杭州轨物科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(void);

@interface AAlertViewController : UIViewController

@property (nonatomic) float WScale_alert;
@property (nonatomic) float HScale_alert;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *centeredBtn;
@property (nonatomic) Block Block;

- (void)showView;

@end

NS_ASSUME_NONNULL_END
