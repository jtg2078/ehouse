//
//  RootViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 12/12/28.
//  Copyright (c) 2012年 (dbx) Amigo. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"
#import "IIViewDeckController.h"
#import "LogInViewController.h"
#import "ScheduleViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

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
    
    [self reload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(self.appManager.autoLogin.boolValue == YES)
        {
            if(self.appManager.accoutName.length && self.appManager.accoutPwd.length)
            {
                [SVProgressHUD showWithStatus:@"登入中"];
                [self.appManager loginWithAccountName:self.appManager.accoutName
                                                  pwd:self.appManager.accoutPwd
                                              success:^(NSString *token) {
                                                  [SVProgressHUD showSuccessWithStatus:@"登入成功"];
                                                  NSString *pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_pushToken];
                                                  if(pushToken)
                                                  {
                                                      [self.appManager registerForPushAccount:self.appManager.userInfo.token
                                                                                       device:@"iphone"
                                                                                        token:pushToken
                                                                                      success:^{
                                                                                          NSLog(@"推播的api 註冊成功");
                                                                                      }
                                                                                      failure:^(NSString *errorMsg, NSError *error) {
                                                                                          NSLog(@"推播的api 註冊失敗: %@", errorMsg);
                                                                                      }];
                                                  }
                                              }
                                              failure:^(NSString *errorMsg, NSError *error) {
                                                  [SVProgressHUD showErrorWithStatus:@"登入失敗"];
                                              }];
            }
        }
    });
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr=[[request URL] description];
    NSLog(@"%@",urlStr);
    
    BOOL ret = [self.appManager processRequest:request
                                      callback:^BOOL(LinkID linkID, NSString *url) {
                                          
                                          BOOL shouldLoad = NO;
                                          
                                          switch (linkID) {
                                              case LinkIDHome:
                                              {
                                                  shouldLoad = YES;
                                                  break;
                                              }
                                              case LinkIDMemberArea:
                                              case LinkIDLogin:
                                              {
                                                  [self showLogInViewController];
                                                  break;
                                              }
                                              default:
                                              {
                                                  SecondViewController *docView=[[SecondViewController alloc] initWithUrl:url];
                                                  [self.navigationController pushViewController:docView animated:YES];
                                                  break;
                                              }
                                          }
                                          
                                          return shouldLoad;
                                      }];
    return ret;
    
}

#pragma mark - user interaction

- (void)homeButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"yes");
}

- (IBAction)homeBack:(id)sender
{
    
}

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

#pragma mark - helper

- (void)reload
{
    NSString *url = DEVELOPMENT_MODE ? DEVELOPMENT_URL : PRODUCTION_URL;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)showLogInViewController
{
    LogInViewController *lvc = [[LogInViewController alloc] init];
    [self presentModalViewController:lvc animated:YES];
}

@end
