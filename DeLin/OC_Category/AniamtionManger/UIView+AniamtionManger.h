//
//  AniamtionManger.h
//  DeLin
//
//  Created by 安建伟 on 2019/11/28.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Common)

-(void)fadeAnimation;

/**
 *  移动
 */

-(void)moveInAnimation;
-(void)pushAnimation;
-(void)revealAnimation;

//-----------------------------private api------------------------------------
/*
 Don't be surprised if Apple rejects your app for including those effects,
 and especially don't be surprised if your app starts behaving strangely after an OS update.
 */
/**
 *  立体翻滚效果
 */
-(void)cubeAnimation;

-(void)suckEffectAnimation;

-(void)oglFlipAnimation;

-(void)rippleEffectAnimation;

-(void)pageCurlAnimation;

-(void)pageUnCurlAnimation;

-(void)cameraIrisHollowOpenAnimation;

-(void)cameraIrisHollowCloseAnimation;

/*
 基础动画
 */

/**
 *  位移动画演示
 */
-(void)positionAnimation;

/**
 *  透明度动画
 */
-(void)opacityAniamtion;
/**
 *  缩放动画
 */
-(void)scaleAnimation;

/**
 *  旋转动画
 */
-(void)rotateAnimation;

/**
 *  背景色变化动画
 */
-(void)backgroundAnimation;

@end

NS_ASSUME_NONNULL_END
