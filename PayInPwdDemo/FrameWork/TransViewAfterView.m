//
//  TransViewAfterView.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/29.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "TransViewAfterView.h"

#define ANIMATE_TIME .8f

@implementation TransViewAfterView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animateTime = ANIMATE_TIME;
        self.translateType = PayTranslateTypeTurn;
    }
    return self;
}

/**
 *  切换视图
 *
 *  @param currentView 当前视图
 *  @param lastView    将要展现的视图
 */
- (void)transformDirection:(BOOL)isLeft withCurrentView:(UIView *)currentView withLastView:(UIView *)lastView {
    
    switch (self.translateType) {
        case PayTranslateTypeTurn:{
            [self turnWithCurrentView:currentView withLastView:lastView];
        }
            break;
        case PayTranslateTypeSlide:{
            [self slideDirection:isLeft withCurrentView:currentView withLastView:lastView];
        }
            break;
            
        default:
            NSLog(@"切换视图类型传值错误");
            break;
    }
    
}

//翻转切换视图
- (void)turnWithCurrentView:(UIView *)currentView withLastView:(UIView *)lastView {
    CGFloat offset = currentView.frame.size.height * .5;
    lastView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 0), CGAffineTransformTranslate(currentView.transform, 0, -offset));
    lastView.alpha = 0;
    lastView.hidden = NO;
    
    CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0f, 0.01f), CGAffineTransformMakeTranslation(1.0, offset));
    
    [UIView animateWithDuration:self.animateTime animations:^{
        lastView.transform = CGAffineTransformIdentity;
        currentView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.21f, 0.1), CGAffineTransformTranslate(currentView.transform, 0, -offset));
        lastView.alpha = 1;
        currentView.transform = transform;
        currentView.alpha = 0;
    }];
}

//滑动切换视图
- (void)slideDirection:(BOOL)isLeft withCurrentView:(UIView *)currentView withLastView:(UIView *)lastView {
    NSLog(@"正确传值");
    CGFloat offset = self.frame.size.width;
    CGAffineTransform leftTransform = CGAffineTransformMakeTranslation(-offset, 0);
    CGAffineTransform rightTransform = CGAffineTransformMakeTranslation(offset, 0);
    CGAffineTransform currentTransform,lastTransform;
    if (isLeft) {
        currentTransform = leftTransform;
        lastTransform = rightTransform;
    } else {
        lastTransform = leftTransform;
        currentTransform = rightTransform;
    }
    
    lastView.transform = lastTransform;
    lastView.hidden = NO;
    
    [UIView animateWithDuration:self.animateTime animations:^{
        currentView.transform = currentTransform;
        lastView.transform = CGAffineTransformIdentity;
    }];
}


/**
 *  使当前视图消失
 *
 *  @param currentView 当前视图
 */
- (void)dismissWithCurrentView:(UIView *)currentView {
    
    [UIView animateWithDuration:0.3f animations:^{
        currentView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        currentView.alpha = 0;
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
