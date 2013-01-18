//
//  BaseViewController.m
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()
@property (nonatomic, weak) AppDelegate *appDelegate;
@end

@implementation BaseViewController

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
	// Do any additional setup after loading the view.
    
    self.appManager = [EHouseManager sharedInstance];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.notifCenter = [NSNotificationCenter defaultCenter];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - utility methods

- (BOOL)is4inchScreen
{
    return [[UIScreen mainScreen ] bounds].size.height >= 568.0f;
}

@end
