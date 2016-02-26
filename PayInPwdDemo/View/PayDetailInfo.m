//
//  PayDetailInfo.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/25.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "PayDetailInfo.h"
#import "PaymentCell.h"

#define TITLE_HEIGHT 46

@interface PayDetailInfo ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *closeBtn,*backBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line;

@end

@implementation PayDetailInfo

#pragma mark -

- (NSMutableArray *)rightContents {
    if (!_rightContents) {
        _rightContents = [NSMutableArray array];
    }
    return _rightContents;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        self.titleLabel.text = _title;
    }
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefaultViews];
        [self setNeedsLayout];
    }
    return self;
}

- (void)initDefaultData {
    self.title = @"付款详情";
}

/**
 *  创建初始视图
 */
- (void)createDefaultViews {

//    CGFloat paymentWidth = self.bounds.size.width;
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.tag = 111;
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.titleLabel];
    
    //关闭按钮
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn.tag = 112;
    [self.closeBtn setFrame:CGRectZero];
    [self.closeBtn setTitle:@"╳" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.closeBtn];
    
    //横线
    self.line = [[UILabel alloc]initWithFrame:CGRectZero];
    self.line.tag = 113;
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line];
    
    //展示详情tableview
//    CGFloat tableHeight = 180;//self.inputView.frame.origin.y - TITLE_HEIGHT;
    CGRect tableFrame = CGRectZero;
    self.detailTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.detailTable.tag = 114;
    self.detailTable.backgroundColor = [UIColor clearColor];
    self.detailTable.dataSource = self;
    self.detailTable.delegate = self;
    self.detailTable.bounces = NO;
    self.detailTable.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.detailTable];
}

- (UIButton *)createCommonButton {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectZero;

    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    return button;
}

#pragma mark - dismiss

- (void)dismiss {
    self.dismissBtnBlock();
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat paymentWidth = self.bounds.size.width;
    CGFloat tableHeight = 180;
    
    CGRect titleFrame = CGRectMake(0, 0, paymentWidth, TITLE_HEIGHT);
    CGRect canelcFrame = CGRectMake(0, 0, TITLE_HEIGHT, TITLE_HEIGHT);
    CGRect lineFrame = CGRectMake(0, TITLE_HEIGHT, paymentWidth, .5f);
    CGRect tableFrame = CGRectMake(0, TITLE_HEIGHT+1, self.frame.size.width, tableHeight);
    
    self.titleLabel.frame = titleFrame;
    self.closeBtn.frame = canelcFrame;
    self.line.frame = lineFrame;
    self.detailTable.frame = tableFrame;
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
    detailLabel.text = self.rightContents[indexPath.row];
    
    return cell;
}

#pragma mark - tableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat maxHeight = self.detailTable.frame.size.height;
    NSInteger count = self.leftTitles.count;
    NSInteger cellHeight = maxHeight/count;
    if (cellHeight != 50) {
        
        cellHeight = 50;
        
        CGFloat tableHeight = cellHeight * count;
        
        CGRect tableFrame = self.detailTable.frame;
        tableFrame.size.height = tableHeight;
        self.detailTable.frame = tableFrame;
        
        CGFloat interHeight = maxHeight - tableHeight;
        
        self.changeFrameBlock(interHeight);
    }
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * payMean = self.leftTitles[indexPath.row];
    if ([payMean isEqualToString:@"付款方式"]) {
        NSLog(@"选择支付的银行卡");
    }
}


@end
