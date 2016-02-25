//
//  PaymentCell.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/24.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCell : UITableViewCell

@property (nonatomic, assign)CGFloat cellWidth;

+ (instancetype)paymentCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@end
