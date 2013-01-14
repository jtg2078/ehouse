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
    
    self.title = @"我的專區";
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appManager.linkInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    NSDictionary *info = self.appManager.linkInfo[indexPath.row];
    cell.textLabel.text = info[KEY_name];
    cell.imageView.image = [UIImage imageNamed:info[KEY_image]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.appManager.linkInfo[indexPath.row];
    NSString *url = [self.appManager getFullURLforLinkType:info[KEY_id]];
    
    SecondViewController *sec = [[SecondViewController alloc] initWithUrl:url];
    [self.viewDeckController.navigationController pushViewController:sec animated:YES];
    
    BOOL useFirst = YES;
    
    if(useFirst)
    {
        UINavigationController *nav = (UINavigationController *)self.viewDeckController.centerController;
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

@end
