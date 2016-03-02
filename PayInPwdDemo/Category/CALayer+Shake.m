//
//  CALayer+Shake.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/3/2.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "CALayer+Shake.h"

@implementation CALayer (Shake)

/*
 *  摇动
 */
- (void)shake {
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 16;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = .2f;
    
    //重复
    kfa.repeatCount = 2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end
