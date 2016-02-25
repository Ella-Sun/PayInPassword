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
    
    UIButton * buton = [UIButton buttonWithType:UIButtonTypeSystem];
    buton.frame = CGRectMake(50, 100, 100, 30);
    [buton setTitle:@"确认支付" forState:UIControlStateNormal];
    buton.backgroundColor = [UIColor cyanColor];
    [buton addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];

}

- (void)payMoney{
    PaymentView * payView = [[PaymentView alloc] init];
    payView.title = @"请输入支付密码";
    payView.payType = PaymentTypeTurn;
    payView.payDescrip = @"提现";
    payView.payTool = @"工商银行卡";
    payView.payAmount= 10369.88;
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
