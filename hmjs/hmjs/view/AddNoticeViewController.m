//
//  AddNoticeViewController.m
//  hmjs
//
//  Created by yons on 14-12-4.
//  Copyright (c) 2014年 yons. All rights reserved.
//

#import "AddNoticeViewController.h"

@interface AddNoticeViewController ()

@end

@implementation AddNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentTextview.layer.borderColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1].CGColor;
    self.contentTextview.layer.borderWidth = 1.0;
    self.contentTextview.layer.cornerRadius = 5.0f;
    //    _textView.delegate = self;
    //    _textView.scrollEnabled = YES;
    //    self.contentTextview.font = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
    //    _textView.returnKeyType = UIReturnKeyDefault;
    
    self.contentTextview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.contentTextview.layer setMasksToBounds:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    self.btn1.layer.cornerRadius = 5.0f;
    self.btn2.layer.cornerRadius = 5.0f;
    
    self.title = @"发布公告";
    
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

- (IBAction)saveBtn:(id)sender {
    NSLog(@"保存");
}

- (IBAction)addBtn:(id)sender {
    NSLog(@"提交");
}

@end
