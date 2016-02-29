//
//  TransViewAfterView.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/29.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  两个页面切换的效果
 */
typedef enum{
    PayTranslateTypeTurn,//在同一个界面内翻转，替换
    PayTranslateTypeSlide,//滑动，替换
}PayTranslateType;

@interface TransViewAfterView : UIView

@property (nonatomic, assign) CGFloat animateTime;

@property (nonatomic, assign) PayTranslateType translateType;

/**
 *  切换视图
 *
 *  @param currentView 当前视图
 *  @param lastView    将要展现的视图
 */
- (void)transformDirection:(BOOL)isLeft withCurrentView:(UIView *)currentView withLastView:(UIView *)lastView;

/**
 *  使当前视图消失
 *
 *  @param currentView 当前视图
 */
- (void)dismissWithCurrentView:(UIView *)currentView;

@end
