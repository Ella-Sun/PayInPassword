//
//  ViewController.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/24.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "ViewController.h"
#import "PaymentView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * onePageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    onePageBtn.frame = CGRectMake(50, 100, 100, 30);
    [onePageBtn setTitle:@"确认支付--one" forState:UIControlStateNormal];
    onePageBtn.backgroundColor = [UIColor cyanColor];
    [onePageBtn addTarget:self action:@selector(payMoneyInOnePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:onePageBtn];
    
    UIButton * buton = [UIButton buttonWithType:UIButtonTypeSystem];
    buton.frame = CGRectMake(50, 200, 100, 30);
    [buton setTitle:@"确认支付--two" forState:UIControlStateNormal];
    buton.backgroundColor = [UIColor cyanColor];
    [buton addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];

}

- (void)payMoneyInOnePage{
    PaymentView * payView = [[PaymentView alloc] init];
    payView.title = @"请输入支付密码";
    payView.payType = PaymentTypeCard;
    payView.alertType = PayAlertTypeAlert;
    payView.translateType = PayTranslateTypeSlide;
    payView.payDescrip = @"提现";
    payView.payTool = @"工商银行卡";
    payView.payAmount= 10369.88;
    
    payView.pwdCount = 4;
    [payView show];
    [payView reloadPaymentView];
    payView.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
    };
}

- (void)payMoney{
    PaymentView * payView = [[PaymentView alloc] init];
    payView.title = @"请输入支付密码";
    payView.payType = PaymentTypeCard;
    payView.alertType = PayAlertTypeSheet;
    payView.translateType = PayTranslateTypeSlide;
    payView.payDescrip = @"提现";
    payView.payTool = @"工商银行卡";
    payView.payAmount= 10369.88;
    
    payView.pwdCount = 6;
    [payView show];
    [payView reloadPaymentView];
    payView.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
