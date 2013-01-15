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
                                      callback:^BOOL(LinkID linkID, NSString *url) {
                                          
                                          BOOL shouldLoad = YES;
                                          
                                          switch (linkID) {
                                              case LinkIDHome:
                                              {
                                                  shouldLoad = NO;
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  break;
                                              }
                                              case LinkIDLogin:
                                              {
                                                  shouldLoad = NO;
                                                  [self showLogInViewController];
                                                  break;
                                              }
                                              case LinkIDImportSchedule:
                                              {
                                                  shouldLoad = YES;
                                                  ScheduleViewController *svc = [[ScheduleViewController alloc] init];
                                                  [self.navigationController pushViewController:svc animated:YES];
                                                  break;
                                              }
                                              default:
                                              {
                                                  break;
                                              }
                                          }
                                          
                                          return shouldLoad;
                                      }];
     return ret;
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
