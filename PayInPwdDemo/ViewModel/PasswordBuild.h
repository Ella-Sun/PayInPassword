//
//  PasswordBuild.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/29.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  对数字密码进行的操作
 */
typedef enum{
    PwdOperationTypeCreate,//创建数字支付密码
    PwdOperationTypeReset,//重设数字支付密码
}PwdOperationType;

@interface PasswordBuild : UIView


//密码的位数，默认为6位
@property (nonatomic, assign)NSInteger pwdCount;

/**
 *  数字密码操作类型
 */
@property (nonatomic, assign)PwdOperationType pwdOperationType;

/**
 *  创建数字密码
 */
@property (nonatomic, copy)void(^PwdInit)(NSString * pwd);

/**
 *  进行密码验证
 */
@property (nonatomic, copy)void(^PwdInput)(NSString * pwd);

/**
 *  重新设置的数字密码
 */
@property (nonatomic, copy)void(^PwdReBuild)(NSString * pwd);


/**
 *  显示数字密码输入框
 */
- (void)show;

/**
 *  验证原始密码输入是否正确
 */
- (void)verifyPwdisCorrect:(BOOL)isCorrect;

/**
 *  清除textfield的内容
 *
 *  @param num 操作的行数
 */
- (void)clearTextFieldTextWithLineNum:(NSInteger)num;

@end
