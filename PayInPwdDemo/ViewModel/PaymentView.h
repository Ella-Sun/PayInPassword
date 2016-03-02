//
//  PaymentView.h
//  PayInPasswordDemo
//
//  Created by IOS-Sun on 16/2/24.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransViewAfterView.h"

/**
 *  根据付款对象展示的列表格式
 */
typedef enum{
    PaymentTypeShopping = 1,//购物
    PaymentTypeCard,//信用卡还款
    PaymentTypeTurn,//转账
}PaymentType;

/**
 *  提示框弹出的形式
 */
typedef enum{
    PayAlertTypeAlert,//弹出的形式出现在屏幕中间
    PayAlertTypeSheet,//在下方出现
    PayAlertTypeOtherPage,//支付在另一个界面
}PayAlertType;



@interface PaymentView : TransViewAfterView


//提示框标题
@property (nonatomic, copy) NSString * title;

//付款方式选择
@property (nonatomic, copy) void(^cardInfo)(NSString * info);

@property (nonatomic, assign) NSInteger pwdCount;


/**
 *  左侧标题，可以根据payType赋值，也可自定义(自定义时，不可设置payType)
 */
@property (nonatomic, assign) BOOL      isChanged;//标示数组是否赋值，默认值NO
@property (nonatomic, strong) NSArray * leftTitles;


/**
 *  单元格右侧信息
 */
@property (nonatomic, strong) NSMutableArray * rightContents;
@property (nonatomic, copy)   NSString       * payDescrip;
@property (nonatomic, copy)   NSString       * payTool;
@property (nonatomic, assign) CGFloat          payAmount;

/**
 *  付款类型
 */
@property (nonatomic, assign) PaymentType payType;

/**
 *  提示框弹出类型
 */
@property (nonatomic, assign) PayAlertType alertType;


@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

/**
 *  显示付款详情提示框
 */
- (void)show;

/**
 *  刷新提示框数据
 */
- (void)reloadPaymentView;

@end
