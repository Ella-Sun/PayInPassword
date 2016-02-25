//
//  PaymentCell.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/24.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "PaymentCell.h"


@implementation PaymentCell

- (void)awakeFromNib {
    // Initialization code
}
static CGFloat cellWidth;
+ (instancetype)paymentCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    PaymentCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cellWidth = tableView.frame.size.width;
        cell = [[PaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createDefaultViews];
    }
    return self;
}

- (void)createDefaultViews {
    
    CGFloat width = cellWidth;
    CGFloat height = self.frame.size.height;
    
    CGRect titleFrame = CGRectMake(15.0, 0, width*0.3-15.0, height);
    CGRect detailFrame = CGRectMake(width*.3, 0, width*0.7-40.0, height);
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:titleFrame];
    titleLable.tag = 121;
    titleLable.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    [self addSubview:titleLable];
    
    
    UILabel * detailLabel = [[UILabel alloc] initWithFrame:detailFrame];
    detailLabel.tag = 122;
    detailLabel.textColor = [UIColor colorWithWhite:0.098 alpha:1.000];
    detailLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:detailLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
