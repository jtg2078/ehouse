//
//  SideMenuViewController.m
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "SideMenuViewController.h"
#import "RootViewController.h"
#import "SecondViewController.h"
#import "IIViewDeckController.h"
#import "LogInViewController.h"
#import "ScheduleViewController.h"
#import "AppDelegate.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

#pragma mark - memory management

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
    // Do any additional setup after loading the view from its nib.
    
    // -------------------- notif --------------------
    
    [self.notifCenter addObserver:self
                         selector:@selector(handleLeftViewOpened:)
                             name:NOTIF_LEFT_SIDE_OPENED
                           object:nil];
    
    // -------------------- view --------------------
    
    self.title = @"我的專區";
    
    [self refreshState];
    
    // -------------------- header view --------------------
    
    self.myTableView.tableHeaderView = self.myHeaderView;
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setMyHeaderView:nil];
    [self setUserNameLabel:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshState];
}

#pragma mark - helper

- (void)refreshState
{
    if(self.appManager.userInfo)
    {
        if(self.appManager.userInfo.displayNickname.boolValue == YES)
            self.userNameLabel.text = self.appManager.userInfo.nickname;
        else
            self.userNameLabel.text = self.appManager.userInfo.userName;

        [self.loginButton setTitle:@"登出" forState:UIControlStateNormal];
    }
    else
    {
        self.userNameLabel.text = @"尚未登入";
        
        [self.loginButton setTitle:@"登入" forState:UIControlStateNormal];
    }
}

- (void)showLogInViewController
{
    LogInViewController *lvc = [[LogInViewController alloc] init];
    [self presentModalViewController:lvc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appManager.sideMenuLinks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:179/255.0];
    }
    
    // Configure the cell...
    NSDictionary *info = self.appManager.sideMenuLinks[indexPath.row];
    cell.textLabel.text = info[KEY_name];
    cell.imageView.image = [UIImage imageNamed:info[KEY_image]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.appManager.sideMenuLinks[indexPath.row];
    NSString *url = [self.appManager getFullURLforLinkID:info[KEY_id]];
    
    SecondViewController *sec = [[SecondViewController alloc] initWithUrl:url];
    [self.viewDeckController.navigationController pushViewController:sec animated:YES];
    
    BOOL useFirst = YES;
    
    
    if(useFirst)
    {
        UINavigationController *nav = (UINavigationController *)self.viewDeckController.centerController;
        if([[nav topViewController] isKindOfClass:[ScheduleViewController class]])
        {     
            if ([KEY_url isEqualToString:@"http://emsgmobile2013.test.demo2.miniasp.com.tw/"]) {
                SecondViewController *sec = [[SecondViewController alloc] initWithUrl:url];
                [nav pushViewController:sec animated:NO];
                                
                
            }else{
                SecondViewController *sec = [[SecondViewController alloc] initWithUrl:url];
                [nav pushViewController:sec animated:NO];
            }
        }
        if([[nav topViewController] isKindOfClass:[RootViewController class]])
        {
            SecondViewController *sec = [[SecondViewController alloc] initWithUrl:url];
            [nav pushViewController:sec animated:NO];
        }
        else if([[nav topViewController] isKindOfClass:[SecondViewController class]])
        {
            SecondViewController *sec = (SecondViewController *)[nav topViewController];
            [sec loadURL:url];
        }
        
        if ([KEY_url isEqualToString:@"http://emsgmobile2013.test.demo2.miniasp.com.tw/"]) {
            
            
            [nav.navigationController popToRootViewControllerAnimated:YES];
        }

        [self.viewDeckController closeLeftViewAnimated:YES];
    }
    else
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            UINavigationController *nav = (UINavigationController *)controller.centerController;
            
            if([[nav topViewController] isKindOfClass:[RootViewController class]])
            {
                SecondViewController *sec = [[SecondViewController alloc] initWithUrl:url];
                [nav pushViewController:sec animated:NO];
            }
            else if([[nav topViewController] isKindOfClass:[SecondViewController class]])
            {
                SecondViewController *sec = (SecondViewController *)[nav topViewController];
                [sec loadURL:url];
            }
        }];
    }
}

#pragma mark - notif

- (void)handleLeftViewOpened:(NSNotification *)notif
{
    [self refreshState];
}

#pragma mark - user interaction

- (IBAction)loginButtonPressed:(id)sender
{
    if(self.appManager.userInfo)
    {
        [self.appManager logout:^(NSString *msg, NSError *error) {
            if(error == nil)
                [SVProgressHUD showSuccessWithStatus:msg];
            else
                [SVProgressHUD showErrorWithStatus:msg];
            
            [self refreshState];
        }];
    }
    else
    {
        [self showLogInViewController];
    }
}

@end
