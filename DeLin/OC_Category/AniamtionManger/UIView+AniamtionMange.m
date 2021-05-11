//
//  AniamtionManger.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/28.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "UIView+AniamtionManger.h"

@implementation UIView (Common)

/*
 1.TransitionAnimation:
@"fade",@"moveIn",@"push",@"reveal",@"cube",@"suck",@"oglFlip",@"ripple",@"Curl",@"UnCurl",@"caOpen",@"caClose"
 */
/*
2.TransitionAnimation:
 位移 透明 缩放 旋转 背景变化
*/

//-----------------------------public api------------------------------------
/*
 type:
 kCATransitionFade;
 kCATransitionMoveIn;
 kCATransitionPush;
 kCATransitionReveal;
 */
/*
 subType:
 kCATransitionFromRight;
 kCATransitionFromLeft;
 kCATransitionFromTop;
 kCATransitionFromBottom;
 */

/**
 *  逐渐消失
 */
-(void)fadeAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionFade;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    //anima.startProgress = 0.3;//设置动画起点
    //anima.endProgress = 0.8;//设置动画终点
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"fadeAnimation"];
}

/**
 *  移动
 */

-(void)moveInAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionMoveIn;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"moveInAnimation"];
}


-(void)pushAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionPush;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"pushAnimation"];
}

-(void)revealAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionReveal;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"revealAnimation"];
}

//-----------------------------private api------------------------------------
/*
 Don't be surprised if Apple rejects your app for including those effects,
 and especially don't be surprised if your app starts behaving strangely after an OS update.
 */


/**
 *  立体翻滚效果
 */
-(void)cubeAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"cube";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"revealAnimation"];
}


-(void)suckEffectAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"suckEffect";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"suckEffectAnimation"];
}

-(void)oglFlipAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"oglFlip";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"oglFlipAnimation"];
}

-(void)rippleEffectAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"rippleEffect";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"rippleEffectAnimation"];
}

-(void)pageCurlAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"pageCurl";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"pageCurlAnimation"];
}

-(void)pageUnCurlAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"pageUnCurl";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"pageUnCurlAnimation"];
}

-(void)cameraIrisHollowOpenAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"cameraIrisHollowOpen";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"cameraIrisHollowOpenAnimation"];
}

-(void)cameraIrisHollowCloseAnimation{
    
    CATransition *anima = [CATransition animation];
    anima.type = @"cameraIrisHollowClose";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.layer addAnimation:anima forKey:@"cameraIrisHollowCloseAnimation"];
}

/*
 基础动画
 */

/**
 *  位移动画演示
 */
-(void)positionAnimation{
    //使用CABasicAnimation创建基础动画
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2, ScreenHeight/2-75)];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2, ScreenHeight/2)];
    anima.duration = 1.0f;
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:anima forKey:@"positionAnimation"];
    
    
    //使用UIView Animation 代码块调用
    //    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
    //    [UIView animateWithDuration:1.0f animations:^{
    //        _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
    //    } completion:^(BOOL finished) {
    //        _demoView.frame = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-50, 50, 50);
    //    }];
    //
    //使用UIView [begin,commit]模式
    //    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:1.0f];
    //    _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
    //    [UIView commitAnimations];
}

/**
 *  透明度动画
 */
-(void)opacityAniamtion{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:1.0f];
    anima.toValue = [NSNumber numberWithFloat:0.2f];
    anima.duration = 1.0f;
    [self.layer addAnimation:anima forKey:@"opacityAniamtion"];
}

/**
 *  缩放动画
 */
-(void)scaleAnimation{
    //    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"bounds"];
    //    anima.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    //    anima.duration = 1.0f;
    //    [_demoView.layer addAnimation:anima forKey:@"scaleAnimation"];
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//同上
    anima.toValue = [NSNumber numberWithFloat:2.0f];
    anima.duration = 2.5f;
    [self.layer addAnimation:anima forKey:@"scaleAnimation"];
    
    //    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    //    anima.toValue = [NSNumber numberWithFloat:0.2f];
    //    anima.duration = 1.0f;
    //    [_demoView.layer addAnimation:anima forKey:@"scaleAnimation"];
}

/**
 *  旋转动画
 */
-(void)rotateAnimation{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:M_PI];
    anima.duration = 1.0f;
    [self.layer addAnimation:anima forKey:@"rotateAnimation"];
    
    //    //valueWithCATransform3D作用与layer
    //    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform"];
    //    anima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];//绕着矢量（x,y,z）旋转
    //    anima.duration = 1.0f;
    //    //anima.repeatCount = MAXFLOAT;
    //    [_demoView.layer addAnimation:anima forKey:@"rotateAnimation"];
    
    //    //CGAffineTransform作用与View
    //    _demoView.transform = CGAffineTransformMakeRotation(0);
    //    [UIView animateWithDuration:1.0f animations:^{
    //        _demoView.transform = CGAffineTransformMakeRotation(M_PI);
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

/**
 *  背景色变化动画
 */
-(void)backgroundAnimation{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anima.toValue =(id) [UIColor greenColor].CGColor;
    anima.duration = 1.0f;
    [self.layer addAnimation:anima forKey:@"backgroundAnimation"];
}

@end


