//
//  PayInputView.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/25.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInputView : UIView

@property (nonatomic, assign) NSInteger pwdCount;

@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, copy) void (^completeHandle)(NSString *inputPwd);

- (void)refreshInputViews;

@end
