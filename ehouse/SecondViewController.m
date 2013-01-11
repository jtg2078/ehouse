//
//  SecondViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/4.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "SecondViewController.h"
#import "IIViewDeckController.h"
#import "ScheduleViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize myUrl;
@synthesize page;

- (id)initWithUrl:(NSString *)url
{
    self = [super initWithNibName:@"SecondViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.myUrl=url;
    }
    NSLog(@"yes");
    return self;
}

- (IBAction)homeBack2:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)UrlItem:(id)sender {
    if([self.viewDeckController isSideClosed:IIViewDeckLeftSide] == YES)
    {
        [self.viewDeckController openLeftViewAnimated:YES];
    }
    else
    {
        [self.viewDeckController closeLeftViewAnimated:YES];
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    page=[[NSString alloc] init];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.myUrl]]];
    NSLog(@"%@",myUrl);
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    NSLog(@"%@",[request URL]);
    if ([[[request URL] lastPathComponent] isEqualToString:@"login"]) {
        _navTopText2.text=@"我的e管家";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"PubMSG"]) {
        _navTopText2.text=@"公眾訊息";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Collection"]) {
        _navTopText2.text=@"排行榜";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Constellation"]) {
        _navTopText2.text=@"星座";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Weather"]) {
        _navTopText2.text=@"天氣服務";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Help"]) {
        _navTopText2.text=@"新手上路";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"MyPubMSGRead"]) {
        _navTopText2.text=@"我的公眾訊息";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"MyMSGSet"]) {
        _navTopText2.text=@"我的訊息";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Manage"]) {
        _navTopText2.text=@"訊息管理";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"SubscribeSet"]) {
        _navTopText2.text=@"訊息訂閱";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"SubscribeMgt"]) {
        _navTopText2.text=@"訂閱管理";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"favorite"]) {
        _navTopText2.text=@"我的收藏";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Label"]) {
        _navTopText2.text=@"標簽管理";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Set"]) {
        _navTopText2.text=@"設定";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Expense"]) {
        _navTopText2.text=@"費用統計";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Schedule"]) {
        _navTopText2.text=@"匯入行事曆";
    }

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end