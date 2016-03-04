//
//  ViewController.m
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/24.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import "ViewController.h"
#import "PaymentView.h"
#import "PasswordBuild.h"

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
    [buton setTitle:@"确认支付--滑动" forState:UIControlStateNormal];
    buton.backgroundColor = [UIColor cyanColor];
    [buton addTarget:self action:@selector(payMoneySlide) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    
    UIButton * butonTurn = [UIButton buttonWithType:UIButtonTypeSystem];
    butonTurn.frame = CGRectMake(200, 200, 100, 30);
    [butonTurn setTitle:@"确认支付--翻转" forState:UIControlStateNormal];
    butonTurn.backgroundColor = [UIColor cyanColor];
    [butonTurn addTarget:self action:@selector(payMoneyTurn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butonTurn];
    
    UIButton * pwdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    pwdButton.frame = CGRectMake(50, 300, 100, 30);
    [pwdButton setTitle:@"设置密码" forState:UIControlStateNormal];
    pwdButton.backgroundColor = [UIColor cyanColor];
    [pwdButton addTarget:self action:@selector(createPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pwdButton];

    UIButton * rePwdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rePwdButton.frame = CGRectMake(50, 400, 100, 30);
    [rePwdButton setTitle:@"重置密码" forState:UIControlStateNormal];
    rePwdButton.backgroundColor = [UIColor cyanColor];
    [rePwdButton addTarget:self action:@selector(reCreatePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rePwdButton];
}

- (void)payMoneyInOnePage{
    PaymentView * payView = [[PaymentView alloc] init];
    payView.title = @"请输入支付密码1";
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

- (void)payMoneySlide{
    PaymentView * payView = [[PaymentView alloc] init];
    payView.title = @"付款详情1";
    payView.payType = PaymentTypeCard;
    payView.alertType = PayAlertTypeSheet;
    payView.translateType = PayTranslateTypeSlide;
    payView.payDescrip = @"提现1";
    payView.payTool = @"使用中国工商银行信用卡(尾号7034)";
    payView.payAmount= 10369.88;
    
    payView.pwdCount = 5;
    [payView show];
    [payView reloadPaymentView];
    payView.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
    };
}

- (void)payMoneyTurn{
    PaymentView * payView = [[PaymentView alloc] init];
    payView.title = @"付款详情1";
    payView.payType = PaymentTypeCard;
    payView.alertType = PayAlertTypeSheet;
    payView.translateType = PayTranslateTypeTurn;
    payView.payDescrip = @"提现1";
    payView.payTool = @"使用中国工商银行信用卡(尾号7034)";
    payView.payAmount= 8888.88;
    
    payView.pwdCount = 6;
    [payView show];
    [payView reloadPaymentView];
    payView.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
    };
}

- (void)createPassword {
    NSLog(@"设置支付密码");
    NSString * httpPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"payCode"];
    if (httpPwd.length > 0) {
        NSLog(@"已经设置过密码，请修改");
        return;
    }
    PasswordBuild * pwdCreate = [[PasswordBuild alloc] init];
    pwdCreate.pwdCount = 5;
    pwdCreate.pwdOperationType = PwdOperationTypeCreate;
    [pwdCreate show];
    [self.view addSubview:pwdCreate];
    
    pwdCreate.PwdInit = ^(NSString *pwd){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:pwd forKey:@"payCode"];
        [defaults synchronize];
    };
}

- (void)reCreatePassword {
    NSLog(@"修改支付密码");
    PasswordBuild * pwdReCreate = [[PasswordBuild alloc] init];
    pwdReCreate.pwdCount = 5;
    pwdReCreate.tag = 171;
    pwdReCreate.pwdOperationType = PwdOperationTypeReset;
    [pwdReCreate show];
    [self.view addSubview:pwdReCreate];
    
    __weak typeof(self)weakSelf = self;
    pwdReCreate.PwdInput = ^(NSString *pwd){
        //判断密码是否正确
        PasswordBuild * pwdVerfy = [weakSelf.view viewWithTag:171];
        //1.请求网络数据 进行判断
        NSString * httpPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"payCode"];
        BOOL isCorrect = NO;
        if ([pwd isEqualToString:httpPwd]) {
            isCorrect = YES;
        } else {
            //没有创建原密码
            NSLog(@"请先创建原密码");
            isCorrect = NO;
        }
        //2.返回数值 处理
        [pwdVerfy verifyPwdisCorrect:isCorrect];
    };
    
    pwdReCreate.PwdReBuild = ^(NSString *pwd){
        NSLog(@"密码创建成功，新密码是：%@",pwd);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:pwd forKey:@"payCode"];
        [defaults synchronize];
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
