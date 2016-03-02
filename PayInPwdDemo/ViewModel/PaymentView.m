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

#define TITLE_HEIGHT 46
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width-80
#define KEYBOARD_HEIGHT 216
#define KEY_VIEW_DISTANCE 50
#define ALERT_HEIGHT 300

#define KEY_WIDTH 49

@interface PaymentView ()

@property (nonatomic, strong) PayDetailInfo * paymentAlert, *paymentOtherView, *payCardView;
@property (nonatomic, strong) PayInputView  * inputpwdView;

@property (nonatomic, strong) UIButton      * sureButton;

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
        [self drawView];
        [self createDefaultData];
        
        [self setNeedsLayout];
    }
    return self;
}


/**
 *  添加block
 */
- (void)createDefaultData {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
    
    self.alertType = PayAlertTypeAlert;
    self.payType = PaymentTypeShopping;
    
    self.rightContents = [NSMutableArray array];

    __weak typeof(self)weakSelf = self;
    
    self.inputpwdView.completeHandle = ^(NSString *inputPwd){
        weakSelf.completeHandle(inputPwd);
        [weakSelf.inputpwdView.pwdTextField resignFirstResponder];
        [weakSelf dismissWithCurrentView:weakSelf.paymentOtherView];
    };
    
    self.paymentAlert.choosePayCard = ^(){
        NSLog(@"选择支付的银行卡");
        UIButton * backBtn = [weakSelf.payCardView viewWithTag:113];
        backBtn.hidden = NO;
        
        UIButton * closeBtn = [weakSelf.payCardView viewWithTag:112];
        [closeBtn setTitle:@"设置" forState:UIControlStateNormal];
        
        [weakSelf transformDirection:YES withCurrentView:weakSelf.paymentAlert withLastView:weakSelf.payCardView];
    };
    
    self.paymentAlert.dismissBtnBlock = ^(){
        [weakSelf dismissWithCurrentView:weakSelf.paymentAlert];
    };
    
    self.paymentOtherView.dismissBtnBlock = ^(){
        [weakSelf.inputpwdView.pwdTextField resignFirstResponder];
        [weakSelf dismissWithCurrentView:weakSelf.paymentOtherView];
    };
    
    self.payCardView.dismissBtnBlock = ^(){
        [weakSelf dismissWithCurrentView:weakSelf.payCardView];
    };
    
    self.paymentOtherView.backBtnBlock = ^(){
        [weakSelf.inputpwdView.pwdTextField resignFirstResponder];
        weakSelf.inputpwdView.pwdTextField.text = nil;
        [weakSelf.inputpwdView setDotWithCount:0];
        UIButton * backBtn = [weakSelf.paymentAlert viewWithTag:113];
        backBtn.hidden = YES;
        [weakSelf transformDirection:NO withCurrentView:weakSelf.paymentOtherView withLastView:weakSelf.paymentAlert];
    };
    
    self.payCardView.backBtnBlock = ^(){
        UIButton * backBtn = [weakSelf.paymentAlert viewWithTag:113];
        backBtn.hidden = YES;
        [weakSelf transformDirection:NO withCurrentView:weakSelf.payCardView withLastView:weakSelf.paymentAlert];
    };
    
    self.paymentAlert.changeFrameBlock = ^(CGFloat interHeight){
        
        PaymentView * paymentView = [weakSelf viewWithTag:131];
        CGRect payFrame = paymentView.frame;
        PaymentView * payCardView =[weakSelf viewWithTag:133];
        PaymentView * paymentOtherView = [weakSelf viewWithTag:132];
        
        UIButton * button = [payCardView viewWithTag:113];
        if (!button.hidden) {
            return;
        }
        
        if (weakSelf.alertType == PayAlertTypeAlert) {
            //下降
            payFrame.origin.y += interHeight;
            payFrame.size.height -= interHeight;
            
            PayInputView * payInputView = [weakSelf viewWithTag:121];
            CGRect inputFrame = payInputView.frame;
            
            inputFrame.origin.y -= interHeight;
            payInputView.frame = inputFrame;
        } else if (weakSelf.alertType == PayAlertTypeSheet) {
            //下降
            interHeight -= 100;
            payFrame.origin.y += interHeight;
            payFrame.size.height -= interHeight;
            
            UIButton * sureButton = [weakSelf viewWithTag:122];
            CGRect sureFrame = sureButton.frame;
            
            sureFrame.origin.y -= interHeight;
            sureButton.frame = sureFrame;
        }
        
        paymentView.frame = payFrame;
        paymentOtherView.frame = payFrame;
        payCardView.frame = payFrame;
    };
}


/**
 *  绘制默认视图
 */
- (void)drawView {
    if (!self.paymentAlert) {
        //密码区域
        self.inputpwdView = [[PayInputView alloc]initWithFrame:CGRectZero];
        self.inputpwdView.tag = 121;
        self.inputpwdView.backgroundColor = [UIColor whiteColor];
        self.inputpwdView.layer.borderWidth = 1.f;
        self.inputpwdView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
        [self.paymentAlert addSubview:self.inputpwdView];
        
        //确认付款按钮
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureButton.tag = 122;
        self.sureButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.417 blue:0.828 alpha:1.000];
        self.sureButton.layer.cornerRadius = 5.0f;
        [self.sureButton setTitle:@"确认付款" forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(transformPaymentViews) forControlEvents:UIControlEventTouchUpInside];
        [self.paymentAlert addSubview:self.sureButton];
        
        //第二个密码输入界面
        self.paymentOtherView = [self createPaymentAlertViewCommon];
        self.paymentOtherView.tag = 132;
        self.paymentOtherView.hidden = YES;
        self.paymentOtherView.title = @"确认付款";
        [self.paymentOtherView.detailTable removeFromSuperview];
        [self addSubview:self.paymentOtherView];
        
        //选择支付方式界面
        self.payCardView = [self createPaymentAlertViewCommon];
        self.payCardView.tag = 133;
        self.payCardView.hidden = YES;
        self.payCardView.detailTable.bounces = YES;
        self.payCardView.title = @"选择付款方式";
        [self addSubview:self.payCardView];
        
        //展示界面
        self.paymentAlert = [self createPaymentAlertViewCommon];
        self.paymentAlert.tag = 131;
        self.paymentAlert.title = @"付款详情";
        [self addSubview:self.paymentAlert];
    }
}

- (PayDetailInfo *)createPaymentAlertViewCommon {
    PayDetailInfo * paymentAlert = [[PayDetailInfo alloc]initWithFrame:CGRectZero];
    paymentAlert.layer.cornerRadius = 5.f;
    paymentAlert.layer.masksToBounds = YES;
//    paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
    return paymentAlert;
}


//显示
- (void)show {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    //实现放大的弹簧效果
    self.paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    self.paymentAlert.alpha = 0;
    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.alertType == PayAlertTypeAlert) {
            [self.inputpwdView.pwdTextField becomeFirstResponder];
        }
        self.paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.paymentAlert.alpha = 1.0;
    } completion:nil];
}


//点击确认按钮，切换视图
- (void)transformPaymentViews {
    self.sureButton.selected = YES;
    self.paymentOtherView.hidden = NO;
    
    UIButton * backBtn = [self.paymentOtherView viewWithTag:113];
    backBtn.hidden = NO;
    
    UIButton * closeBtn = [self.paymentOtherView viewWithTag:112];
    closeBtn.hidden = YES;
    
    [self transformDirection:YES withCurrentView:self.paymentAlert withLastView:self.paymentOtherView];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:self.animateTime*.5];
}

- (void)delayMethod {
    [self.inputpwdView.pwdTextField becomeFirstResponder];
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
        //第一次赋值
        [self.rightContents addObject:self.payDescrip];
        [self.rightContents addObject:self.payTool];
        [self.rightContents addObject:[NSString stringWithFormat:@"%.2f",self.payAmount]];
        
    } else {
        //第二。。赋值
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

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.sureButton.isSelected) {
        return;
    }
    
    UIButton * backBtn = [self.payCardView viewWithTag:113];
    if (!backBtn.hidden) {
        return;
    }
    
    if ((self.pwdCount < 4) && (self.pwdCount > 8)) {
        self.pwdCount = 6;
    }
    self.inputpwdView.pwdCount = self.pwdCount;
    
    CGFloat payXpiex;
    CGFloat payYpiex;
    CGFloat payWidth;
    CGFloat payHeight;
    
    CGFloat inputWidth = KEY_WIDTH * self.pwdCount;
    if (self.pwdCount < 6) {
        inputWidth = (KEY_WIDTH + 10) * self.pwdCount;
    }
    CGFloat inputHeight = (PAYMENT_WIDTH-30)/6;
    CGFloat inputYpiex = ALERT_HEIGHT-inputHeight-15;
    CGRect inputFrame;
    
    switch (self.alertType) {
        case PayAlertTypeAlert:{
            [self.sureButton removeFromSuperview];
//            self.paymentAlert.title = @"请输入支付密码";
            payXpiex = 40;
            payYpiex = [UIScreen mainScreen].bounds.size.height - KEYBOARD_HEIGHT - KEY_VIEW_DISTANCE - ALERT_HEIGHT;
            payWidth = PAYMENT_WIDTH;
            payHeight = ALERT_HEIGHT;
            if (payYpiex < 60) {
                payYpiex += 30;
            }
            inputFrame = CGRectMake((payWidth-inputWidth)*.5, inputYpiex, inputWidth, inputHeight);
            self.inputpwdView.frame = inputFrame;
            
            [self.paymentAlert addSubview:self.inputpwdView];
        }
            break;
        case PayAlertTypeSheet:{
            [self.inputpwdView removeFromSuperview];
//            self.paymentAlert.title = @"付款详情";
            payXpiex = 0;
            payYpiex = [UIScreen mainScreen].bounds.size.height - ALERT_HEIGHT;
            payWidth = self.bounds.size.width;
            payHeight = ALERT_HEIGHT + 100;
            
            CGFloat buttonWidth = payWidth - 30;
            inputFrame = CGRectMake((payWidth-buttonWidth)*.5, inputYpiex, buttonWidth, inputHeight);
            self.sureButton.frame = inputFrame;
            [self.paymentAlert addSubview:self.sureButton];
            
            CGRect payOtherFrame = CGRectMake(payXpiex, payYpiex, payWidth, payHeight);
            self.paymentOtherView.frame = payOtherFrame;
            
            inputFrame = CGRectMake((payWidth-inputWidth)*.5, TITLE_HEIGHT+15, inputWidth, inputHeight);
            self.inputpwdView.frame = inputFrame;
            [self.paymentOtherView addSubview:self.inputpwdView];
        }
            break;
        case PayAlertTypeOtherPage:
            break;
            
        default:
            break;
    }
    [self.inputpwdView refreshInputViews];
    
    CGRect paymentFrame = CGRectMake(payXpiex, payYpiex, payWidth, payHeight);
    self.paymentAlert.frame = paymentFrame;
}




@end
