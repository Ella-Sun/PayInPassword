//
//  PayInputView.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/25.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "PayInputView.h"

#define PWD_COUNT 6
#define DOT_WIDTH 10

@interface PayInputView ()<UITextFieldDelegate> {
     NSMutableArray *pwdIndicatorArr;
}

@end

@implementation PayInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createDefaultViews];
        
        [self setNeedsLayout];
    }
    return self;
}

- (void)createDefaultViews {
    
    self.pwdTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.pwdTextField.hidden = YES;
    self.pwdTextField.delegate = self;
    self.pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.pwdTextField];
    
    [self commontCreateLabelWithCount:PWD_COUNT];
}

- (void)commontCreateLabelWithCount:(NSInteger)pwdCount {
    
    pwdIndicatorArr = [[NSMutableArray alloc]init];
    
    CGFloat width = self.bounds.size.width/PWD_COUNT;
    for (int i = 0; i < PWD_COUNT; i ++) {
        UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-DOT_WIDTH)/2.f + i*width, (self.bounds.size.height-DOT_WIDTH)/2.f, DOT_WIDTH, DOT_WIDTH)];
        dot.backgroundColor = [UIColor blackColor];
        dot.layer.cornerRadius = DOT_WIDTH/2.;
        dot.clipsToBounds = YES;
        dot.hidden = YES;
        [self addSubview:dot];
        [pwdIndicatorArr addObject:dot];
        
        if (i == PWD_COUNT-1) {
            continue;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, self.bounds.size.height)];
        line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
        [self addSubview:line];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect textFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.pwdTextField.frame = textFrame;
    
//    if ((self.pwdCount == PWD_COUNT) || (self.pwdCount == 0)) {
//        return;
//    } else {
    [self commontCreateLabelWithCount:self.pwdCount];
//    }
}


#pragma mark - textTieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= PWD_COUNT && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *totalString;
    if (string.length <= 0) {
        totalString = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:totalString.length];
    
    NSLog(@"_____total %@",totalString);
    if (totalString.length == 6) {
        if (_completeHandle) {
            _completeHandle(totalString);
        }
        NSLog(@"complete");
    }
    
    return YES;
}


- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}



@end
