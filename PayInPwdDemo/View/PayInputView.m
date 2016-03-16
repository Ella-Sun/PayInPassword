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

@property (nonatomic, strong) UIButton * clickButton;

@end

@implementation PayInputView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

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
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.clickButton.backgroundColor = [UIColor clearColor];
    self.clickButton.frame = CGRectZero;
    [self.clickButton addTarget:self action:@selector(viewIsClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clickButton];
    
    self.pwdCount = PWD_COUNT;
    [self commontCreateLabelWithCount:self.pwdCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.pwdTextField];
}

- (void)viewIsClicked {
    NSLog(@"被点击了");
    if (!self.clickBlock) {
        return;
    }
    self.clickBlock();
}

- (void)commontCreateLabelWithCount:(NSInteger)pwdCount {

    if (pwdCount == 0) {
        return;
    }
    CGFloat width = self.frame.size.width/pwdCount;
    if (width <= 0) {
        return;
    }
    
    pwdIndicatorArr = [[NSMutableArray alloc]init];
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < pwdCount; i ++) {
        UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-DOT_WIDTH)/2.f + i*width, (self.bounds.size.height-DOT_WIDTH)/2.f, DOT_WIDTH, DOT_WIDTH)];
        dot.backgroundColor = [UIColor blackColor];
        dot.layer.cornerRadius = DOT_WIDTH/2.;
        dot.clipsToBounds = YES;
        dot.hidden = YES;
        [self addSubview:dot];
        [pwdIndicatorArr addObject:dot];
        
        if (i == pwdCount-1) {
            continue;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, self.bounds.size.height)];
        line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
        [self addSubview:line];
    }
    
}

/**
 *  监听
 */
- (void)textFieldTextDidChange {
    NSLog(@"长度：%ld",self.pwdTextField.text.length);
    if (self.pwdTextField.text.length >= self.pwdCount) {
        NSRange range = NSMakeRange(0, self.pwdCount);
        self.pwdTextField.text = [self.pwdTextField.text substringWithRange:range];
        [self.pwdTextField endEditing:YES];
        
//        [self.pwdTextField resignFirstResponder];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect textFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.pwdTextField.frame = textFrame;
    
    self.clickButton.frame = textFrame;
    [self bringSubviewToFront:self.clickButton];
}

- (void)refreshInputViews {
    if (pwdIndicatorArr.count == 0) {
        [self commontCreateLabelWithCount:self.pwdCount];
    }
}


#pragma mark - textTieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= self.pwdCount && string.length) {
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
    
    NSLog(@"textField-----%@",textField.text);
    NSLog(@"string--------%@",string);
    NSLog(@"_____total %@",totalString);
    /*
    if (totalString.length == self.pwdCount) {
        if (_completeHandle) {
            _completeHandle(totalString);
        }
        NSLog(@"complete");
    }
     */
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == self.pwdCount) {
        if (_completeHandle) {
            _completeHandle(textField.text);
//            textField.text = nil;
        }
        self.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
    }
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
