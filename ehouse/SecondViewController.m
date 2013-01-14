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
#import "LogInViewController.h"
#import "SVProgressHUD.h"

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
    
    BOOL ret = [self.appManager processRequest:request
                                 forController:self
                                     needLogIn:^{
                                         [self showLogInViewController]; }
                                      callback:^(BOOL canLoad, BOOL callSecondVC, NSString *title) {}
                                         error:^(NSString *errorMsg, NSError *error) {}];
    
    return ret;
    
    /*
    [self.appManager processRequest:request forController:self
                          needLogIn:^{
        [SVProgressHUD showErrorWithStatus:@"need login!"];
    } callback:^(BOOL canLoad, BOOL callSecondVC, NSString *title) {
        [SVProgressHUD showSuccessWithStatus:title];
    } error:^(NSString *errorMsg, NSError *error) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
     
         return YES;
     */
    

    
    /*
    if ([[[request URL] lastPathComponent] isEqualToString:@"login"]) {
        self.navTopText2.title=@"我的e管家";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"PubMSG"]) {
        self.navTopText2.title=@"公眾訊息";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Collection"]) {
        self.navTopText2.title=@"排行榜";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Constellation"]) {
        self.navTopText2.title=@"星座";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Weather"]) {
        self.navTopText2.title=@"天氣服務";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Help"]) {
        self.navTopText2.title=@"新手上路";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"MyPubMSGRead"]) {
        self.navTopText2.title=@"我的公眾訊息";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"MyMSGSet"]) {
        self.navTopText2.title=@"我的訊息";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Manage"]) {
        self.navTopText2.title=@"訊息管理";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"SubscribeSet"]) {
        self.navTopText2.title=@"訊息訂閱";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"SubscribeMgt"]) {
        self.navTopText2.title=@"訂閱管理";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"favorite"]) {
        self.navTopText2.title=@"我的收藏";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Label"]) {
        self.navTopText2.title=@"標簽管理";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Set"]) {
        self.navTopText2.title=@"設定";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Expense"]) {
        self.navTopText2.title=@"費用統計";
    }
    if ([[[request URL] lastPathComponent] isEqualToString:@"Schedule"]) {
        self.navTopText2.title=@"匯入行事曆";
    }
     

    return YES;
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadURL:(NSString *)url
{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - helper

- (void)showLogInViewController
{
    LogInViewController *lvc = [[LogInViewController alloc] init];
    [self presentModalViewController:lvc animated:YES];
}

@end
