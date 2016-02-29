//
//  DetailInfoView.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/29.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInfoView : UIView

//提示框标题
@property (nonatomic, copy) NSString * title;

//详情
@property (nonatomic, strong) UITableView * detailTable;


/**
 *  点击关闭按钮
 */
@property (nonatomic, copy) void(^dismissBtnBlock)();


/**
 *  点击返回按钮
 */
@property (nonatomic, copy) void(^backBtnBlock)();

@end
