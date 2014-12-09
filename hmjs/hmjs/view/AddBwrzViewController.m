//
//  AddBwrzViewController.m
//  hmjs
//
//  Created by yons on 14-12-9.
//  Copyright (c) 2014年 yons. All rights reserved.
//

#import "AddBwrzViewController.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "MBProgressHUD.h"

@interface AddBwrzViewController ()<MBProgressHUDDelegate>{
    MKNetworkEngine *engine;
    MBProgressHUD *HUD;
    
    int studentnum;
}

@end

@implementation AddBwrzViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化引擎
    engine = [[MKNetworkEngine alloc] initWithHostName:[Utils getHostname] customHeaderFields:nil];
    
    //添加加载等待条
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"加载中";
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    self.bjsj.layer.borderColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1].CGColor;
    self.bjsj.layer.borderWidth = 1.0;
    self.bjsj.layer.cornerRadius = 5.0f;
    self.bjsj.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.bjsj.layer setMasksToBounds:YES];

    self.title = @"添加班务日志";
    
    //添加手势，点击输入框其他区域隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGr];
    
    //添加按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"提交"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    NSDate *date = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *  locationString=[dateformatter stringFromDate:date];
    self.dateTitleLabel.text = locationString;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *class = [userDefaults objectForKey:@"class"];
    NSNumber *snum = [class objectForKey:@"studentnum"];
    self.bjrs.text = [NSString stringWithFormat:@"%@",snum];
    
    studentnum = [snum intValue];
}

//隐藏键盘
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.bjsj resignFirstResponder];
    [self.cqrs resignFirstResponder];
    [self.bjrs2 resignFirstResponder];
    [self.sjrs resignFirstResponder];
    [self.cdrs resignFirstResponder];
    if(self.view.frame.origin.y == -80){
        [self moveView:80];
    }
}

- (void)save{
    [self viewTapped:nil];
    
    int num1 = [self.cqrs.text intValue];
    int num2 = [self.bjrs2.text intValue];
    int num3 = [self.sjrs.text intValue];
    int num4 = [self.cdrs.text intValue];
    
    if (studentnum != (num1 + num2 + num3 + num4)) {
        [self alertMsg:@"总人数不等于班级人数"];
    }else{
        [HUD show:YES];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *class = [userDefaults objectForKey:@"class"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[class objectForKey:@"id"] forKey:@"recordid"];
        [dic setValue:[userDefaults objectForKey:@"userid"] forKey:@"userid"];
        [dic setValue:self.bjsj.text forKey:@"dailycontent"];
        [dic setValue:self.cqrs.text forKey:@"attnum"];
        [dic setValue:self.bjrs2.text forKey:@"sicknum"];
        [dic setValue:self.sjrs.text forKey:@"casualnum"];
        [dic setValue:self.cdrs.text forKey:@"latenum"];
        MKNetworkOperation *op = [engine operationWithPath:@"/classDaily/sava.do" params:dic httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSLog(@"[operation responseData]-->>%@", [operation responseString]);
            NSString *result = [operation responseString];
            NSError *error;
            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            if (resultDict == nil) {
                NSLog(@"json parse failed \r\n");
            }
            NSNumber *success = [resultDict objectForKey:@"success"];
            NSString *msg = [resultDict objectForKey:@"msg"];
            //        NSString *code = [resultDict objectForKey:@"code"];
            if ([success boolValue]) {
                [HUD hide:YES];
                [self okMsk:msg];
            }else{
                [HUD hide:YES];
                [self alertMsg:msg];
            }
        }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
            NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
            [HUD hide:YES];
            [self alertMsg:[err localizedDescription]];
        }];
        [engine enqueueOperation:op];
    }
}

//成功
- (void)okMsk:(NSString *)msg{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.delegate = self;
    hud.labelText = msg;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}


//提示
- (void)alertMsg:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}




#pragma mark - 输入框代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag != 99) {
        if(self.view.frame.origin.y == -80){
            [self moveView:80];
        }
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if(textView.tag == 99){
        if(self.view.frame.origin.y == 0){
            [self moveView:-80];
        }
    }
    return true;
}

//界面根据键盘的显示和隐藏上下移动
-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 1.0f;
    CGRect frame = self.view.frame;
    if(move == 0){
        frame.origin.y =0;
    }else{
        frame.origin.y +=move;//view的X轴上移
    }
    [UIView beginAnimations:@"ResizeView" context:nil];
    self.view.frame = frame;
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
