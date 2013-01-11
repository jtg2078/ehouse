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
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://emsgmobile.test.demo2.miniasp.com.tw"]]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlStr=[[request URL] description];
    NSLog(@"%@",urlStr);
    
    if ([urlStr isEqualToString:@"http://emsgmobile.test.demo2.miniasp.com.tw/PubMSG"]) {
        SecondViewController *docView=[[SecondViewController alloc] initWithUrl:urlStr];
        [self.navigationController pushViewController:docView animated:YES];
        return NO;
    }
    if ([urlStr isEqualToString:@"http://emsgmobile.test.demo2.miniasp.com.tw/#/Account/login"]) {
        LogInViewController *logInView=[[LogInViewController alloc] init];
        [self.navigationController pushViewController:logInView animated:YES];
        return NO;
    }
    if ([urlStr isEqualToString:@"http://emsgmobile.test.demo2.miniasp.com.tw/RankStat/Collection"]) {
        SecondViewController *docView=[[SecondViewController alloc] initWithUrl:urlStr];
        [self.navigationController pushViewController:docView animated:YES];
        return NO;
    }
    if ([urlStr isEqualToString:@"http://emsgmobile.test.demo2.miniasp.com.tw/Constellation"]) {
        SecondViewController *docView=[[SecondViewController alloc] initWithUrl:urlStr];
        [self.navigationController pushViewController:docView animated:YES];
        return NO;
    }
    if ([urlStr isEqualToString:@"http://emsgmobile.test.demo2.miniasp.com.tw/Weather"]) {
        SecondViewController *docView=[[SecondViewController alloc] initWithUrl:urlStr];
        [self.navigationController pushViewController:docView animated:YES];
        return NO;
    }
    if ([urlStr isEqualToString:@"http://emsgmobile.test.demo2.miniasp.com.tw/Help"]) {
        SecondViewController *docView=[[SecondViewController alloc] initWithUrl:urlStr];
        [self.navigationController pushViewController:docView animated:YES];
        return NO;
    }
    
    return YES;
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


@end
