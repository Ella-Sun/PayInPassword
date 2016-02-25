//
//  PaymentView.m
//  PayInPasswordDemo
//
//  Created by IOS-Sun on 16/2/24.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "PaymentView.h"

#import "PayDetailInfo.h"
#import "PayInputView.h"

#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width-80
#define KEYBOARD_HEIGHT 216
#define KEY_VIEW_DISTANCE 50
#define ALERT_HEIGHT 300

@interface PaymentView ()

@property (nonatomic, strong) PayDetailInfo *paymentAlert;
@property (nonatomic, strong) PayInputView *inputpwdView;

@end

@implementation PaymentView

- (NSMutableArray *)rightContents{

    if(!_rightContents){
        _rightContents = [NSMutableArray array];
    }
    return _rightContents;
}

- (instancetype)init {
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        
        self.rightContents = [NSMutableArray array];
        
        [self drawView];
        [self createDefaultData];
        
        [self setNeedsLayout];
    }
    return self;
}

//添加block
- (void)createDefaultData {
    
    self.alertType = PayAlertTypeAlert;

    __weak typeof(self)weakSelf = self;
    
    self.inputpwdView.completeHandle = ^(NSString *inputPwd){
        weakSelf.completeHandle(inputPwd);
        [weakSelf dismiss];
    };
    
    self.paymentAlert.dismissBtnBlock = ^(){
        [weakSelf dismiss];
    };
    
    self.paymentAlert.changeFrameBlock = ^(CGFloat interHeight){
        
        PaymentView * paymentView = [weakSelf viewWithTag:121];
        PayInputView * payInputView = [weakSelf viewWithTag:122];
        
        CGRect payFrame = paymentView.frame;
        CGRect inputFrame = payInputView.frame;
        
        payFrame.origin.y += interHeight;
        payFrame.size.height -= interHeight;
        paymentView.frame = payFrame;
        
        inputFrame.origin.y -= interHeight;
        payInputView.frame = inputFrame;
    };
}

//绘制默认视图
- (void)drawView {
    if (!self.paymentAlert) {
        //展示界面
        self.paymentAlert = [[PayDetailInfo alloc]initWithFrame:CGRectZero];
        self.paymentAlert.tag = 121;
        self.paymentAlert.layer.cornerRadius = 5.f;
        self.paymentAlert.layer.masksToBounds = YES;
        self.paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
        [self addSubview:self.paymentAlert];
        
        //密码区域
        self.inputpwdView = [[PayInputView alloc]initWithFrame:CGRectZero];
        self.inputpwdView.tag = 122;
        self.inputpwdView.backgroundColor = [UIColor whiteColor];
        self.inputpwdView.layer.borderWidth = 1.f;
        self.inputpwdView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
        [self.paymentAlert addSubview:self.inputpwdView];
        
    }
}


//显示
- (void)show {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    //实现放大的弹簧效果
    self.paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    self.paymentAlert.alpha = 0;
    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.inputpwdView.pwdTextField becomeFirstResponder];
        self.paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.paymentAlert.alpha = 1.0;
    } completion:nil];
}

//界面消失
- (void)dismiss {
    [self.inputpwdView.pwdTextField resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        self.paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        self.paymentAlert.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 *  刷新界面内数值
 */
- (void)reloadPaymentView {
    
    if (!self.isChanged && self.payType) {
        switch (self.payType) {
            case PaymentTypeShopping:
                self.leftTitles = @[@"所购项目",@"付款方式",@"需付款"];
                break;
            case PaymentTypeCard:
                self.leftTitles = @[@"信用卡还款",@"付款方式",@"需付款"];
                break;
            case PaymentTypeTurn:
                self.leftTitles = @[@"转账用户",@"付款方式",@"需付款"];;
                break;
                
            default:
                break;
        }
    }
    
    if (self.rightContents.count == 0) {
        
        [self.rightContents addObject:self.payDescrip];
        [self.rightContents addObject:self.payTool];
        [self.rightContents addObject:[NSString stringWithFormat:@"%.2f",self.payAmount]];
        
    } else {
        if (self.payDescrip) {
            [self.rightContents replaceObjectAtIndex:0 withObject:self.payDescrip];
        }
        if (self.payTool) {
            [self.rightContents replaceObjectAtIndex:1 withObject:self.payTool];
        }
        if (self.payDescrip > 0) {
            [self.rightContents replaceObjectAtIndex:2 withObject:
             [NSString stringWithFormat:@"%.2f",self.payAmount]];
        }
    }
    
    self.paymentAlert.title         = self.title;
    self.paymentAlert.leftTitles    = self.leftTitles;
    self.paymentAlert.rightContents = self.rightContents;
    [self.paymentAlert.detailTable reloadData];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat payYpiex;
    switch (self.alertType) {
        case PayAlertTypeAlert:{
            payYpiex = [UIScreen mainScreen].bounds.size.height - KEYBOARD_HEIGHT - KEY_VIEW_DISTANCE - ALERT_HEIGHT;
            if (payYpiex < 60) {
                payYpiex += 30;
            }
            
            CGFloat inputHeight = (PAYMENT_WIDTH-30)/6;
            CGFloat inputYpiex = ALERT_HEIGHT-inputHeight-15;
            
            CGRect inputFrame = CGRectMake(15, inputYpiex, PAYMENT_WIDTH-30, inputHeight);
            self.inputpwdView.frame = inputFrame;
        }
            break;
        case PayAlertTypeSheet:{
            [self.inputpwdView removeFromSuperview];
            payYpiex = [UIScreen mainScreen].bounds.size.height - ALERT_HEIGHT;
        }
            break;
        case PayAlertTypeOtherPage:
            break;
            
        default:
            break;
    }
    CGRect paymentFrame = CGRectMake(40, payYpiex, PAYMENT_WIDTH, ALERT_HEIGHT);
    self.paymentAlert.frame = paymentFrame;
}




@end
