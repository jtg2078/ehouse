//
//  SecondViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/4.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "SecondViewController.h"
#import "IIViewDeckController.h"
#import "LogInViewController.h"
#import "SVProgressHUD.h"
#import "ScheduleViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()

@end

@implementation SecondViewController


#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (id)initWithUrl:(NSString *)url
{
    self = [super initWithNibName:@"SecondViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.myUrl=url;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.myUrl]]];
    
    NSLog(@"viewDidLoad - loadRequest %@", self.myUrl);
}

#pragma mark - user interaction

- (IBAction)homeBack2:(id)sender
{
    if ([_myWebView canGoBack]) {
        [_myWebView goBack];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }}

- (IBAction)UrlItem:(id)sender
{
    if([self.viewDeckController isSideClosed:IIViewDeckLeftSide] == YES)
    {
        [self.viewDeckController openLeftViewAnimated:YES];
    }
    else
    {
        [self.viewDeckController closeLeftViewAnimated:YES];
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    //[SVProgressHUD showWithStatus:@"Loading..."];
    
    NSLog(@"shouldStartLoadWithRequest: %@",[request URL]);
    
    BOOL ret = [self.appManager processRequest:request
                                      callback:^BOOL(LinkID linkID, NSString *url) {
                                          
                                          BOOL shouldLoad = YES;
                                          
                                          switch (linkID) {
                                              case LinkIDHome:
                                              {
                                                  shouldLoad = NO;
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  [SVProgressHUD dismiss];
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
                                                  //[self presentModalViewController:svc animated:YES];
                                                  [SVProgressHUD dismiss];
                                                  break;
                                              }
                                              default:
                                              {
                                                  NSDictionary *info = [self.appManager getLinkInfoLinkID:linkID];
                                                  if(info)
                                                      self.navTopText2.title = info[KEY_name];
                                                  break;
                                              }
                                          }
                                          
                                          return shouldLoad;
                                      }];
     return ret;
    
}


#pragma mark - helper

- (void)loadURL:(NSString *)url
{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)showLogInViewController
{
    LogInViewController *lvc = [[LogInViewController alloc] init];
    [self presentModalViewController:lvc animated:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
}



@end
