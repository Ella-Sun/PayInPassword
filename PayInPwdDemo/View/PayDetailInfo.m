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
        [self initDefaultData];
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
    self.closeBtn = [self createCommonButton];
    self.closeBtn.tag = 112;
    [self.closeBtn setTitle:@"╳" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    
    //返回按钮
    self.backBtn = [self createCommonButton];
    self.backBtn.tag = 113;
    self.backBtn.hidden = YES;
//    [self.backBtn setTitle:@"＜" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"arrowBack"];
    self.backBtn.layer.contents = (id)image.CGImage;
    [self.backBtn addTarget:self action:@selector(backToFrontView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
    
    //横线
    self.line = [[UILabel alloc]initWithFrame:CGRectZero];
    self.line.tag = 114;
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line];
    
    //展示详情tableview
    CGRect tableFrame = CGRectZero;
    self.detailTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.detailTable.tag = 115;
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

- (void)dismissThisView {
    self.dismissBtnBlock();
}

//返回上一个界面
- (void)backToFrontView {
    self.backBtnBlock();
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat paymentWidth = self.bounds.size.width;
    CGFloat tableHeight = 180;
    
    CGFloat btnXpiex;

    btnXpiex = self.frame.size.width - TITLE_HEIGHT - 5;
    
    CGRect titleFrame = CGRectMake(0, 0, paymentWidth, TITLE_HEIGHT);
    CGRect lineFrame = CGRectMake(0, TITLE_HEIGHT, paymentWidth, .5f);
    CGRect tableFrame = CGRectMake(0, TITLE_HEIGHT+1, self.frame.size.width, tableHeight);
    
    CGRect cancelFrame = CGRectMake(btnXpiex, 0, TITLE_HEIGHT, TITLE_HEIGHT);
    CGRect backFrame = CGRectMake(5, 0, TITLE_HEIGHT, TITLE_HEIGHT);
    
    self.titleLabel.frame = titleFrame;
    self.closeBtn.frame = cancelFrame;
    self.backBtn.frame = backFrame;
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
