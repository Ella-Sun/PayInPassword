//
//  PayDetailInfo.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/25.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "PayDetailInfo.h"
#import "PaymentCell.h"


@interface PayDetailInfo ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) CGFloat interHeight;

@end

@implementation PayDetailInfo

#pragma mark -

- (NSMutableArray *)rightContents {
    if (!_rightContents) {
        _rightContents = [NSMutableArray array];
    }
    return _rightContents;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultData];
//        [self setNeedsLayout];
    }
    return self;
}

- (void)initDefaultData {
//    self.title = @"付款详情";
    self.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
    self.detailTable.dataSource = self;
    self.detailTable.delegate = self;
}


#pragma mark - tableviewDatesource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * payCell = @"payCell";
    
    PaymentCell * cell = [PaymentCell paymentCellWithTableView:tableView reuseIdentifier:payCell];
    
    UILabel * titleLabel = [cell viewWithTag:121];
    UILabel * detailLabel = [cell viewWithTag:122];
    
    NSString * payMean = self.leftTitles[indexPath.row];
    if ([payMean isEqualToString:@"付款方式"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    titleLabel.text = payMean;
    
    NSString * detailTxt = self.rightContents[indexPath.row];
    /*
    if ([self isPureInt:detailTxt]) {
        //全部是数字
    }
     */

    detailLabel.text = detailTxt;
    
    return cell;
}

/*
- (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (isNum && (string.length > 8)) {
        //全部是数字
        if (string.length > 8) {
            ;
        }
    }
    return isNum;
}
 */

#pragma mark - tableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat maxHeight = self.detailTable.frame.size.height;
    NSInteger count = self.leftTitles.count;
    NSInteger cellHeight = maxHeight/count;
    if (cellHeight > 50) {
        
        cellHeight = 50;
        
        CGFloat tableHeight = cellHeight * count;
        
        CGRect tableFrame = self.detailTable.frame;
        tableFrame.size.height = tableHeight;
        self.detailTable.frame = tableFrame;
        
        self.interHeight = maxHeight - tableHeight;
        
        self.changeFrameBlock(self.interHeight);
    }
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * payMean = self.leftTitles[indexPath.row];
    if ([payMean isEqualToString:@"付款方式"]) {
        self.choosePayCard();
    }
}


@end
