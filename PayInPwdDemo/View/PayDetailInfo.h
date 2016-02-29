//
//  PayDetailInfo.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/25.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailInfoView.h"


@interface PayDetailInfo : DetailInfoView

/**
 *  左侧标题
 */
@property (nonatomic, strong) NSArray * leftTitles;


/**
 *  单元格右侧信息
 */
@property (nonatomic, strong) NSMutableArray * rightContents;

/**
 *  选择支付的卡片信息
 */
@property (nonatomic, copy) void(^choosePayCard)();

/**
 *  改变整体界面的高度
 */
@property (nonatomic, copy) void(^changeFrameBlock)(CGFloat interHeight);



@end
