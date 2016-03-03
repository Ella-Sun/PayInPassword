//
//  PayInputView.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/25.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInputView : UIView

//密码位数
@property (nonatomic, assign) NSInteger pwdCount;

@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, copy) void (^completeHandle)(NSString *inputPwd);

@property (nonatomic, copy) void(^clickBlock)();

/**
 *  刷新输入界面（主要是密码位数）
 */
- (void)refreshInputViews;

/**
 *  隐藏代表密码显示的点
 *
 *  @param count 显示的点的个数
 */
- (void)setDotWithCount:(NSInteger)count;

@end
